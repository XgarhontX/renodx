/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <include/reshade_api_format.hpp>
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/random.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

namespace {

#define UpgradeRTVReplaceShader(value)       \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .code = __##value,                 \
          .on_draw = [](auto* cmd_list) {                                                             \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                         \
            bool changed = false;                                                                     \
            for (auto rtv : rtvs) {                                                                   \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv);   \
            }                                                                                         \
            if (changed) {                                                                            \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                    \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0}); \
            }                                                                                         \
            return true; }, \
      },                                     \
  }

#define UpgradeRTVShader(value)              \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .on_draw = [](auto* cmd_list) {                                                           \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                       \
            bool changed = false;                                                                   \
            for (auto rtv : rtvs) {                                                                 \
              changed = renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv); \
            }                                                                                       \
            if (changed) {                                                                          \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                  \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});      \
            }                                                                                       \
            return true; }, \
      },                                     \
  }

// bool OnToneMapDraw(reshade::api::command_list* cmd_list) {
//   reshade::api::resource_view current_uav0 = {g_current_uav0};
//   auto* resource_view_info = renodx::utils::resource::GetResourceViewInfo(current_uav0);
//   if (resource_view_info->resource_info == nullptr) return true;
//   if (resource_view_info->resource_info->clone_enabled) return true;
//   resource_view_info->resource_info->clone_enabled = true;
//   renodx::mods::swapchain::FlushDescriptors(cmd_list);  // Not implemented yet, will fix next draw
//   return true;
// }
  
// __ALL_CUSTOM_SHADERS
// renodx::mods::shader::CustomShaders custom_shaders_nofxaa = {
//     CustomShaderEntry(0xCCDDD1DC), //t
//     CustomSwapchainShader(0x56DEF8B0), //ui
//     CustomSwapchainShader(0x94B88448), //ui
//     CustomSwapchainShader(0x04CA9ED6), //ui
//     CustomSwapchainShader(0xBAA28AD3), //ui
//     CustomSwapchainShader(0x8148821D), //ui
//     CustomSwapchainShader(0x6C508D43), //ui
//     CustomSwapchainShader(0x1742D37E), //ui
// };

// float is_fxaa_enabled = true;
renodx::mods::shader::CustomShaders custom_shaders = {
    UpgradeRTVReplaceShader(0xCCDDD1DC), //t
    UpgradeRTVReplaceShader(0xF01B1E1D), //t
    UpgradeRTVReplaceShader(0x76E1C947), //LUT Builder
    // {
    //     0x451C23ED, //fxaa
    //     {
    //         .crc32 = 0x451C23ED,
    //         .code = __0x451C23ED,
    //         .on_replace = [](auto* cmd_list) {
    //           return is_fxaa_enabled; //replace with return is disabled.
    //         },
    //         // .on_draw = [](auto* cmd_list) {
    //         //   return is_fxaa_enabled == 0; //replace with return is disabled.
    //         // },
    //     }
    // },
    // CustomSwapchainShader(0x451C23ED), //fxaa
    CustomSwapchainShader(0x56DEF8B0), //ui
    CustomSwapchainShader(0x94B88448), //ui
    CustomSwapchainShader(0x04CA9ED6), //ui
    CustomSwapchainShader(0xBAA28AD3), //ui
    CustomSwapchainShader(0x8148821D), //ui
    CustomSwapchainShader(0x6C508D43), //ui
    CustomSwapchainShader(0x1742D37E), //ui
};
renodx::mods::shader::CustomShaders custom_shaders_nofxaa = {
    UpgradeRTVReplaceShader(0xCCDDD1DC), //t
    UpgradeRTVReplaceShader(0xF01B1E1D), //t
    UpgradeRTVReplaceShader(0x76E1C947), //LUT Builder
    CustomSwapchainShader(0x451C23ED), //fxaa
    CustomSwapchainShader(0x56DEF8B0), //ui
    CustomSwapchainShader(0x94B88448), //ui
    CustomSwapchainShader(0x04CA9ED6), //ui
    CustomSwapchainShader(0xBAA28AD3), //ui
    CustomSwapchainShader(0x8148821D), //ui
    CustomSwapchainShader(0x6C508D43), //ui
    CustomSwapchainShader(0x1742D37E), //ui
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

auto* setting_Encoding = new renodx::utils::settings::Setting{
    .key = "SwapChainEncoding",
    .binding = &shader_injection.swap_chain_encoding,
    .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    .default_value = 5.f,
    .label = "Encoding",
    .section = "Display Output",
    .labels = {"None (Unknown)", "SRGB (Unsupported)", "2.2 (Unsupported)", "2.4 (Unsupported)", "HDR10 (BT2020)", "scRGB (BT709)"},
    .on_change_value = [](float previous, float current) {
      bool is_hdr10 = current == 4;
      shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f);
      // return void
    },
    .is_global = true,
    // .is_visible = []() { return current_settings_mode >= 2; },
};

auto* setting_Peak = new renodx::utils::settings::Setting{
    .key = "ToneMapPeakNits",
    .binding = &shader_injection.peak_white_nits,
    .default_value = 1000.f,
    .can_reset = false,
    .label = "Peak Brightness",
    .section = "Brightness",
    .tooltip = "Sets the value of peak white in nits",
    .min = 48.f,
    .max = 4000.f,
};

auto* setting_Fxaa = new renodx::utils::settings::Setting{
    .key = "FxaaEnabled",
    // .binding = &is_fxaa_enabled,
    .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    .default_value = 1.f,
    .can_reset = false,
    .label = "FXAA Enabled (Restart Required)",
    .section = "FXAA",
    .tooltip = "Requires a restart to take effect.\nCrazy technical difficulties prevent dynamic toggling of FXAA.",
    .tint = 0xff7a59,
    .is_global = true,
    // .parse = [](float value) { 
    //     // bool prev = is_fxaa_enabled == 0;
    //     // is_fxaa_enabled = value == 0;
    //     // if (prev != is_fxaa_enabled)
    //     // {
    //     //     if (is_fxaa_enabled) {
    //     //         renodx::utils::shader::AddRuntimeReplacement(renodx::utils::swapchain::get, 0x451C23ED, __0x451C23ED);
    //     //     } else {
    //     //         renodx::utils::shader::RemoveRuntimeReplacements((reshade::api::device*)0, {0x451C23ED});
    //     //     }
    //     // }
    //     return value; 
    // },
};

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Normal", "Hard", "Hell on Earth"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Reset All",
        .group = "button-line-1",
        .on_change = []() {
          for (auto* setting : settings) {
            if (setting->key.empty()) continue;
            if (!setting->can_reset) continue;
            renodx::utils::settings::UpdateSetting(setting->key, setting->default_value);
          }
          renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },

    // ReadMe //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Use Borderless Fullscreen if Exclusive doesn't work.",
        .section = "Read Me",
    },
    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BULLET,
    //     .label = "For now, requires FXAA.\nPlease disable the addon and turn on FXAA.\nYou can skip the pass below.",
    //     .section = "Read Me",
    // },

    // FXAA //////////////////////////////////////////////////////////////////////////////////////
    setting_Fxaa,

    // Brightness //////////////////////////////////////////////////////////////////////////////////////

    setting_Peak,

    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Brightness",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Brightness",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Brightness",
        .tooltip = "Emulates a display EOTF.\n(Windows requires this.)",
        .labels = {"Off", "2.2", "2.4 (BT.1886)"},
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction UI",
        .section = "Brightness",
        .tooltip = "Emulates a display EOTF for UI.\n(Windows requires this.)",
        .labels = {"Off", "2.2", "2.4 (BT.1886)"},
        // .is_visible = []() { return current_settings_mode >= 2; },
    },

    // Tone Mapper //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "RenoDRTMethod",
        .binding = &shader_injection.custom_renodrt_tone_map_method,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "RenoDRT Method",
        .section = "Tone Mapping",
        .tooltip = "Reinhard is more gradual, while Exponential Rolloff is more aggressive.",
        .labels = {"Reinhard", "DICE Exponential Rolloff"},
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tone_map_type == 3; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tone_map_type == 3; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 0.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Peak",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    // Color Grading //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 3; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 3; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 90.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    // Extra //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "custom_bloom_multiplier",
        .binding = &shader_injection.custom_bloom_multiplier,
        .default_value = 100.f,
        .label = "Bloom",
        .section = "Extra",
        .tooltip = "Amount of bloom.",
        .max = 300.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_vignette_multiplier",
    //     .binding = &shader_injection.custom_vignette_multiplier,
    //     .default_value = 100.f,
    //     .label = "Vignette",
    //     .section = "Extra",
    //     .tooltip = "Vignette multiplier",
    //     .max = 200.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "custom_filmgrain_multiplier",
        .binding = &shader_injection.custom_filmgrain_multiplier,
        .default_value = 0.f,
        .label = "Film Grain (Alt)",
        .section = "Extra",
        .tooltip = "Alternative RenoDX perceptual film grain because the default is some cheese.",
        .max = 200.f,
        .parse = [](float value) { return value * 0.01f * 0.05f; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_ssr_multiplier",
        .binding = &shader_injection.custom_ssr_multiplier,
        .default_value = 100.f,
        .label = "Screen Space Reflections",
        .section = "Extra",
        .tooltip = "Alternative RenoDX perceptual film grain because the default is some cheese.",
        .max = 300.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_lens_multiplier",
    //     .binding = &shader_injection.custom_lens_multiplier,
    //     .default_value = 130.f,
    //     .label = "Lens Flare",
    //     .section = "Extra",
    //     .tooltip = "Lens Flare.\nEach distinct flare is a unique shader, so unknown if all are accounted for.",
    //     .max = 200.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_aa",
    //     .binding = shader_injection.custom_aa,
    //     .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 1.f,
    //     .label = "FXAA",
    //     .section = "Extra",
    //     .tooltip = "Do or skip the FXAA pass.\nYou probably want it on, else SSR has uncleaned fireflies.",
    // },
    new renodx::utils::settings::Setting{
        .key = "custom_is_ui",
        .binding = &shader_injection.custom_is_ui,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI",
        .section = "Extra",
        .tooltip = "Not comprehensive, but should be enough to pause and take screenshots.\nSome ADS sights may turn off too.",
    },

    // PreExposure //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "custom_preexposure_multiplier",
        .binding = &shader_injection.custom_preexposure_multiplier,
        .default_value = 1.f,
        .label = "Multiplier",
        .section = "PreExposure",
        .tooltip = "Exposure multiplier on HDR color before updgrading with SDR.",
        .max = 3.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "custom_preexposure_contrast",
        .binding = &shader_injection.custom_preexposure_contrast,
        .default_value = 1.3f,
        .label = "Contrast",
        .section = "PreExposure",
        .tooltip = "Contrast on HDR color before updgrading with SDR.\nTurn off Scene Grading and check if it matches Vanilla colors.",
        .max = 2.0f,
        .format = "%.3f",
    },    
    new renodx::utils::settings::Setting{
        .key = "custom_preexposure_contrast_mid",
        .binding = &shader_injection.custom_preexposure_contrast_mid,
        .default_value = 0.18f,
        .label = "Constrast Mid Gray",
        .section = "PreExposure",
        .tooltip = "Mid gray of contrast adjustment.",
        // .min = -1.0f,
        .max = 1.f,
        .format = "%.3f",
    },

    // // Per Channel Correction //////////////////////////////////////////////////////////////////////////////////////
    // new renodx::utils::settings::Setting{
    //     .key = "custom_pcc_strength",
    //     .binding = &shader_injection.custom_pcc_strength,
    //     .default_value = 30.f,
    //     .label = "Amount",
    //     .section = "Per Channel Correction",
    //     .tooltip = "Mitigate perchannel blowout by SDR tonemapping.\nVisible with stuff like fire.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_pcc_pow",
    //     .binding = &shader_injection.custom_pcc_pow,
    //     .default_value = 1.2f,
    //     .label = "Highlights Only",
    //     .section = "Per Channel Correction",
    //     .tooltip = "Increase to only affect highlights. (strength = pow(luma01, value))",
    //     .max = 2.0f,
    //     .format = "%.2f",
    //     // .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },

    // // Dual LUT //////////////////////////////////////////////////////////////////////////////////////
    // new renodx::utils::settings::Setting{
    //     .key = "custom_duallut_strength",
    //     .binding = &shader_injection.custom_duallut_strength,
    //     .default_value = 30.f,
    //     .label = "Amount",
    //     .section = "Dual LUT Sampling",
    //     .tooltip = "Mitigate blowout & clipping by SDR LUT with a secondary sample.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_duallut_samplemultiplier",
    //     .binding = &shader_injection.custom_duallut_samplemultiplier,
    //     .default_value = 0.87f,
    //     .label = "Exposure",
    //     .section = "Dual LUT Sampling",
    //     .tooltip = "Multiplier of tonemapped color for secondary sample.",
    //     .min = 0.01f,
    //     .max = 0.99f,
    //     .format = "%.2f",
    //     // .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_duallut_pow",
    //     .binding = &shader_injection.custom_duallut_pow,
    //     .default_value = 1.7f,
    //     .label = "Highlights Only",
    //     .section = "Dual LUT Sampling",
    //     .tooltip = "Increase to only affect highlights. (strength = pow(luma01, value))",
    //     .max = 2.0f,
    //     .format = "%.2f",
    //     // .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },

    // Advanced //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        // .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.gamma_correction + 1.f;
            return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        // .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.intermediate_encoding;
            return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        // .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    setting_Encoding,

    // Credits & Buttons //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Game Mod: XgarhontX\n",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "RenoDX: clshortfuse\n",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "RenoDX Discord",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "gF4GRJWZ2A");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "HDRDen Discord",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More RenoDX Mods",
        .section = "Credits",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Build Date: " + build_date + " - " + build_time,
        .section = "Credits",
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("TtoneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGammaCorrection", 0);
  renodx::utils::settings::UpdateSetting("ColorGradeExposure", 1.f);
  renodx::utils::settings::UpdateSetting("ColorGradeHighlights", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeShadows", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeContrast", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeSaturation", 50.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTStrength", 100.f);
  renodx::utils::settings::UpdateSetting("ColorGradeLUTScaling", 0.f);
}

bool initialized = false;

}  // namespace

// from tombraider2013 de
bool fired_on_init_swapchain = false;
void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  if (fired_on_init_swapchain) return;
  fired_on_init_swapchain = true;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  auto white_level = 203.f;
  if (!peak.has_value()) {
    peak = 1000.f;
  }

  // find and set
  setting_Peak->default_value = peak.value();
  setting_Peak->can_reset = true;

  // settings[3]->default_value = renodx::utils::swapchain::ComputeReferenceWhite(peak.value());
}

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Killing Floor 2)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        // renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        // renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::trace_unmodified_shaders = true;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
        };

        renodx::mods::swapchain::force_borderless = false;
        // renodx::mods::swapchain::prevent_full_screen = false;

        {
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting_Encoding);
          bool is_hdr10 = setting_Encoding->GetValue() == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = setting_Encoding->GetValue() < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
        //   settings.push_back(setting);
        }

        //Tex Upgrades
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({ //color buffer
            .old_format = reshade::api::format::r11g11b10_float,
            .new_format = reshade::api::format::r16g16b16a16_float,
            // .ignore_size = true,
            // .use_resource_view_cloning = true,
            // .use_resource_view_hot_swap = true,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({ //after tonemap
          .old_format = reshade::api::format::r8g8b8a8_unorm, 
          .new_format = reshade::api::format::r16g16b16a16_float,
          .ignore_size = true,
          .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = true,
          .usage_include = reshade::api::resource_usage::render_target,
        });
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({ //LUT
        //   .old_format = reshade::api::format::r8g8b8a8_unorm, 
        //   .new_format = reshade::api::format::r16g16b16a16_float,
        // //   .ignore_size = true,
        // //   .use_resource_view_cloning = true,
        // //   .use_resource_view_hot_swap = true,
        //   .dimensions = {.width = 256, .height = 16, .depth = 0},
        //   .usage_include = reshade::api::resource_usage::render_target,
        // });

        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
        renodx::utils::random::binds.push_back(&shader_injection.seed); // random


        //setting_Fxaa & shaders
        {
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting_Fxaa);
          if (!setting_Fxaa->GetValue()) renodx::mods::shader::Use(fdw_reason, custom_shaders_nofxaa, &shader_injection); 
          else renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection); 
        }
        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
//   renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
