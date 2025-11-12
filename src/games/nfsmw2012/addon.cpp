/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <cstdint>
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

ShaderInjectData shader_injection;

#define UpgradeRTVReplaceShaderAdv(value, isReplaceShader)       \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .code = __##value,                 \
          .on_replace = [](auto* cmd_list) {  \
            return isReplaceShader; \
          }, \
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
            return isReplaceShader; \
          }, \
      },                                     \
  }

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


renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
    // UpgradeRTVReplaceShader(0x53704FC4),
    // UpgradeRTVReplaceShader(0xE2BFE51F),
    // UpgradeRTVReplaceShader(0xCD52A883),
};

// // Presets //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// void ApplyPresets(const renodx::utils::settings::Settings& settings, const std::vector<std::unordered_map<std::string, float>>& presets) {
//   for (auto* setting : settings) {
//     // skip if not exist or not resettable
//     if (setting->key.empty()) continue;
//     if (!setting->can_reset) continue;

//     // n
//     for (std::unordered_map<std::string, float> preset : presets) {
//       if (preset.contains(setting->key)) {
//         // get
//         float value = preset.at(setting->key);

//         // case: reset
//         if (value == FLT_MIN) value = setting->default_value;

//         // set
//         renodx::utils::settings::UpdateSetting(setting->key, value);

//         // skip other presets
//         continue;
//       }
//     }
//   }

//   // save
//   renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
// }

// const std::unordered_map<std::string, float> PRESET_RENODRT = {
//     {"ToneMapType", FLT_MIN},
// };

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

// Settings //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
float current_settings_mode = 0;
renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"EASY", "MEDIUM", "HARD"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 0.f,
        .can_reset = false,
        .label = "FPS Limit",
        .tooltip = "Swapchain FPS limiter.",
        .min = 0.f,
        .max = 1000.f,
        .format = "%.3f",
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

    // Presets //////////////////////////////////////////////////////////////////////////////////////

    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: RenoDRT (Full HDR)",
    //     .group = "button-line-2",
    //     .tooltip = "Fully use HDR luminance with SDR chrominace as color corrections.\n"
    //                "(Works for all Treyarch maps. since they have minor luma correction.)",
    //     .tint = 0xcc56c2,
    //     .on_change = []() {
    //       ApplyPresets(settings, {PRESET_RENODRT, PRESET_TRADEOFF_BALANCED});
    //     },
    // },

    // Read Me //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Swapchain Proxy Shaders, the ones that handle decoding, is broken for this game.\nDid you download the ReShade effect to use in its place?\nAnd all the SwapChain seetings here is placeholder until it works.",
        .section = "Read Me",
    },    
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Super Sampling can break texture upgrade (makes color tex != aspect ratio).\nTry disabling, or using the other multiplier.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "Gamma Correction in-game setting was 24% when I developed it.",
        .section = "Read Me",
    },

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
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Brightness",
        .tooltip = "Emulates a display EOTF.\n"
                   "(For Windows HDR missing correction.)",
        .labels = {"Off", "2.2", "2.4 (BT.1886)"},
        // .is_visible = []() { return current_settings_mode >= 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction UI",
        .section = "Brightness",
        .tooltip = "Emulates a display EOTF.\n"
                   "(For Windows HDR missing correction.)",
        .labels = {"None", "2.2", "2.4 (BT.1886)"},
        // .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        // .is_visible = []() { return current_settings_mode >= 2; },
    },

    // Tonemap //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type.\n"
                   "- ACES is not recommended if you want to keep to stay true to the original chroma.",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
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
        .is_visible = []() { return current_settings_mode >= 2; },
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

    // Color Grade //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 0; },
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
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
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
    // new renodx::utils::settings::Setting{
    //     .key = "CustomGradeChroma",
    //     .binding = &shader_injection.custom_grade_chroma,
    //     .default_value = 90.f,
    //     .label = "Chroma Grading",
    //     .section = "Color Grading",
    //     .tooltip = "Scene grading as applied by the game on chrominace.\n"
    //                "- Like 100%, you want this on to apply LUT.",
    //     // .tint = 0xcc56c2,
    //     .max = 100.f,
    //     .is_enabled = []() { return shader_injection.tone_map_type > 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomGradeLuma",
    //     .binding = &shader_injection.custom_grade_luma,
    //     .default_value = 80.f,
    //     .label = "Luma Grading",
    //     .section = "Color Grading",
    //     .tooltip = "Scene grading as applied by the game on luminance.\n"
    //                "- Turning it in down linearizes the color. You can be the one to apply grading yourself.",
    //     // .tint = 0xcc56c2,
    //     .max = 100.f,
    //     .is_enabled = []() { return shader_injection.tone_map_type > 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading Final",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game in total.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },

    // Extra //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "custom_bloom",
        .binding = &shader_injection.custom_bloom,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.0f,
        .label = "Bloom",
        .section = "Extra",
        .tooltip = "Bloom multiplier.\nBtw, exposure accounts for bloom too.",
        .max = 2.f,
        .format = "%.2f",
    },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_filmgrain",
    //     .binding = &shader_injection.custom_filmgrain,
    //     .value_type = renodx::utils::settings::SettingValueType::FLOAT,
    //     .default_value = 0.0f,
    //     .label = "Film Grain (Vanilla)",
    //     .section = "Extra",
    //     .tooltip = "Film grain multiplier.\n"
    //                "(Ugly because it's static.)",
    //     .max = 2.f,
    //     .format = "%.2f",
    // },    
    // new renodx::utils::settings::Setting{
    //     .key = "custom_filmgrain_reno",
    //     .binding = &shader_injection.custom_filmgrain_reno,
    //     .value_type = renodx::utils::settings::SettingValueType::FLOAT,
    //     .default_value = 0.f,
    //     .label = "Film Grain (RenoDX)",
    //     .section = "Extra",
    //     .tooltip = "Film grain multiplier.",
    //     .max = 0.2f,
    //     .format = "%.3f",
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_vignette",
    //     .binding = &shader_injection.custom_vignette,
    //     .value_type = renodx::utils::settings::SettingValueType::FLOAT,
    //     .default_value = 1.0f,
    //     .label = "Vignette",
    //     .section = "Extra",
    //     .tooltip = "Vignette multiplier.",
    //     .max = 2.f,
    //     .format = "%.2f",
    // },
    new renodx::utils::settings::Setting{
        .key = "custom_lens",
        .binding = &shader_injection.custom_lens,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.0f,
        .label = "Lens Dirt Main",
        .section = "Extra",
        .tooltip = "Main static lens dirt multiplier.",
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "custom_fxaa",
        .binding = &shader_injection.custom_fxaa,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.0f,
        .label = "Post AA",
        .section = "Extra",
        .tooltip = "Skip the Anti-Alias pass (FXAA or SMAA, idk).",
        // .max = 2.f,
        // .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "CustomIsUI",
        .binding = &shader_injection.custom_is_ui,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI",
        .section = "Extra",
        .tooltip = "Not comprehensive, but should be enough to pause and take screenshots.",
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
        .default_value = 1.0f,
        .label = "Contrast",
        .section = "PreExposure",
        .tooltip = "Contrast on HDR color before updgrading with SDR.\nTurn off Scene Grading and check if it matches Vanilla colors.",
        .max = 2.0f,
        .format = "%.3f",
    },    
    new renodx::utils::settings::Setting{
        .key = "custom_preexposure_contrast_mid",
        .binding = &shader_injection.custom_preexposure_contrast_mid,
        .default_value = 0.25f,
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

    // Dual LUT //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "custom_duallut_strength",
        .binding = &shader_injection.custom_duallut_strength,
        .default_value = 30.f,
        .label = "Amount",
        .section = "Dual LUT Sampling",
        .tooltip = "Mitigate blowout & clipping by SDR LUT with a secondary sample.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_duallut_samplemultiplier",
        .binding = &shader_injection.custom_duallut_samplemultiplier,
        .default_value = 0.65f,
        .label = "Exposure",
        .section = "Dual LUT Sampling",
        .tooltip = "Multiplier of tonemapped color for secondary sample.",
        .min = 0.01f,
        .max = 0.99f,
        .format = "%.2f",
        // .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_duallut_pow",
        .binding = &shader_injection.custom_duallut_pow,
        .default_value = 1.7f,
        .label = "Highlights Only",
        .section = "Dual LUT Sampling",
        .tooltip = "Increase to only affect highlights. (strength = pow(luma01, value))",
        .max = 2.0f,
        .format = "%.2f",
        // .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },

    // Display Output //////////////////////////////////////////////////////////////////////////////////////

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
        .is_visible = []() { return settings[0]->GetValue() >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateEncoding",
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

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

bool initialized = false;

}  // namespace

// DllMain //////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// from tombraider2013 de
void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  //   if (initialized) return;

  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  //   auto white_level = 203.f;
  if (!peak.has_value()) peak = 1000.f;

  //set
  setting_Peak->default_value = peak.value();
  setting_Peak->can_reset = true;

  // settings[3]->default_value = renodx::utils::swapchain::ComputeReferenceWhite(peak.value());
}

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX Need for Speed: Most Wanted 2012)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        // renodx::mods::shader::force_pipeline_cloning = true;
        // renodx::mods::shader::use_pipeline_layout_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        // renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        // renodx::mods::swapchain::use_shared_device = true;
        // renodx::mods::swapchain::use_device_proxy = true;
        renodx::mods::swapchain::set_color_space = true;
        // renodx::mods::swapchain::swapchain_proxy_revert_state = true;
        // renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
        // renodx::mods::swapchain::swap_chain_proxy_shaders = { //THESE ARE BROKEN FOR THIS GAME! "mods::swapchain::DrawSwapChainProxy(Pipeline creation failed.)"
        //     {
        //         reshade::api::device_api::d3d11,
        //         {
        //             .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
        //             .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
        //         },
        //     },
        //     // {
        //     //     reshade::api::device_api::d3d12,
        //     //     {
        //     //         .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
        //     //         .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
        //     //     },
        //     // },
        // };

        renodx::mods::swapchain::force_borderless = false;
        // renodx::mods::swapchain::prevent_full_screen = false;

        {
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting_Encoding);
          bool is_hdr10 = setting_Encoding->GetValue() == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = setting_Encoding->GetValue() < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
          settings.push_back(setting_Encoding);

          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r8g8b8a8_unorm,
              .new_format = reshade::api::format::r16g16b16a16_typeless,
            //   .ignore_size = true,
            //   .use_resource_view_cloning = true,
            //   .use_resource_view_hot_swap = true,
              .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            //   .usage_include = reshade::api::resource_usage::resolve_dest,
              .usage_include = reshade::api::resource_usage::render_target,
          });   
          renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
              .old_format = reshade::api::format::r8g8b8a8_typeless,
              .new_format = reshade::api::format::r16g16b16a16_typeless,
            //   .ignore_size = true,
            //   .use_resource_view_cloning = true,
            //   .use_resource_view_hot_swap = true,
              .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            //   .usage_include = reshade::api::resource_usage::resolve_dest,
              .usage_include = reshade::api::resource_usage::render_target,
          });
          renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
        }

        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
        // renodx::utils::random::binds.push_back(&shader_injection.seed); // random

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
      reshade::unregister_addon(h_module);
      break;
  }

//   renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);

  return TRUE;
}
