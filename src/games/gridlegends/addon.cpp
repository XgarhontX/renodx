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

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
};

ShaderInjectData shader_injection;

void ApplyVanilla(renodx::utils::settings::Settings &settings, bool is_off) {
    for (auto* setting : settings) {
        if (setting->key.empty() || !setting->can_reset) continue;

        float value = setting->default_value;
        if (setting->binding == &shader_injection.lut_expandgamut) value = 1.f;
        else if (setting->binding == &shader_injection.lut_desaturation) value = 1.f;
        else if (setting->binding == &shader_injection.lutpcb_hue) value = 1.f;
        else if (setting->binding == &shader_injection.lutpcb_chroma) value = 1.f;
        else if (setting->binding == &shader_injection.tone_map_type) value = 0.f;
        else if (is_off && setting->binding == &shader_injection.peak_white_nits) value = -1.f;
        else if (is_off && setting->binding == &shader_injection.tone_map_type) value = 0.f;

        renodx::utils::settings::UpdateSetting(setting->key, value);
    }
    if (!is_off) renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
}

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

    // ReadMe //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT_NOWRAP,
        .label = "  - Settings are ordered by draw order.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT_NOWRAP,
        .label = "  - Movies are clamped 8bit, can't auto HDR.",
        .section = "Read Me",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT_NOWRAP,
        .label = "  - All settings have tooltips!",
        .section = "Read Me",
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT_NOWRAP,
        .label = "  - Please enable in-game HDR10!",
        .section = "Prerequisites",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT_NOWRAP,
        .label = "  - Please manually sync with in-Game Brightness setting! I can't detect.",
        .section = "Prerequisites",
    },
    new renodx::utils::settings::Setting{
        .key = "graphics_white_nits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 50.f,
        .can_reset = false,
        .label = "HDR Brightness (UI Brightness)",
        .section = "Prerequisites",
        .tooltip = "Effectively UI Brightness."
                   "\ne.g. 20 = 200 nits, and so forth."
                   "\n\nIn the background, this will inverse the LUT builder brightness scaling,\nallowing only UI to scale and lets LUT sampling stay consistent.",
        .min = 1.f,
        .max = 100.f,
        .format = "%.0f",
        .is_global = true,
    },

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Fixed Vanilla",
        .section = "Presets",
        .group = "button-line-1",
        .tooltip = "This would be if the game got a patch to fix HDR10.",
        .on_change = []() {
            ApplyVanilla(settings, false);
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Modded Vanilla",
        .section = "Presets",
        .group = "button-line-1",
        .tooltip = "Similar to vanilla, but removed gamut expanding then desaturation tomfoolery, and added slight contrast.",
        .on_change = []() {
            for (auto* setting : settings) {
                if (setting->key.empty() || !setting->can_reset) continue;
                float value = setting->default_value;
                if (setting->binding == &shader_injection.tone_map_type) value = 1.f;
                else if (setting->binding == &shader_injection.tone_map_type_hdr) value = 1.f;
                renodx::utils::settings::UpdateSetting(setting->key, value);
            }
            renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Modded New (Recommended)",
        .section = "Presets",
        .group = "button-line-2",
        .tooltip = "Similar to Modded A, but removed the original low contrast tonemap spline, giving more contrast better info from LUT.",
        .on_change = []() {
            for (auto* setting : settings) {
                if (setting->key.empty() || !setting->can_reset) continue;
                float value = setting->default_value;
                if (setting->binding == &shader_injection.tone_map_type_hdr) value = 0.f;
                renodx::utils::settings::UpdateSetting(setting->key, value);
            }
            renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Modded New Aggressive (Recommended)",
        .section = "Presets",
        .group = "button-line-2",
        .tooltip = "Similar to Modded B, but with an aggressive HDR tonemapper.",
        .on_change = []() {
            for (auto* setting : settings) {
                if (setting->key.empty() || !setting->can_reset) continue;
                float value = setting->default_value;
                if (setting->binding == &shader_injection.tone_map_type_hdr) value = 2.f;
                renodx::utils::settings::UpdateSetting(setting->key, value);
            }
            renodx::utils::settings::SaveSettings(renodx::utils::settings::global_name + "-preset" + std::to_string(renodx::utils::settings::preset_index));
        },
    },
    // LUT Builder ///////////////////////////////////////////////////////////////////////////////////////////
    //lut_whitebalance
    new renodx::utils::settings::Setting{
        .key = "lut_whitebalance",
        .binding = &shader_injection.lut_whitebalance,
        .default_value = 1.f,
        .label = "White Balance",
        .section = "LUT Builder: Color Grading",
        .tooltip = "White balance/point change amount.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    //lut_expandgamut
    new renodx::utils::settings::Setting{
        .key = "lut_expandgamut",
        .binding = &shader_injection.lut_expandgamut,
        .default_value = 0.001f,
        .label = "Highlights Saturation Boost",
        .section = "LUT Builder: Color Grading",
        .tooltip = "Expands color based on luminance.\nVanilla is 1, but this may be unnatural anti-blowout, as orange become red.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    //lut_colorgrade
    new renodx::utils::settings::Setting{
        .key = "lut_colorgrade",
        .binding = &shader_injection.lut_colorgrade,
        .default_value = 1.f,
        .label = "Color Grade",
        .section = "LUT Builder: Color Grading",
        .tooltip = "Various (e.g. Shadows Midtones Hightlights, Tint, etc.) color grading strength.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    //lut_hueshiftblowout
    new renodx::utils::settings::Setting{
        .key = "lut_hueshiftblowout",
        .binding = &shader_injection.lut_hueshiftblowout,
        .default_value = 1.f,
        .label = "Hue Correction",
        .section = "LUT Builder: Color Grading",
        .tooltip = "Mainly correct red from being overly red/pink.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    //lut_desaturation
    new renodx::utils::settings::Setting{
        .key = "lut_desaturation",
        .binding = &shader_injection.lut_desaturation,
        .default_value = 0.f,
        .label = "Highlights Desaturation",
        .section = "LUT Builder: Color Grading",
        .tooltip = "Slight final desaturation of highlights.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },

    //lutpcb_hue
    new renodx::utils::settings::Setting{
        .key = "lutpcb_hue",
        .binding = &shader_injection.lutpcb_hue,
        .default_value = 1.f,
        .label = "Hue",
        .section = "LUT Builder: Per Channel Blowout",
        .tooltip = "Influence strength of hue shift from per channel tone map's blowout.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
        // .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },
    //lutpcb_chroma
    new renodx::utils::settings::Setting{
        .key = "lutpcb_chroma",
        .binding = &shader_injection.lutpcb_chroma,
        .default_value = 0.95f,
        .label = "Chroma",
        .section = "LUT Builder: Per Channel Blowout",
        .tooltip = "Influence strength of chrominance (saturation) from per channel tone map's blowout.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
        // .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },
    //lutpcb_saturation
    new renodx::utils::settings::Setting {
        .key = "lutpcb_saturation",
        .binding = &shader_injection.lutpcb_saturation,
        .default_value = 1.0f,
        .label = "Saturation",
        .section = "LUT Builder: Per Channel Blowout",
        .tooltip = "Since blowout uses uniform color space, this is a simple multiplier on chrominance/saturation.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.3f",
        // .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },
    /////////////////////////////////////////////////////////////////////////////////////////////
    //godrays
    new renodx::utils::settings::Setting{
        .key = "godrays",
        .binding = &shader_injection.godrays,
        .default_value = 1.f,
        .label = "God Rays",
        .section = "Post Processing",
        .tooltip = "Distortion of colors at screen edges.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.4f",
        .parse = [](float value) { return value < 1.f ? value : value * std::lerp(1.f, 5.f, value - 1); },
    },
    //bloom
    new renodx::utils::settings::Setting{
        .key = "bloom",
        .binding = &shader_injection.bloom,
        .default_value = 1.f,
        .label = "Bloom",
        .section = "Post Processing",
        .max = 2.f,
        .format = "%.4f",
        .parse = [](float value) { return value < 1.f ? value : value * std::lerp(1.f, 5.f, value - 1); },
    },
    //chromaticaberration
    new renodx::utils::settings::Setting{
        .key = "chromaticaberration",
        .binding = &shader_injection.chromaticaberration,
        .default_value = 1.f,
        .label = "Chromatic Aberration",
        .section = "Post Processing",
        .tooltip = "Per-channel seperation of colors at screen edges.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.4f",
        .parse = [](float value) { return value < 1.f ? value : value * std::lerp(1.f, 10.f, value - 1); },
    },
    //vignette
    new renodx::utils::settings::Setting{
        .key = "vignette",
        .binding = &shader_injection.vignette,
        .default_value = 1.f,
        .label = "Vignette",
        .section = "Post Processing",
        .tooltip = "Darkening of screen edges.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.4f",
    },
    //lensdirt
    new renodx::utils::settings::Setting{
        .key = "lensdust",
        .binding = &shader_injection.lensdust,
        .default_value = 1.f,
        .label = "Lens Dust/Dirt",
        .section = "Post Processing",
        .tooltip = "Strength of lens flare dust/dirt mask.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.4f",
        .parse = [](float value) { return value < 1.f ? value : value * std::lerp(1.f, 10.f, value - 1); },
    },
    //exposure
    new renodx::utils::settings::Setting{
        .key = "exposure",
        .binding = &shader_injection.exposure,
        .default_value = 1.0f,
        .label = "Exposure",
        .section = "Post Processing",
        .tooltip = "Multiplier on raw finalized HDR color before sampling LUT.",
        .min = 0.f,
        .max = 3.0f,
        .format = "%.4f",
    },   
    /////////////////////////////////////////////////////////////////////////////////////////////
    //cg_exposure
    new renodx::utils::settings::Setting{
        .key = "cg_exposure",
        .binding = &shader_injection.cg_exposure,
        .default_value = 1.0f,
        .label = "Exposure",
        .section = "RenoDX Color Grade",
        .tooltip = "Multiplier on final color.",
        .min = 0.f,
        .max = 3.0f,
        .format = "%.3f",
        .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },
    //cg_midgray
    new renodx::utils::settings::Setting{
        .key = "cg_midgray",
        .binding = &shader_injection.cg_midgray,
        .default_value = 0.18f,
        .label = "Mid Gray",
        .section = "RenoDX Color Grade",
        .tooltip = "The middle gray point for subsequent color grading settings.",
        .min = 0.0001f,
        .max = 0.5f,
        .format = "%.4f",
        .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },
    //cg_contrast
    new renodx::utils::settings::Setting{
        .key = "cg_contrast",
        .binding = &shader_injection.cg_contrast,
        .default_value = 1.0f,
        .label = "Contrast",
        .section = "RenoDX Color Grade",
        .tooltip = "Both shadows and highlights stretching by luminance.",
        .min = 0.f,
        .max = 2.0f,
        .format = "%.4f",
        .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },
    //cg_highlights
    new renodx::utils::settings::Setting{
        .key = "cg_highlights",
        .binding = &shader_injection.cg_highlights,
        .default_value = 1.0f,
        .label = "Highlights",
        .section = "RenoDX Color Grade",
        .tooltip = "Highlight stretching by luminance.",
        .min = 0.9f,
        .max = 1.1f,
        .format = "%.4f",
        .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },
    //cg_shadows
    new renodx::utils::settings::Setting{
        .key = "cg_shadows",
        .binding = &shader_injection.cg_shadows,
        .default_value = 1.0f,
        .label = "Shadows",
        .section = "RenoDX Color Grade",
        .tooltip = "Shadow stretching by luminance.",
        .min = 0.f,
        .max = 2.0f,
        .format = "%.4f",
        .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },

    // Tone Mapper //////////////////////////////////////////////////////////////////////////////////////
    new renodx::utils::settings::Setting{
        .key = "tone_map_type",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Mode",
        .section = "Tone Map",
        .tooltip = "Fixed: 1000 nits only. Fixed the original PQ encode from being clipped.\nThis should be if the game got a patch to fix HDR10.\n\n"
                   "Modded Vanilla: Tries to restore the LUT tonemapped luminance to the raw original by using the delta,\nthen tonemap it down to the new peak.\n\n"
                   "Modded New: Removed the original low contrast tonemap spline,\ngiving more contrast and 10000 nits worth of info from LUT.",
        .labels = {"Fixed 1000", "Modded Vanilla", "Modded New"},
    },
    new renodx::utils::settings::Setting{
        .key = "diffuse_white_nits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Paper White",
        .section = "Tone Map",
        .tooltip = "Nits of 100% white.\nThis determines the pivot point of tonemapping effects.",
        .min = 1.f,
        .max = 500.f,
        .format = "%.0f",
    },
    new renodx::utils::settings::Setting{
        .key = "gamma_correction",
        .binding = &shader_injection.gamma_correction,
        .default_value = 2.2f,
        .label = "Gamma Correction",
        .section = "Tone Map",
        .tooltip = "EOTF Emulate / Gamma Correction (Per-Channel BT2020).\nAlso adds to movies gamma decode.",
        .min = 0.f,
        .max = 4.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "tone_map_type_hdr",
        .binding = &shader_injection.tone_map_type_hdr,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Type",
        .section = "Tone Map",
        .tooltip = "Reinhard: Very Gradual\n"
                   "Hermite Spline: Scalable.\n"
                   "NeuTwo: Aggressive.",
        .labels = {"Reinhard", "Hermite Spline", "NeuTwo"},
        .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
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
        .max = 10000.f,
        .is_visible = []() { return shader_injection.tone_map_type >= 1.f; },
    },
    new renodx::utils::settings::Setting{
        .key = "expected_peak_white_nits",
        .binding = &shader_injection.expected_peak_white_nits,
        .default_value = 1.f,
        .label = "Expected Peak",
        .section = "Tone Map",
        .tooltip = "Scales expected max input of tonemapper.\nLower to white clip.",
        .min = 0.0001f,
        .max = 2.0f,
        .format = "%.4f",
        .is_visible = []() { return shader_injection.tone_map_type >= 1.f && shader_injection.tone_map_type_hdr == 1.f; },
    },
};

void OnPresetOff() {
    ApplyVanilla(settings, true);
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
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (GRID Legends)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        //shader
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;

        //swapchain
        renodx::mods::swapchain::swap_chain_proxy_shaders = {};

        // //tex upgrades
        // renodx::mods::swapchain::resource_upgrade_infos.push_back({ //mov
        //     .old_format = reshade::api::format::r8g8b8a8_unorm_srgb,
        //     .new_format = reshade::api::format::r16g16b16a16_float,
        //     .ignore_size = false,
        //     .use_resource_view_cloning = false, 
        //     .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
        //     .dimensions = {
        //         .width = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER, 
        //         .height = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER, 
        //         .depth = 0
        //     },
        //     .usage_include = reshade::api::resource_usage::render_target,
        // });

        //About
        {
            auto* s = new renodx::utils::settings::Setting{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Build Date: " + build_date + " - " + build_time,
                .section = "About",
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
//   renodx::mods::swapchain::Use(fdw_reason, &shader_injection); ///GRID Legends: explodes game!
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
