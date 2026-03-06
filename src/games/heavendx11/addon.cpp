/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

// #define DEBUG_LEVEL_0

#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x00000000),
    // CustomSwapchainShader(0x00000000),
    // BypassShaderEntry(0x00000000),
    __ALL_CUSTOM_SHADERS
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;

renodx::utils::settings::Settings settings = {
    // new renodx::utils::settings::Setting{
    //     .key = "SettingsMode",
    //     .binding = &current_settings_mode,
    //     .value_type = renodx::utils::settings::SettingValueType::INTEGER,
    //     .default_value = 0.f,
    //     .can_reset = false,
    //     .label = "Settings Mode",
    //     .labels = {"Simple", "Intermediate", "Advanced"},
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

    new renodx::utils::settings::Setting{
        .key = "FPSLimit",
        .binding = &renodx::utils::swapchain::fps_limit,
        .default_value = 0.f,
        .can_reset = false,
        .label = "FPS",
        .section = "FPS Limit",
        .min = 0.f,
        .max = 240.f,
        .parse = [](float value) { return value * 2.f; },
        .is_global = true,
    },

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
        .key = "tone_map_type",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Type",
        .section = "Tone Map",
        .tooltip = "Choose to perferrence.",
        .labels = {"Off", "SDR", "Hermite Spline"},
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
    },
    new renodx::utils::settings::Setting{
        .key = "expected_peak_white_nits",
        .binding = &shader_injection.expected_peak_white_nits,
        .default_value = 5000.f,
        .label = "Expected Peak",
        .section = "Tone Map",
        .tooltip = "Expected max of HDR luminance.\nLower to white clip.",
        .min = 203.f,
        .max = 10000.f,
        .is_visible = []() { return shader_injection.tone_map_type == 2.f; },
    },

    new renodx::utils::settings::Setting{
        .key = "bloom",
        .binding = &shader_injection.bloom,
        .default_value = 1.f,
        .label = "Bloom + Streaks",
        .section = "Extra",
        .tooltip = "Tied strength of both bloom and streaks.",
        .max = 2.f,
        .format = "%.2f",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "bloom_streaks",
        .binding = &shader_injection.bloom_streaks,
        .default_value = 1.f,
        .label = "Streaks",
        .section = "Extra",
        .tooltip = "Strength of streaks.",
        .max = 2.f,
        .format = "%.2f",
        // .parse = [](float value) { return value * value * value; },
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "bloom_streakslength",
        .binding = &shader_injection.bloom_streakslength,
        .default_value = 1.f,
        .label = "Streaks Length",
        .section = "Extra",
        .tooltip = "Length of streaks.",
        .max = 4.f,
        .format = "%.2f",
        // .parse = [](float value) { return value * value * value; },
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "bloom_streaksrolloff",
        .binding = &shader_injection.bloom_streaksrolloff,
        .default_value = 0.75f,
        .label = "Streaks Release",
        .section = "Extra",
        .tooltip = "Let streaks roll off in brightness the further it is away from center.",
        .max = 1.5f,
        .format = "%.2f",
        // .parse = [](float value) { return value * value * value; },
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "lens_flare",
        .binding = &shader_injection.lens_flare,
        .default_value = 1.f,
        .label = "Lens Flare",
        .section = "Extra",
        .max = 2.f,
        .format = "%.2f",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "lens_dirt",
        .binding = &shader_injection.lens_dirt,
        .default_value = 1.f,
        .label = "Lens Flare Dirt",
        .section = "Extra",
        .max = 1.f,
        .format = "%.2f",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "sun_boost",
        .binding = &shader_injection.sun_boost,
        .default_value = 1.4f,
        .label = "Sun Boost",
        .section = "Extra",
        .tooltip = "Boost the sun to reach higher nits.",
        .min = 1.f,
        .max = 2.f,
        .format = "%.2f",
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ui",
        .binding = &shader_injection.ui,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "UI",
        .section = "Extra",
        // .tooltip = "*Not comprehensive, enough for Photo Mode.",
        .labels = {"Off", "On"},
    },

    new renodx::utils::settings::Setting{
        .key = "pblow_enabled",
        .binding = &shader_injection.pblow_enabled,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Blowout",
        .section = "Per-Channel Blowout",
        .tooltip = "How should blowout be sourced?",
        .labels = {"HDR Tonemap", "Low Peak Tonemap"},
        // .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_chue",
        .binding = &shader_injection.pblow_chue,
        .default_value = 0.76f,
        .label = "Hue",
        .section = "Per-Channel Blowout",
        .tooltip = "Hue shift influence.",
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.pblow_enabled > 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_csat",
        .binding = &shader_injection.pblow_csat,
        .default_value = 0.72f,
        .label = "Chrominance",
        .section = "Per-Channel Blowout",
        .tooltip = "Saturation influence.",
        .max = 1.f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.pblow_enabled > 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_start",
        .binding = &shader_injection.pblow_start,
        .default_value = 0.36f,
        .label = "Shoulder Start",
        .section = "Per-Channel Blowout",
        .tooltip = "The threshold before the low peak tonemapper engages.",
        .max = 1.5f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.pblow_enabled > 0; },
    },
    new renodx::utils::settings::Setting{
        .key = "pblow_max",
        .binding = &shader_injection.pblow_max,
        .default_value = 1.80f,
        .label = "Peak",
        .section = "Per-Channel Blowout",
        .tooltip = "The peak of the low peak tonemapper.",
        .max = 3.0f,
        .format = "%.2f",
        .is_visible = []() { return shader_injection.pblow_enabled > 0; },
    },
    
    new renodx::utils::settings::Setting{
        .key = "lut",
        .binding = &shader_injection.lut,
        .default_value = 100.f,
        .label = "LUT",
        .section = "Color Grade",
        .tooltip = "Color grade from LUT.",
        .max = 100.f,
        // .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "cg_exposure",
        .binding = &shader_injection.cg_exposure,
        .default_value = 1.0f,
        .label = "Exposure",
        .section = "Color Grade",
        .tooltip = "Multiplier on color.",
        .max = 2.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "cg_contrast",
        .binding = &shader_injection.cg_contrast,
        .default_value = 1.0f,
        .label = "Contrast",
        .section = "Color Grade",
        .tooltip = "Both shadows and highlights stretching by luminance.",
        .max = 2.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "cg_shadows",
        .binding = &shader_injection.cg_shadows,
        .default_value = 1.0f,
        .label = "Shadows",
        .section = "Color Grade",
        .tooltip = "Highlight stretching by luminance.",
        .max = 2.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "cg_highlights",
        .binding = &shader_injection.cg_highlights,
        .default_value = 1.0f,
        .label = "Highlights",
        .section = "Color Grade",
        .tooltip = "Highlight stretching by luminance.",
        .max = 2.0f,
        .format = "%.3f",
    },
    
    new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_gamma",
        .binding = &shader_injection.fakewcgcorrect_gamma,
        .default_value = 2.2f,
        .label = "Strength",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Strength of gamma gamut expansion.",
        .min = 0.f,
        .max = 3.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_chroma",
        .binding = &shader_injection.fakewcgcorrect_chroma,
        .default_value = 0.5f,
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
        .default_value = 0.0f,
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
        .default_value = 1.025f,
        .label = "Saturation",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Simple saturation multiplier.",
        .min = 0.5f,
        .max = 1.5f,
        .format = "%.3f",
        .is_enabled = []() { return shader_injection.fakewcgcorrect_gamma > 0.f; },
    },
};

//Note: OnDraw() misses ui.

void OnPresetOff() {
    renodx::utils::settings::UpdateSetting("tone_map_type", 1.f);
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

// void OnPresent(reshade::api::command_queue* queue,
//                reshade::api::swapchain* swapchain,
//                const reshade::api::rect* source_rect,
//                const reshade::api::rect* dest_rect,
//                uint32_t dirty_rect_count,
//                const reshade::api::rect* dirty_rects) {
//   auto* device = queue->get_device();
//   if (device->get_api() == reshade::api::device_api::opengl) {
//     shader_injection.custom_flip_uv_y = 1.f;
//   }
// }

bool initialized = false;

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

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Heaven DX11)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        //shader settings
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;

        //swapchain settings
        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true; //req
        renodx::mods::swapchain::use_device_proxy = true; //req
        renodx::mods::swapchain::set_color_space = false; //req
        renodx::mods::swapchain::swapchain_proxy_revert_state = true; //should be safer?

        //3D Lut
        // renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
        //     .old_format = reshade::api::format::r8g8b8a8_unorm,
        //     .new_format = reshade::api::format::r16g16b16a16_unorm,
        //     .ignore_size = false,
        //     .use_resource_view_cloning = true,
        //     .dimensions = {
        //         .width = 32,
        //         .height = 32,
        //         .depth = 32
        //     },
        //     .usage_include = reshade::api::resource_usage::shader_resource_pixel,
        // });

        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
        };

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Output",
              .section = "Display Output (Restart Req.)",
              .tooltip = "Choose output mode.",
              .labels = {"HDR10", "scRGB"},
              .on_change_value = [](float previous, float current) {
                //nothing
              },
              .is_global = true,
            //   .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::SetUseHDR10(setting->GetValue() == 0);
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
            //   .is_visible = []() { return current_settings_mode >= 2; },
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
            //   .is_visible = []() { return current_settings_mode >= 2; },
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

        //register
        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      //unregister
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
