/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <cfloat>
#define ImTextureID ImU64

#define RENODX_MODS_SWAPCHAIN_VERSION 2

// #define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

// #d50000
#define COLOR_PRESETBUTTONS 0xd50000

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
};

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

const std::unordered_map<std::string, float> P_BLOWOUT_HC_VANILLA = {
    {"pblow_chue", FLT_MIN},
    {"pblow_csat", FLT_MIN},
};
const std::unordered_map<std::string, float> P_BLOWOUT_HC_NOHUE = {
    {"pblow_chue", 0.f},
    {"pblow_csat", FLT_MIN},
};

const std::unordered_map<std::string, float> P_BLOWOUT_T_GRADUAL = {
    {"pblow_start", FLT_MIN},
    {"pblow_max", FLT_MIN},
};

const std::unordered_map<std::string, float> P_BLOWOUT_T_BRICKWALL = {
    {"pblow_start", 1.f},
    {"pblow_max", 0.f},
};

ShaderInjectData shader_injection;

renodx::utils::settings::Settings settings = {
    // new renodx::utils::settings::Setting{
    //     .key = "SettingsMode",
    //     .binding = &current_settings_mode,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .can_reset = false,
    //     .label = "Settings Mode",
    //     .labels = {"Easy", "Normal", "Hard"},
    //     .is_global = true,
    // },
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
        .label = "This UI is buggy. You might drag multiple sliders at a time.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "In-game slider Brightness controls gamma.\nIn-game slider Contrast controls LUT contrast.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Mirror's Edge Tweaks (ModDB)\nAdjusting advanced settings and remove FPS cap.",
        .section = "Read Me",
        .group = "button-line-1",
        // .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://www.moddb.com/", "games/mirrors-edge/addons/persistent-fov");
        },
    },

    // FPSLimit //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "External readout may be 2x the actual FPS.",
        .section = "FPS Limit",
    },
    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 0.f,
        .can_reset = false,
        .label = "FPS Limit",
        .section = "FPS Limit",
        .tooltip = "Expect FPS readout to be 2x the actual FPS.",
        .min = 0.f,
        .max = 240.f,
        .parse = [](float value) { return value * 2.f; },
        .is_global = true,
    },

    // Brightness //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "diffuse_white_nits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game",
        .section = "Brightness",
        .tooltip = "Sets the value of 100% white in nits.",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "graphics_white_nits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI",
        .section = "Brightness",
        .tooltip = "Sets the brightness of UI and HUD elements in nits.",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "c_mov",
        .binding = &shader_injection.c_mov,
        .default_value = 203.f,
        .label = "Movie Brightness",
        .section = "Brightness",
        .tooltip = "Loading movies and whatnot.",
        .min = 0.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "gamma_correction",
        .binding = &shader_injection.gamma_correction,
        .default_value = 203.f,
        .label = "Gamma Correction",
        .section = "Brightness",
        .tooltip = "The paper white / cutoff to emulate a display EOTF (2.2).",
        .min = 0.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ui",
        .binding = &shader_injection.ui,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "UI*",
        .section = "Brightness",
        .tooltip = "*Only enough to take pics on pause screen.",
        .labels = {"Off", "On"},
    },

    // Tone Mapper //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "tone_map_type",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Type",
        .section = "Tone Map",
        .tooltip = "SDR*: Tonemap is clamped just like SDR, *but some other shaders for scene rendering may still take effect.\n\nOff (Debug): No tonemapping, with maximum chrominance.\n\nHDR Luminance w/ SDR Per-Channel Blowout: Superimpose a low peak tonemap for hue shifted blowouts, then do luminance scaled HDR tonemap (Hermite Spline).",
        .labels = {"SDR*", "Off", "HDR Luminance w/ SDR Per-Channel Blowout"},
    },
    new renodx::utils::settings::Setting{
        .key = "peak_white_nits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak",
        .section = "Tone Map",
        .tooltip = "Maximum luminance output to display.",
        .min = 203.f,
        .max = 4000.f,
        .is_visible = []() { return shader_injection.tone_map_type >= 2.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "expected_peak_white_nits",
        .binding = &shader_injection.expected_white_nits,
        .default_value = 4000.f,
        .label = "Expected Peak",
        .section = "Tone Map",
        .tooltip = "Expected max of HDR luminance.\nLower to white clip.",
        .min = 1000.f,
        .max = 10000.f,
        .is_visible = []() { return shader_injection.tone_map_type >= 2.f; },
    },

    ////////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Vanilla+",
        .section = "Blowout",
        .group = "button-line-1",
        .on_change = []() {
            ApplyPreset(settings, P_BLOWOUT_HC_VANILLA);
        },
        .is_visible = []() { return shader_injection.tone_map_type == 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "No Hue Shift",
        .section = "Blowout",
        .group = "button-line-1",
        .on_change = []() {
            ApplyPreset(settings, P_BLOWOUT_HC_NOHUE);
        },
        .is_visible = []() { return shader_injection.tone_map_type == 2; },
    },

    new renodx::utils::settings::Setting{
        .key = "pblow_chue",
        .binding = &shader_injection.pblow_chue,
        .default_value = 0.76f,
        .label = "Hue Influence",
        .section = "Blowout",
        .tooltip = "Hue shift of blownout color's influence on HDR color.",
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.tone_map_type == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_csat",
        .binding = &shader_injection.pblow_csat,
        .default_value = 0.72f,
        .label = "Chrominance Influence",
        .section = "Blowout",
        .tooltip = "Chrominance/Saturation of blownout color's influence on HDR color.",
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.tone_map_type >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_satboost",
        .binding = &shader_injection.pblow_satboost,
        .default_value = 1.00f,
        .label = "Chrominance Boost",
        .section = "Blowout",
        .tooltip = "Boost to counteract lost.",
        .min = 1.f,
        .max = 1.1f,
        .format = "%.3f",
        .is_visible = []() { return shader_injection.tone_map_type >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_guaranteed",
        .binding = &shader_injection.pblow_guaranteed,
        .default_value = 0.5f,
        .label = "Guaranteed",
        .section = "Blowout",
        .tooltip = "Blowout the most extreme of highlights.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
        .is_visible = []() { return shader_injection.tone_map_type >= 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Gradual",
        .section = "Blowout",
        .group = "button-line-1",
        .on_change = []() {
            ApplyPreset(settings, P_BLOWOUT_T_GRADUAL);
        },
        .is_visible = []() { return shader_injection.tone_map_type == 2; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Brickwall",
        .section = "Blowout",
        .group = "button-line-1",
        .on_change = []() {
            ApplyPreset(settings, P_BLOWOUT_T_BRICKWALL);
        },
        .is_visible = []() { return shader_injection.tone_map_type == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_start",
        .binding = &shader_injection.pblow_start,
        .default_value = 0.8f,
        .label = "Shoulder Start",
        .section = "Blowout",
        .tooltip = "The threshold before the low peak tonemapper engages.",
        .max = 1.5f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.tone_map_type == 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_max",
        .binding = &shader_injection.pblow_max,
        .default_value = 1.25f,
        .label = "Peak",
        .section = "Blowout",
        .tooltip = "The peak of the low peak tonemapper.",
        .max = 3.0f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.tone_map_type == 2; },
    },

    ////////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "vcg_exposure",
        .binding = &shader_injection.vcg_exposure,
        .default_value = 1.0f,
        .label = "Exposure",
        .section = "Vanilla Color Grade",
        .tooltip = "Exposure for raw HDR input color.",
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "lut_colornwc",
        .binding = &shader_injection.vcg_colornwc,
        .default_value = 1.5f,
        .label = "Highlights Saturation Restore",
        .section = "Vanilla Color Grade",
        .tooltip = "Roll off the color passed to color grading and LUT, restoring highlights saturation.\nSet 0 for Brickwall like Vanilla.",
        .max = 2.f,
        // .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .format = "%.3f",
        .parse = [](float value) { return value + 1.0f; },
    },
    new renodx::utils::settings::Setting{
        .key = "vcg_other",
        .binding = &shader_injection.vcg_other,
        .default_value = 1.f,
        .label = "Other",
        .section = "Vanilla Color Grade",
        .tooltip = "All the stuff before LUT, which seems to be seldomly used...",
        .max = 1.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "lut",
        .binding = &shader_injection.vcg_lut,
        .default_value = 1.f,
        .label = "LUT",
        .section = "Vanilla Color Grade",
        .tooltip = "Color grade from LUT curves.",
        .max = 1.f,
        .format = "%.3f",
    },
    // new renodx::utils::settings::Setting{
    //     .key = "c_gammamode",
    //     .binding = &shader_injection.c_gammamode,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .label = "Gamma Mode",
    //     .section = "Vanilla Color Grade",
    //     .tooltip = "Idk how to explain. It's the decode from gamma back to linear, each gives different results.",
    //     .labels = {"A", "B"},
    // },

    ////////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "cg_middle",
        .binding = &shader_injection.cg_middle,
        .default_value = 1.0f,
        .label = "Middle Gray",
        .section = "RenoDX Luminace Color Grade",
        .tooltip = "The middle point for RenoDX's luma based color grade.",
        .max = 4.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "cg_contrast",
        .binding = &shader_injection.cg_contrast,
        .default_value = 1.0f,
        .label = "Contrast",
        .section = "RenoDX Luminace Color Grade",
        .tooltip = "Both shadows and highlights stretching by luminance.",
        .max = 2.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "cg_shadows",
        .binding = &shader_injection.cg_shadows,
        .default_value = 1.0f,
        .label = "Shadows",
        .section = "RenoDX Luminace Color Grade",
        .tooltip = "Shadow stretching by luminance.",
        .max = 2.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "cg_highlights",
        .binding = &shader_injection.cg_highlights,
        .default_value = 1.0f,
        .label = "Highlights",
        .section = "RenoDX Luminace Color Grade",
        .tooltip = "Highlight stretching by luminance.",
        .max = 2.0f,
        .format = "%.3f",
    },

    ////////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_gamma",
        .binding = &shader_injection.fakewcgcorrect_gamma,
        .default_value = 0.5f,
        .label = "Strength",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Strength of gamma gamut expansion.",
        .min = 0.f,
        .max = 2.0f,
        .format = "%.3f",
        .parse = [](float value) { return value == 1.f ? 0 : value + 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_chroma",
        .binding = &shader_injection.fakewcgcorrect_chroma,
        .default_value = 0.0f,
        .label = "Correct Chroma",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Correct saturation boost's chroma to original.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
        .is_enabled = []() { return shader_injection.fakewcgcorrect_gamma > 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_luma",
        .binding = &shader_injection.fakewcgcorrect_luma,
        .default_value = 0.8f,
        .label = "Correct Luma",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Correct saturation boost's luma to original.",
        .min = 0.f,
        .max = 0.9f,
        .format = "%.3f",
        .is_enabled = []() { return shader_injection.fakewcgcorrect_gamma > 0.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_sat",
        .binding = &shader_injection.fakewcgcorrect_sat,
        .default_value = 1.005f,
        .label = "Saturation",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Simple saturation multiplier.",
        .min = 0.5f,
        .max = 1.5f,
        .format = "%.3f",
        .is_enabled = []() { return shader_injection.fakewcgcorrect_gamma > 0.f; },
    },

    ////////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "c_bloom",
        .binding = &shader_injection.c_bloom,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.0f,
        .label = "Bloom",
        .section = "Extra",
        // .tooltip = "",
        .min = 0.0f,
        .max = 2.0f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_bloom_contrast",
        .binding = &shader_injection.c_bloom_contrast,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.f,
        .label = "Bloom Contrast",
        .section = "Extra",
        // .tooltip = "",
        .min = 0.8f,
        .max = 1.2f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_dof",
        .binding = &shader_injection.c_dof,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.f,
        .label = "DoF + Bloom",
        .section = "Extra",
        .tooltip = "DoF reuses Bloom as blur, so it's not possible to seperate.",
        .min = 0.0f,
        .max = 1.0f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_speedlines",
        .binding = &shader_injection.c_speedlines,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 0.4f,
        .label = "Speed Lines",
        .section = "Extra",
        .tooltip = "Screen edge speed lines strength.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.2f",
    },

    //  //////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .key = "c_worldflare",
        .binding = &shader_injection.c_worldflare,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.f,
        .label = "Strength",
        .section = "World Flares",
        .tooltip = "Billboard flares to simulate sun reflection on glass.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_worldflare_addblur",
        .binding = &shader_injection.c_worldflare_addblur,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.f,
        .label = "Additional Blur",
        .section = "World Flares",
        .tooltip = "Add a bloom looking blur on top.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
    },

    // Sun //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "c_sunglare",
        .binding = &shader_injection.c_sunglare,
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
        .key = "c_sunsize",
        .binding = &shader_injection.c_sunsize,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.f,
        .label = "Size",
        .section = "Sun",
        .tooltip = "Size of sun.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.2f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_sunlens",
        .binding = &shader_injection.c_sunlens,
        .value_type = renodx::utils::settings::SettingValueType::FLOAT,
        .default_value = 1.f,
        .label = "Lens Flare",
        .section = "Sun",
        .tooltip = "Sun lens flare strength.",
        .min = 0.f,
        .max = 3.f,
        .format = "%.3f",
    },

};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("tone_map_type", 0.f);
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

bool initialized = false;

}  // namespace

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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Mirror's Edge)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        //shader
        renodx::mods::shader::expected_constant_buffer_space = 50;  // From spec ops the line //TODO: needed?
        renodx::mods::shader::expected_constant_buffer_index = CBUFFER;
        renodx::mods::shader::constant_buffer_offset = 50 * 4;  // From spec ops the line //TODO: needed?

        //swapchain
        renodx::mods::swapchain::expected_constant_buffer_index = CBUFFER;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;  // From spec ops the line //TODO: needed?
        renodx::mods::swapchain::use_resource_cloning = true;

        renodx::mods::swapchain::use_device_proxy = true; //req
        renodx::mods::swapchain::set_color_space = false; //req

        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
        };

        //tex upgrades
        renodx::mods::swapchain::resource_upgrade_infos.push_back({ //color
            .old_format = reshade::api::format::b8g8r8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = true,
            .use_resource_view_cloning = false, //req false
            // .use_resource_view_hot_swap = true,
            // .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        renodx::mods::swapchain::resource_upgrade_infos.push_back({ //specular gbuffer, will be pixelated otherwise
            .old_format = reshade::api::format::r8g8b8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_unorm,
            .ignore_size = true,
            .use_resource_view_cloning = false, //req false
            // .use_resource_view_hot_swap = true,
            // .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,
        });
        renodx::mods::swapchain::resource_upgrade_infos.push_back({ //req for HDR bloom, and exposure is fixed.
            .old_format = reshade::api::format::r16g16b16a16_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = true,
            .use_resource_view_cloning = false, //req false
            // .use_resource_view_hot_swap = true,
            // .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            .usage_include = reshade::api::resource_usage::render_target,
        });

        //swapchain settings
        {
            auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
            //   .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Output",
              .section = "Display Output (Restart Req.)",
              .tooltip = "HDR10: 10bit, worse quality (banding?), but more performant and better compatibility.\nscRGB: Default 16bit max quality.",
              .labels = {"HDR10", "scRGB"},
              .is_global = true,
            };
            renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
            auto v = setting->GetValue();
            shader_injection.swap_chain_encoding = v;
            renodx::mods::swapchain::SetUseHDR10(v == 0);
            settings.push_back(setting);
        }

        {
            auto* setting = new renodx::utils::settings::Setting{
            .key = "SwapChainForceBorderless",
            .value_type = renodx::utils::settings::SettingValueType::INTEGER,
            .default_value = 0.f,
            .label = "Force Borderless",
            .section = "Display Output (Restart Req.)",
            .tooltip = "Forces fullscreen to be borderless for proper HDR",
            .labels = {
                "Disabled",
                "Enabled",
            },
            .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },
            .is_global = true,
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::force_borderless = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainPreventFullscreen",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Prevent Fullscreen",
              .section = "Display Output (Restart Req.)",
              .tooltip = "Prevent exclusive fullscreen for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
              .is_global = true,
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }
        
        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyBaseWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Base Wait Idle",
              .section = "Display Proxy (Restart Req.)",
              .tooltip = "Should underlying swapchain respect idle before presenting?\nMay help against multithreading artifacts.",
              .labels = {"Off", "On"},
              .is_global = true,
            //   .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::device_proxy_wait_idle_source = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }
        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyProxyWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Proxy Wait Idle",
              .section = "Display Proxy (Restart Req.)",
              .tooltip = "Should proxy swapchain respect idle before presenting?\nMay help against multithreading artifacts.",
              .labels = {"Off", "On"},
              .is_global = true,
            //   .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::device_proxy_wait_idle_destination = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        //credits
        {
            auto* s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BULLET,
                .label = "Game Mod: XgarhontX",
                .section = "Credits",
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BULLET,
                .label = "RenoDX: clshortfuse",
                .section = "Credits",
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BULLET,
                .label = "shared.h Reference: Steve161803",
                .section = "Credits",
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BULLET,
                .label = "Coding Help: Pumbo",
                .section = "Credits",
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BULLET,
                .label = "Coding Help: Musa",
                .section = "Credits",
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BULLET,
                .label = "Bug Hunter: Strale",
                .section = "Credits",
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BUTTON,
                .label = "RenoDX Discord",
                .section = "Credits",
                .group = "button-line-1",
                .tint = 0x5865F2,
                .on_change = []() {
                  renodx::utils::platform::LaunchURL("https://discord.gg/", "F6AUTeWJHM");
                },
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BUTTON,
                .label = "HDRDen Discord",
                .section = "Credits",
                .group = "button-line-1",
                .tint = 0x5865F2,
                .on_change = []() {
                  renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
                },
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::BUTTON,
                .label = "More Mods",
                .section = "Credits",
                .group = "button-line-1",
                .tint = 0x2B3137,
                .on_change = []() {
                  renodx::utils::platform::LaunchURL("https://github.com/clshortfuse/renodx/wiki/Mods");
                },
            }; settings.push_back(s);
            s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Build Date: " + build_date + " - " + build_time,
                .section = "Credits",
            }; settings.push_back(s);
        }

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
