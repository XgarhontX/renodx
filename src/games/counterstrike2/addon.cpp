/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */
#define MOD_NAME "Counter Strike 2"

#include <vector>
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

// #define RANDOM_ENABLED
#ifdef RANDOM_ENABLED
#include "../../utils/random.hpp"
#define RANDOM_FLOAT &shader_injection.random_seed
#endif

// #define SWAPCHAIN_PROXY_DX12_ENABLED

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

#define ALT_BUTTON_COLOR 0xff8800
// #define TEST #ff8800ff

namespace {

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
            return true; \
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
            return true; \
          }, \
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
renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
  // UpgradeRTVReplaceShader(0xF809D8F2),
  // UpgradeRTVReplaceShader(0x0C458934),
  // UpgradeRTVReplaceShader(0xEF78BCCF),

  // UpgradeRTVReplaceShader(0x394AB09E),
  // UpgradeRTVReplaceShader(0xE4F0DD47),
  // UpgradeRTVReplaceShader(0x7D6F34CB),
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

// Presets //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void ApplyPresets(const renodx::utils::settings::Settings& settings, const std::vector<std::unordered_map<std::string, float>>& presets) {
  for (auto* setting : settings) {
    // skip if not exist or not resettable
    if (setting->key.empty()) continue;
    if (!setting->can_reset) continue;

    // n
    for (std::unordered_map<std::string, float> preset : presets) {
      if (preset.contains(setting->key)) {
        // get
        float value = preset.at(setting->key);

        // case: reset
        if (value == FLT_MIN) value = setting->default_value;

        // set
        renodx::utils::settings::UpdateSetting(setting->key, value);

        // skip other presets
        continue;
      }
    }
  }

  // save
  renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
}

// const std::unordered_map<std::string, float> PRESET_RENODRT = {
//     {"ToneMapType", FLT_MIN},
// };

// Settings //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Rush B", "Execute Site", "Retake Inferno B"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 0.f,
        .can_reset = false,
        .label = "FPS Limit",
        // .section = "FPS Limit",
        .tooltip = "Swapchain FPS limiter",
        .min = 0.f,
        .max = 240.f,
        .format = "%.3f",
        // .parse = [](float value) { return value * 2.f; },
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

    // Presets //////////////////////////////////////////////////////////////////////////////////////

    // new renodx::utils::settings::Setting{
    //     .value_type = renodx::utils::settings::SettingValueType::BUTTON,
    //     .label = "Preset: RenoDRT (Full HDR)",
    //     .group = "button-line-2",
    //     .tooltip = "Fully use HDR luminance with SDR chrominace as color corrections.\n"
    //                "(Works for all Treyarch maps. since they have minor luma correction.)",
    //     .tint = ALT_BUTTON_COLOR,
    //     .on_change = []() {
    //       ApplyPresets(settings, {PRESET_RENODRT, PRESET_TRADEOFF_BALANCED});
    //     },
    // },

    // Read Me //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Responds to in-game Brightness settings (Default: 93%).",
        .section = "Read Me",
    },

    // Brightness //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Brightness",
        .tooltip = "Sets the value of peak white in nits",
        .min = 1.f,
        .max = 4000.f,
    },

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
        .tooltip = "Emulates a display EOTF for color.\n"
                   "(For Windows HDR missing EOTF.)",
        .labels = {"Off", "2.2", "BT.1886"},
        // .is_visible = []() { return current_settings_mode >= 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction UI",
        .section = "Brightness",
        .tooltip = "Emulates a display EOTF for UI.\n"
                   "(For Windows HDR missing EOTF.)",
        .labels = {"None", "2.2", "2.4"},
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
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "None", "ACES", "RenoDRT"},
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_visible = []() { return current_settings_mode >= 1; },
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
        .default_value = 1.f,
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
        .default_value = 1.f,
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
        // .is_visible = []() { return current_settings_mode >= 1; },
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
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomLutMode",
    //     .binding = &shader_injection.custom_lut_mode,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "LUT Sampling",
    //     .section = "Color Grading",
    //     .tooltip = "How to sample the LUT.\n"
    //                "Tetrahedral samples multiple times to get better accuracy, though maybe unnoticeable.",
    //     .labels = {"Single", "Tetrahedral"},
    //     // .tint = ALT_BUTTON_COLOR,
    //     // .format = "%.4f",
    //     // .is_enabled = []() { return shader_injection.tone_map_type > 0 && shader_injection.custom_grade_luma < 1; },
    //     // .parse = [](float value) {
    //     //     if (value == 0) return 0.f;
    //     //     if (value == 1) return 0.0019f;
    //     //     if (value == 2) return 0.0034f;
    //     //     return 0.f; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },

    new renodx::utils::settings::Setting{
        .key = "CustomGradeChroma",
        .binding = &shader_injection.custom_grade_chroma,
        .default_value = 90.f,
        .label = "Chroma Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game on chrominace.\n"
                   "- Like 100%, you want this on to apply LUT.",
        // .tint = ALT_BUTTON_COLOR,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomGradeLuma",
        .binding = &shader_injection.custom_grade_luma,
        .default_value = 50.f,
        .label = "Luma Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game on luminance.\n"
                   "- Turning it in down linearizes the color. You can be the one to apply grading yourself.\n"
                   "- For pretty much all Treyarch maps, it looks pretty good if off.\n"
                   "- Some custom maps relying on extreme contrast grading will probably need it dailed up.",
        // .tint = ALT_BUTTON_COLOR,
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },

    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
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
        .default_value = 1.f,
        .label = "Bloom",
        .section = "Extra",
        .tooltip = "Bloom multiplier.",
        .max = 2.f,
        .format = "%.2f",
        // .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_ui_healthbarmutliplier",
        .binding = &shader_injection.custom_ui_healthbarmutliplier,
        .default_value = 0.1f,
        .label = "UI Multiply",
        .section = "Extra",
        .tooltip = "Avatar health bar, and other nonconsequencial UI elems.",
        .max = 1.f,
        .format = "%.2f",
        // .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_ui_showversiontext",
        .binding = &shader_injection.custom_ui_showversiontext,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "UI Simple Draw",
        .section = "Extra",
        .tooltip = "Version text bottom left, and SG/AUG scopes.",
        // .max = 1.f,
        // .format = "%.2f",
        // .parse = [](float value) { return value * 0.01f; },
    },

    // new renodx::utils::settings::Setting{
    //     .key = "custom_1",
    //     .binding = &shader_injection.custom_1,
    //     // .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 0.f,
    //     .label = "1",
    //     .section = "Extra",
    //     .tooltip = "Placeholder.",
    //     .max = 10.f,
    //     .format = "%.3f",
    //     // .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_2",
    //     .binding = &shader_injection.custom_2,
    //     // .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
    //     .default_value = 0.f,
    //     .label = "2",
    //     .section = "Extra",
    //     .tooltip = "Placeholder.",
    //     .max = 10.f,
    //     .format = "%.3f",
    //     // .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },

    // new renodx::utils::settings::Setting{
    //     .key = "CustomADSSights",
    //     .binding = &shader_injection.custom_ads_sights,
    //     .default_value = 50.f,
    //     .label = "ADS Sights",
    //     .section = "Extra",
    //     .tooltip = "Should be all vanilla sights, but maybe I missed some.\n"
    //                "Also, if mods do their own sights shader, then it's F.",
    //     .max = 100.f,
    //     .parse = [](float value) { return value * 0.01f; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomXrayOutline",
    //     .binding = &shader_injection.custom_xray_outline,
    //     .default_value = 100.f,
    //     .label = "Xray Outline",
    //     .section = "Extra",
    //     .tooltip = "Other players and important items / objectives.",
    //     .max = 200.f,
    //     .parse = [](float value) { return value * 0.01; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomMotionBlurScale",
    //     .binding = &shader_injection.custom_motionblur_scale,
    //     .default_value = 1.f,
    //     .label = "Motion Blur Scale",
    //     .section = "Extra",
    //     .tooltip = "Motion vector sampling length scale.",
    //     .min = 0.1f,
    //     .max = 2.f,
    //     .format = "%.2f",
    // },

    // PreExposure //////////////////////////////////////////////////////////////////////////////////////

    // new renodx::utils::settings::Setting{
    //     .key = "CustomTonemapDebug",
    //     .binding = &shader_injection.custom_tonemap_debug,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0,
    //     .label = "Debug View",
    //     .section = "Pre-ToneMapPass: PreExposure",
    //     .tooltip = "- Off: Normal rendering.\n"
    //                "- Heat Map: Luma categorized by RenoDRT (Pink (shadow), Green (mid), Gray (high), Cyan (clip)).\n"
    //                "- Calibration: If needed, calibrate PreExposure so that 1st/2nd matches 3rd for midtones. (color_untonemapped / color_sdr_neutral / color_sdr_graded)",
    //     .labels = {"Off", "Heat Map", "Calibration"},
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },
    new renodx::utils::settings::Setting{
        .key = "CustomPreExposure",
        .binding = &shader_injection.custom_preexposure,
        .default_value = 1.f,
        .label = "PreExposure",
        .section = "Pre-ToneMapPass: PreExposure",
        .tooltip = "Scale the color_untonemapped & color_sdr_neutral input by the multiplier.\n"
                   "- If Luma Grading is on, this will only boost highlights.\n"
                   "- Else it's just exposure.",
        .max = 4.f,
        .format = "%.3f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "CustomPreExposureRatio",
        .binding = &shader_injection.custom_preexposure_ratio,
        .default_value = 1.f,
        .label = "PreExposure Ratio",
        .section = "Pre-ToneMapPass: PreExposure",
        .tooltip = "Untonemapped to SDR Neutral color multiplier ratio.\n"
                   "- Regardless of Luma Grading, this acts like exposure.\n"
                   "- However, if Luma Grading is on, changing this can shift where and how the grading applied.",
        // .tint = ALT_BUTTON_COLOR,
        .max = 2.f,
        .format = "%.3f / 1",
        // .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_brightnessoffset",
        .binding = &shader_injection.custom_brightnessoffset,
        .default_value = 1.2f,
        .label = "Untonemapped Gamma Offset",
        .section = "Pre-ToneMapPass: PreExposure",
        .tooltip = "In-game Brightness setting offset (gamma/pow) on Untonemapped color.",
        // .tint = ALT_BUTTON_COLOR,
        .max = 3.f,
        .format = "%.2f",
        // .is_visible = []() { return current_settings_mode >= 2; },
    },

    // // Pre-ToneMapPass //////////////////////////////////////////////////////////////////////////////////////

    // new renodx::utils::settings::Setting{
    //     .key = "CustomDiceShoulder",
    //     .binding = &shader_injection.custom_dice_shoulderstart,
    //     .default_value = 20.f,
    //     .label = "Shoulder Threshold",
    //     .section = "Pre-ToneMapPass: Untonemapped DICE",
    //     .tooltip = "Threshold (not linear nits value) to start compressing color_untonemapped.\n"
    //                "1 = Game Brightness (Max SDR)\n"
    //                "100 = Peak Brightness",
    //     .min = 0.01f,
    //     .max = 100.0f,
    //     .format = "%.2f",
    //     .parse = [](float value) { return value; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "CustomDicePower",
    //     .binding = &shader_injection.custom_dice_power,
    //     .default_value = 0.75f,
    //     .label = "Shoulder Power",
    //     .section = "Pre-ToneMapPass: Untonemapped DICE",
    //     .tooltip = "If color_untonemapped's luminance > threshold, aprroximately color * pow.",
    //     .min = 0.f,
    //     .max = 2.f,
    //     .format = "%.2f",
    //     .parse = [](float value) { return value; },
    //     .is_visible = []() { return current_settings_mode >= 1; },
    // },

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
          renodx::utils::platform::LaunchURL("https://discord.gg/", "9Bm4RZA8");
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
        .label = "More Mods",
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
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        // .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.gamma_correction + 1.f;
            return value - 1.f; 
        },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        // .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) {
            if (value == 0) return shader_injection.intermediate_encoding;
            return value - 1.f; 
        },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        // .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return current_settings_mode >= 2; },
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
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (!peak.has_value()) peak = 1000.f;
  auto paper = renodx::utils::swapchain::ComputeReferenceWhite(peak.value());

  // find and set
  bool isPeak = false;
  bool isPaper = true;
  bool isUi = true;
  for (auto& setting : settings) {
    if (isPeak && isPaper && isUi) break;
    if (!isPeak && setting->binding == &shader_injection.peak_white_nits) {
      setting->default_value = peak.value();
      setting->can_reset = true;
      isPeak = true;
    } else if (!isPaper && setting->binding == &shader_injection.diffuse_white_nits) {
      setting->default_value = paper;
      setting->can_reset = true;
      isPaper = true;
    } else if (!isUi && setting->binding == &shader_injection.graphics_white_nits) {
      setting->default_value = paper;
      setting->can_reset = true;
      isUi = true;
    }
  }
}

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (" MOD_NAME ")";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {

        // Shader ///////////////////////////////////////////////////////////////////

        // renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = CBUFFER;
        // renodx::mods::shader::constant_buffer_offset = 50 * 4;  // From spec ops the line
        // renodx::mods::shader::allow_multiple_push_constants = true;
        // renodx::mods::shader::revert_constant_buffer_ranges = true;
        // renodx::mods::shader::use_pipeline_layout_cloning = true; 
        // renodx::mods::shader::push_injections_on_present = true; 



        // Swapchain ///////////////////////////////////////////////////////////////////

        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::expected_constant_buffer_index = CBUFFER;
        
        renodx::mods::swapchain::use_resource_cloning = true; //true, else swapchain doesnt work
        // renodx::mods::swapchain::use_device_proxy = true; //no and unnessary

        // renodx::mods::swapchain::set_color_space = false;
        // renodx::mods::swapchain::use_shared_device = true;
        // renodx::mods::swapchain::swapchain_proxy_revert_state = true;
        // renodx::mods::swapchain::upgrade_resource_views = false;
        // renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;
        // renodx::mods::swapchain::force_screen_tearing = false;
        // renodx::mods::swapchain::upgrade_resource_views = false;
        // renodx::mods::swapchain::use_resize_buffer = true;
        // renodx::mods::swapchain::use_resize_buffer_on_set_full_screen = true;
        // renodx::mods::swapchain::use_resize_buffer_on_demand = true;
        // renodx::mods::swapchain::use_resize_buffer_on_present = true;
        // renodx::mods::swapchain::target_color_space = reshade::api::color_space::srgb_nonlinear;
        // renodx::mods::swapchain::use_auto_upgrade = true;

        // renodx::mods::swapchain::force_borderless = true;
        // renodx::mods::swapchain::prevent_full_screen = false;

        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
#ifdef SWAPCHAIN_PROXY_DX12_ENABLED
            // {
            //     reshade::api::device_api::d3d12,
            //     {
            //         .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
            //         .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
            //     },
            // },
#endif
        };

        // SwapChainEncoding
        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 5.f,
              .can_reset = false,
              .label = "Encoding (Restart Required)",
              .section = "Display Output",
              .labels = {"None (Unknown)", "SRGB (Unsupported)", "2.2 (Unsupported)", "2.4 (Unsupported)", "HDR10 (Faster?)", "scRGB (Best)"},
              .tint = ALT_BUTTON_COLOR,
              // .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
              .on_change_value = [](float previous, float current) {
                bool is_hdr10 = current == 4;
                shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f);
                // return void
              },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool is_hdr10 = setting->GetValue() == 4;
          renodx::mods::swapchain::SetUseHDR10(is_hdr10);
          renodx::mods::swapchain::use_resize_buffer = setting->GetValue() < 4;
          shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
          settings.push_back(setting);
        }

        // Tex Upgrade
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
          .old_format = reshade::api::format::r8g8b8a8_typeless,
          .new_format = reshade::api::format::r16g16b16a16_typeless,
          .ignore_size = false,
          // .use_resource_view_cloning = true, //doesnt need to be true.
          // .use_resource_view_hot_swap = true,
          // .use_shared_handle = true,
          .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
          .usage_include = reshade::api::resource_usage::render_target,
        });

        // peak nits
        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
        
#ifdef RANDOM_ENABLED
        //random
        renodx::utils::random::binds.push_back(RANDOM_FLOAT);
#endif

        //done
        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_addon(h_module);
      break;
  }

#ifdef RANDOM_ENABLED
  renodx::utils::random::Use(fdw_reason);
#endif
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}