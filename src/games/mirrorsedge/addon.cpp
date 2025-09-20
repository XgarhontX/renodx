/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

// #d50000ff
#define COLOR_PRESETBUTTONS 0xd50000ff

namespace {

// Presets //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void ApplyPreset(const renodx::utils::settings::Settings& settings, const std::unordered_map<std::string, float>& preset) {
  for (auto* setting : settings) {
    if (setting->key.empty()) continue;
    if (!setting->can_reset) continue;

    if (preset.contains(setting->key)) {
      float value = preset.at(setting->key);
      if (value == FLT_MIN) value = setting->default_value;
      renodx::utils::settings::UpdateSetting(setting->key, value);
    }
  }
}

const std::unordered_map<std::string, float> PRESET_FAI = {
    {"custom_grade_luma", FLT_MIN},
    {"custom_grade_chroma", FLT_MIN},
    {"custom_whiteclip_lerp", FLT_MIN},
    {"custom_inv_exposure", FLT_MIN},
    {"custom_newexposure", FLT_MIN},
    // {"custom_inv_max", FLT_MIN},
    // {"custom_inv_curve", FLT_MIN},

    {"ColorGradeHighlights", FLT_MIN},
    {"ColorGradeShadows", FLT_MIN},
    {"ColorGradeContrast", FLT_MIN},
};
// const std::unordered_map<std::string, float> PRESET_INV = {
//     {"custom_grade_luma", FLT_MIN},
//     {"custom_grade_chroma", FLT_MIN},
//     {"custom_whiteclip_lerp", 1},
//     {"custom_inv_exposure", FLT_MIN},
//     {"custom_newexposure", FLT_MIN},
//     {"custom_inv_max", 5},
//     {"custom_inv_curve", FLT_MIN},

//     {"ColorGradeExposure", FLT_MIN},
//     {"ColorGradeHighlights", 50},
//     {"ColorGradeShadows", FLT_MIN},
//     {"ColorGradeContrast", 50},
//     {"ColorGradeSaturation", FLT_MIN},
// };
const std::unordered_map<std::string, float> PRESET_RAW = {
    {"custom_grade_luma", FLT_MIN},
    {"custom_grade_chroma", FLT_MIN},
    {"custom_whiteclip_lerp", FLT_MIN},
    {"custom_inv_exposure", FLT_MIN},
    {"custom_newexposure", FLT_MIN},
    // {"custom_inv_max", FLT_MIN},
    // {"custom_inv_curve", FLT_MIN},

    {"ColorGradeHighlights", 50},
    {"ColorGradeShadows", 50},
    {"ColorGradeContrast", 50},
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

float fps_limit_mov = 0;
float fps_limit = 0;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Easy", "Normal", "Hard"},
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
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Faithful",
        // .section = "Presets",
        .group = "button-line-1",
        .tooltip = "Mimic original with RenoDRT.",
        .tint = COLOR_PRESETBUTTONS,
        .on_change = []() { ApplyPreset(settings, PRESET_FAI); },
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Preset: Raw",
        // .section = "Presets",
        .group = "button-line-1",
        .tooltip = "Just the raw unclamped luma.",
        .tint = COLOR_PRESETBUTTONS,
        .on_change = []() { ApplyPreset(settings, PRESET_RAW); },
        // .is_visible = []() { return current_settings_mode >= 1; },
    },

    // ReadMe //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Requires AA to be on, else effects will become messed up.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "The game is bright (for RenoDRT expected values).\n"
                 "Use Game Brightness to turn it down.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "When FPS fluctuates or the in-game limit engages, UI will flicker.\n"
                 "Download \"Mirror's Edge Tweaks\" to disable the game's FPS limit and customize advanced settings.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Mirror's Edge Tweaks (ModDB)",
        .section = "Read Me",
        .group = "button-line-1",
        // .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://www.moddb.com/", "games/mirrors-edge/addons/persistent-fov");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = "",
        .section = "Read Me",
    },

    // FPSLimit //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &/* renodx::utils::swapchain::fps_limit */ fps_limit,
        .default_value = 60.f,
        .can_reset = false,
        .label = "FPS Limit",
        .section = "FPS Limit",
        .tooltip = "For the most accurate cap, use driver settings.\n"
                   "Expect FPS readout to be 2x the actual FPS.",
        .min = 0.f,
        .max = 240.f,
        .parse = [](float value) { return value * 2.f; },
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "FPSLimitMov",
        .binding = &fps_limit_mov,
        .default_value = 59.5f,
        .can_reset = true,
        .label = "Value Movies",
        .section = "FPS Limit",
        .tooltip = "Limit when fullscreen movies present.\n"
                   "Stops them from flickering, but too low can increase load times.\n",
        .min = 0.f,
        .max = 60.f,
        .format = "%.1f",
        .parse = [](float value) { return value * 2.f; },
        .is_global = true,
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
        .labels = {"Vanilla", "None", "ACES (Broken)", "RenoDRT"},
        // .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_mov",
        .binding = &shader_injection.custom_mov,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Upscale Movies",
        .section = "Tone Mapping",
        .tooltip = "Upscale fullscreen movies with BT2446a inverse.",
        // .labels = {"Vanilla", "None", "ACES (Broken)", "RenoDRT"},
        // .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
        .is_visible = []() { return current_settings_mode >= 0 && current_settings_mode < 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
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
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapScaling",
    //     .binding = &shader_injection.tone_map_per_channel,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Scaling",
    //     .section = "Tone Mapping",
    //     .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
    //     .labels = {"Luminance", "Per Channel"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapWorkingColorSpace",
    //     .binding = &shader_injection.tone_map_working_color_space,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Working Color Space",
    //     .section = "Tone Mapping",
    //     .labels = {"BT709", "BT2020", "AP1"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueProcessor",
    //     .binding = &shader_injection.tone_map_hue_processor,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 1.f,
    //     .label = "Hue Processor",
    //     .section = "Tone Mapping",
    //     .tooltip = "Selects hue processor.",
    //     .labels = {"OKLab", "ICtCp", "darkTable UCS"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueCorrection",
    //     .binding = &shader_injection.tone_map_hue_correction,
    //     .default_value = 0.f,
    //     .label = "Hue Correction",
    //     .section = "Tone Mapping",
    //     .tooltip = "Hue retention strength.",
    //     .min = 0.f,
    //     .max = 100.f,
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapHueShift",
    //     .binding = &shader_injection.tone_map_hue_shift,
    //     .default_value = 50.f,
    //     .label = "Hue Shift",
    //     .section = "Tone Mapping",
    //     .tooltip = "Hue-shift emulation strength.",
    //     .min = 0.f,
    //     .max = 100.f,
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapClampColorSpace",
    //     .binding = &shader_injection.tone_map_clamp_color_space,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Clamp Color Space",
    //     .section = "Tone Mapping",
    //     .tooltip = "Hue-shift emulation strength.",
    //     .labels = {"None", "BT709", "BT2020", "AP1"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .parse = [](float value) { return value - 1.f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "ToneMapClampPeak",
    //     .binding = &shader_injection.tone_map_clamp_peak,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Clamp Peak",
    //     .section = "Tone Mapping",
    //     .tooltip = "Hue-shift emulation strength.",
    //     .labels = {"None", "BT709", "BT2020", "AP1"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .parse = [](float value) { return value - 1.f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },

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
        .default_value = 60.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 60.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        // .is_visible = []() { return current_settings_mode >= 2; },
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
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorWhiteClip",
    //     .binding = &shader_injection.tonemap_white_clip,
    //     .default_value = 100.f,
    //     .label = "White Clip",
    //     .section = "Color Grade",
    //     .tooltip = "White clip. Boosts extreme highs to clip",
    //     .min = 0.f,
    //     .max = 100.f,
    //     .is_enabled = []() { return shader_injection.tone_map_type == 3; },
    //     // .format = "%.1f",
    // },
    new renodx::utils::settings::Setting{
        .key = "custom_grade_luma",
        .binding = &shader_injection.custom_grade_luma,
        .default_value = 0.0f,
        .label = "Luma Grade",
        .section = "Color Grading",
        .tooltip = "Use the untonemapped (0) vs tonemapped (1) for luma.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return /* current_settings_mode >= 1 && */ shader_injection.tone_map_type > 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_grade_chroma",
        .binding = &shader_injection.custom_grade_chroma,
        .default_value = 1.f,
        .label = "Chroma Grade",
        .section = "Color Grading",
        .tooltip = "Use the untonemapped (0) vs tonemapped (1) for chroma.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return /* current_settings_mode >= 1 && */ shader_injection.tone_map_type > 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_whiteclip_lerp",
        .binding = &shader_injection.custom_whiteclip_lerp,
        .default_value = 0.9f,
        .label = "Saturate Blowout",
        .section = "Color Grading",
        .tooltip = "How much influence does saturate(tonemapped) have an affect on unclamped tonemapped's chroma?",
        .min = 0.f,
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tone_map_type > 0; },
    },
    // new renodx::utils::settings::Setting{
    //     .key = "ColorGradeScene",
    //     .binding = &shader_injection.color_grade_strength,
    //     .default_value = 100.f,
    //     .label = "Scene Grading",
    //     .section = "Color Grading",
    //     .tooltip = "Scene grading as applied by the game",
    //     .max = 100.f,
    //     .is_enabled = []() { return shader_injection.tone_map_type > 0; },
    //     .parse = [](float value) { return value * 0.01f; },
    //     .is_visible = []() { return settings[0]->GetValue() >= 2; },
    // },

    // Extra //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "custom_bloom",
        .binding = &shader_injection.custom_bloom,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Bloom & DoF",
        .section = "Extra",
        .tooltip = "The game combines both, so no multiplier.",
        // .min = 0.f,
        // .max = 3.f,
        // .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "custom_speedlines",
        .binding = &shader_injection.custom_speedlines,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 0.5f,
        .label = "Speed Lines",
        .section = "Extra",
        .tooltip = "Screen edge speed lines strength.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.2f",
    },

    // Sun //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "custom_sunglare",
        .binding = &shader_injection.custom_sunglare,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 2.f,
        .label = "Glare",
        .section = "Sun",
        .tooltip = "Brightness of sun glare.",
        .min = 0.f,
        .max = 4.f,
        .format = "%.1f",
    },
    new renodx::utils::settings::Setting{
        .key = "custom_sunsize",
        .binding = &shader_injection.custom_sunsize,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 0.007f,
        .label = "Size",
        .section = "Sun",
        .tooltip = "Size of sun.",
        .min = 0.f,
        .max = 0.02f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "custom_sunlens",
        .binding = &shader_injection.custom_sunlens,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.f,
        .label = "Lens Flare",
        .section = "Sun",
        .tooltip = "Sun lens flare strength.",
        .min = 0.f,
        .max = 3.f,
        .format = "%.3f",
    },

    // PreExposure //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "custom_inv_exposure",
        .binding = &shader_injection.custom_inv_exposure,
        .default_value = 1.f,
        .label = "PreExposure",
        .section = "PreExposure",
        .tooltip = "Multiplier of color before ToneMapPass().",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "custom_newexposure",
        .binding = &shader_injection.custom_newexposure,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .can_reset = true,
        .label = "New Exposure",
        .section = "PreExposure",
        .tooltip = "New exposure function boosting outside exposure to match inside.",
        // .is_enabled = []() { return shader_injection.custom_inv_is >= 1; },
        .is_visible = []() { return current_settings_mode >= 2 && shader_injection.tone_map_type > 0; },
    },

    // // Inverse //////////////////////////////////////////////////////////////////////////////////////
    // new renodx::utils::settings::Setting{
    //     .key = "custom_inv_max",
    //     .binding = &shader_injection.custom_inv_max,
    //     .default_value = 0.0f,
    //     .label = "Max",
    //     .section = "Inverse",
    //     .tooltip = "Max value expected, white clips.\n"
    //                "0 to disable inverse tonemap.",
    //     .min = 0.f,
    //     .max = 10.f,
    //     .format = "%.3f",
    //     .is_visible = []() { return current_settings_mode >= 1 && shader_injection.tone_map_type > 0; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "custom_inv_curve",
    //     .binding = &shader_injection.custom_inv_curve,
    //     .default_value = 1.f,
    //     .label = "Curve",
    //     .section = "Inverse",
    //     .tooltip = "Higher is more linear, lower is more contrasted.",
    //     .min = 0.f,
    //     .max = 10.f,
    //     .format = "%.2f",
    //     .is_enabled = []() { return shader_injection.custom_inv_max > 0; },
    //     .is_visible = []() { return /* current_settings_mode >= 1 &&*/ shader_injection.tone_map_type > 0; },
    // },

    // Credits & Buttons //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "Game Mod: XgarhontX",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "RenoDX: clshortfuse",
        .section = "Credits",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "shared.h Reference: Steve161803",
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

    // Advanced //////////////////////////////////////////////////////////////////////////////////////

    // new renodx::utils::settings::Setting{
    //     .key = "SwapChainCustomColorSpace",
    //     .binding = &shader_injection.swap_chain_custom_color_space,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Custom Color Space",
    //     .section = "Display Output",
    //     .tooltip = "Selects output color space"
    //                "\nUS Modern for BT.709 D65."
    //                "\nJPN Modern for BT.709 D93."
    //                "\nUS CRT for BT.601 (NTSC-U)."
    //                "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
    //                "\nDefault: US CRT",
    //     .labels = {
    //         "US Modern",
    //         "JPN Modern",
    //         "US CRT",
    //         "JPN CRT",
    //     },
    //     .is_visible = []() { return settings[0]->GetValue() >= 1; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "IntermediateDecoding",
    //     .binding = &shader_injection.intermediate_encoding,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Intermediate Encoding",
    //     .section = "Display Output",
    //     .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .parse = [](float value) {
    //         if (value == 0) return shader_injection.gamma_correction + 1.f;
    //         return value - 1.f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "SwapChainDecoding",
    //     .binding = &shader_injection.swap_chain_decoding,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Swapchain Decoding",
    //     .section = "Display Output",
    //     .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .parse = [](float value) {
    //         if (value == 0) return shader_injection.intermediate_encoding;
    //         return value - 1.f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "SwapChainGammaCorrection",
    //     .binding = &shader_injection.swap_chain_gamma_correction,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Gamma Correction",
    //     .section = "Display Output",
    //     .labels = {"None", "2.2", "2.4"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
    // new renodx::utils::settings::Setting{
    //     .key = "SwapChainClampColorSpace",
    //     .binding = &shader_injection.swap_chain_clamp_color_space,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 2.f,
    //     .label = "Clamp Color Space",
    //     .section = "Display Output",
    //     .labels = {"None", "BT709", "BT2020", "AP1"},
    //     .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
    //     .parse = [](float value) { return value - 1.f; },
    //     .is_visible = []() { return current_settings_mode >= 2; },
    // },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
  renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
  renodx::utils::settings::UpdateSetting("TtoneMapGameNits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
  renodx::utils::settings::UpdateSetting("ToneMapGammaCorrection", 1);
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

#define MOV_THRES 60
byte mov_drawn_count = 0;
const renodx::utils::settings::Setting* fps_limit_setting = settings[1];
bool OnDrawMov(reshade::api::command_list* cmd_list) {
  mov_drawn_count = min(mov_drawn_count + 1, MOV_THRES);
  if (mov_drawn_count >= MOV_THRES) {
    renodx::utils::swapchain::fps_limit = fps_limit_mov;
  }
  return true;
}

byte token = 0;
bool OnDrawTonemap(reshade::api::command_list* cmd_list) {
  token++;
  if (token >= 16) {
    renodx::utils::swapchain::fps_limit = fps_limit;
    token = 0;
  }
  mov_drawn_count = 0;
  return true;
}

renodx::mods::shader::CustomShaders custom_shaders = {
    // __ALL_CUSTOM_SHADERS,

    CustomShaderEntryCallback(0x2DDEEDDF, OnDrawMov),
    CustomShaderEntryCallback(0x999CAA6B, OnDrawTonemap),

    CustomShaderEntry(0x6763302A),
    CustomShaderEntry(0x738E70E8),
    CustomShaderEntry(0xDC9E3856),
    CustomShaderEntry(0x9555725F),

    // sun
    CustomShaderEntry(0x3BEA84B5),
    CustomShaderEntry(0x4EE66DC8),
    CustomShaderEntry(0xE9F15880),
    CustomShaderEntry(0x2BA712BD),

    // CustomShaderEntry(0x00000000),
    // CustomSwapchainShader(0x00000000),
    // BypassShaderEntry(0x00000000)
};

bool initialized = false;

}  // namespace

// from tombraider2013 de
void OnInitSwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto peak = renodx::utils::swapchain::GetPeakNits(swapchain);
  if (!peak.has_value()) peak = 1000.f;
  auto paper = renodx::utils::swapchain::ComputeReferenceWhite(peak.value());

  // find and set
  bool isPeak = false;
  bool isPaper = false;
  bool isUi = false;
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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Mirror's Edge)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = false;
        renodx::mods::shader::expected_constant_buffer_space = 50;  // From spec ops the line
        renodx::mods::shader::expected_constant_buffer_index = CBUFFER;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::constant_buffer_offset = 50 * 4;  // From spec ops the line

        renodx::mods::swapchain::expected_constant_buffer_index = CBUFFER;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;  // From spec ops the line
        renodx::mods::swapchain::use_resource_cloning = true;

        // renodx::mods::swapchain::force_borderless = false;
        // renodx::mods::swapchain::prevent_full_screen = true;
        renodx::mods::swapchain::force_screen_tearing = true;  // else ui flickers with MT artifacts
        renodx::mods::swapchain::set_color_space = true;

        renodx::mods::swapchain::use_device_proxy = true;  // required
        renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;

        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            {
                reshade::api::device_api::d3d12,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
                },
            },
        };

        // {
        //   auto* setting = new renodx::utils::settings::Setting{
        //       .key = "SwapChainEncoding",
        //       .binding = &shader_injection.swap_chain_encoding,
        //       .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        //       .default_value = 5.f,
        //       .label = "Encoding",
        //       .section = "Display Output",
        //       .labels = {"None", "SRGB", "2.2", "2.4", "HDR10", "scRGB"},
        //       .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        //       .on_change_value = [](float previous, float current) {
        //         bool is_hdr10 = current == 4;
        //         shader_injection.swap_chain_encoding_color_space = (is_hdr10 ? 1.f : 0.f);
        //         // return void
        //       },
        //       .is_global = true,
        //       .is_visible = []() { return current_settings_mode >= 2; },
        //   };
        //   renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
        //   bool is_hdr10 = setting->GetValue() == 4;
        //   renodx::mods::swapchain::SetUseHDR10(is_hdr10);
        //   renodx::mods::swapchain::use_resize_buffer = setting->GetValue() < 4;
        //   shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
        //   settings.push_back(setting);
        // }

        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::b8g8r8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = true,
            .use_resource_view_cloning = false,
            // .use_resource_view_hot_swap = true,
            // .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r8g8b8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = true,
            .use_resource_view_cloning = false,
            // .use_resource_view_hot_swap = true,
            // .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
            .old_format = reshade::api::format::r16g16b16a16_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = true,
            .use_resource_view_cloning = false,
            // .use_resource_view_hot_swap = true,
            // .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,
        });

        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
