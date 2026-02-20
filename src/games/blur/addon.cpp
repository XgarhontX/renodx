/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

 //DX9 proxy v2
#define RENODX_MODS_SWAPCHAIN_VERSION 2

#include <cfloat>
#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"

#include "../../utils/random.hpp"
#define RANDOM_FLOAT &shader_injection.seed

const std::string build_date = __DATE__;
const std::string build_time = __TIME__;

// #d50000
#define COLOR_PRESETBUTTONS 0xd50000

namespace {

ShaderInjectData shader_injection;

float current_settings_mode = 0;

// float fps_limit_mov = 0;
// float fps_limit = 0;

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
//     new renodx::utils::settings::Setting{
//         .value_type = renodx::utils::settings::SettingValueType::BUTTON,
//         .label = "settings.xml",
//         .group = "button-line-1",
//         .on_change = []() {
//             const char* filename = R"(%AppData%\bizarre creations\blur\settings.xml)"; 
// 
//             // Use ShellExecute to open the file with the default program
//             // The "open" verb is often used, but passing NULL uses the true default action
//             HINSTANCE result = ShellExecute(
//                 nullptr,           // No parent window
//                 nullptr,           // Operation (verb): NULL means default action (usually "open")
//                 filename,       // File to open
//                 nullptr,           // Parameters (none needed for opening a file)
//                 nullptr,           // Default directory
//                 SW_SHOWNORMAL   // How to show the launched application window
//             );
//         },
//     },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "(Bug) Some multithreading artifacts on some background warping translucency.",
        .section = "Readme",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "(Bug) Race ending screen's background snapshot is broken.",
        .section = "Readme",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "(Bug) In-game anti-aliasing will cause bloom to break (NaNs).",
        .section = "Readme",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "(Limitation) Some specular highlights are more bright.",
        .section = "Readme",
    },

    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BULLET,
        .label = "FPS may be reported x2 the value set.",
        .section = "FPS Limit",
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
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game",
        .section = "Brightness",
        .tooltip = "Sets the value of 100% white in nits.",
        .min = 1.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI",
        .section = "Brightness",
        .tooltip = "Sets the brightness of UI and HUD elements in nits.",
        .min = 1.f,
        .max = 500.f,
    },

    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .default_value = 203.f,
        .label = "Gamma Correction",
        .section = "Brightness",
        .tooltip = "The paper white / cutoff to emulate a display EOTF (2.2).",
        .min = 0.f,
        .max = 500.f,
    },

    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .label = "Type",
        .section = "Tone Map",
        .tooltip = "Choose to perferrence.",
        .labels = {"Off", "Hermite Spline (PerChannel)", "NeuTwo (PerChannel)"},
         .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
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
        .key = "ToneMapExpectedPeakNits",
        .binding = &shader_injection.expected_peak_white_nits,
        .default_value = 6000.f,
        .label = "Expected Peak",
        .section = "Tone Map",
        .tooltip = "Expected max of HDR luminance.\nLower to white clip.",
        .min = 203.f,
        .max = 10000.f,
        .is_visible = []() { return shader_injection.tone_map_type == 0.f; },
    },

      new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_gamma",
        .binding = &shader_injection.fakewcgcorrect_gamma,
        .default_value = 1.5f,
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
        .default_value = 0.7f,
        .label = "Correct Chroma",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Correct saturation boost's chroma to original.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_luma",
        .binding = &shader_injection.fakewcgcorrect_luma,
        .default_value = 0.6f,
        .label = "Correct Luma",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Correct saturation boost's luma to original.",
        .min = 0.f,
        .max = 0.9f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "fakewcgcorrect_sat",
        .binding = &shader_injection.fakewcgcorrect_sat,
        .default_value = 1.05f,
        .label = "Saturation",
        .section = "Fake Wide Color Gamut",
        .tooltip = "Simple saturation multiplier.",
        .min = 0.5f,
        .max = 1.5f,
        .format = "%.3f",
    },

    
    new renodx::utils::settings::Setting{
        .key = "c_cg_highlights",
        .binding = &shader_injection.c_cg_highlights,
        .default_value = 1.0f,
        .label = "Highlights",
        .section = "Color Grade",
        .tooltip = "Highlight stretching by luminance.",
        .min = 0.5f,
        .max = 1.5f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_cg_highlights_mid",
        .binding = &shader_injection.c_cg_highlights_mid,
        .default_value = 1.0f,
        .label = "Highlights Mid",
        .section = "Color Grade",
        .tooltip = "Controls the influence start.",
        .min = 0.5f,
        .max = 1.5f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_cg_shadows",
        .binding = &shader_injection.c_cg_shadows,
        .default_value = 1.0f,
        .label = "Shadows",
        .section = "Color Grade",
        .tooltip = "Highlight stretching by luminance.",
        .min = 0.5f,
        .max = 1.5f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_cg_shadows_mid",
        .binding = &shader_injection.c_cg_shadows_mid,
        .default_value = 1.0f,
        .label = "Shadows Mid",
        .section = "Color Grade",
        .tooltip = "Controls the influence start.",
        .min = 0.5f,
        .max = 1.5f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_gammaoffset",
        .binding = &shader_injection.c_gammaoffset,
        .default_value = 0.f,
        .label = "Gamma Offset",
        .section = "Color Grade",
        .tooltip = "Effectively contrast.",
        .min = -1.f,
        .max = 1.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_lut",
        .binding = &shader_injection.c_lut,
        .default_value = 1.f,
        .label = "LUT",
        .section = "Color Grade",
        .tooltip = "Influence of original color grading LUT.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_lut_highlightsat",
        .binding = &shader_injection.c_lut_highlightsat,
        .default_value = 0.65,
        .label = "LUT Extra Highlight Saturation",
        .section = "Color Grade",
        .tooltip = "Mitigates blowout.",
        .min = 0.0f,
        .max = 1.0f,
        .format = "%.3f",
        .parse = [](float value) { return 1-value; },
    },

    new renodx::utils::settings::Setting{
        .key = "c_filmgrain",
        .binding = &shader_injection.c_filmgrain,
        .default_value = 1.f,
        .label = "Film Grain",
        .section = "Custom",
        .tooltip = "(Replaced original static with RenoDX's luma based.)",
        .min = 0.f,
        .max = 2.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_tint",
        .binding = &shader_injection.c_tint,
        .default_value = 1.f,
        .label = "Tint",
        .section = "Custom",
        .tooltip = "e.g. modulation from powerup usage.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_bloom_strength",
        .binding = &shader_injection.c_bloom_strength,
        .default_value = 1.0f,
        .label = "Bloom Strength",
        .section = "Custom",
        .tooltip = "Multiplier for both bloom and procedural lens flare.",
        .min = 0.f,
        .max = 2.0f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_bloom_pow",
        .binding = &shader_injection.c_bloom_pow,
        .default_value = 1.0f,
        .label = "Bloom Contrast",
        .section = "Custom",
        .tooltip = "Power/Contrast for bloom color.",
        .min = 0.f,
        .max = 2.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_bloom_sat",
        .binding = &shader_injection.c_bloom_sat,
        .default_value = 1.25f,
        .label = "Bloom Saturation",
        .section = "Custom",
        .tooltip = "Saturation for bloom.",
        .min = 1.f,
        .max = 2.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_mb_blend",
        .binding = &shader_injection.c_mb_blend,
        .default_value = 1.f,
        .label = "Motion Blur: Scale",
        .section = "Custom",
        .tooltip = "Scales max blend (lerp) of motion blur color.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_mb_lenience",
        .binding = &shader_injection.c_mb_lenience,
        .default_value = 1.f,
        .label = "Motion Blur: Lenience",
        .section = "Custom",
        .tooltip = "Motion blur is only allowed when close to camera and if luminance is high.\nIncrease to relax thresholds.",
        .min = 0.f,
        .max = 5.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_vignette",
        .binding = &shader_injection.c_vignette,
        .default_value = 1.f,
        .label = "Vignette",
        .section = "Custom",
        .tooltip = "Vignette strength.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
        new renodx::utils::settings::Setting{
        .key = "c_ca",
        .binding = &shader_injection.c_ca,
        .default_value = 1.f,
        .label = "Chromatic Aberration",
        .section = "Custom",
        .tooltip = "Chromatic Aberration strength, the daze effect on taking damage.",
        .min = 0.f,
        .max = 1.f,
        .format = "%.3f",
    },
    new renodx::utils::settings::Setting{
        .key = "c_glitch",
        .binding = &shader_injection.c_glitch,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "Glitch",
        .section = "Custom",
        .tooltip = "Glitch effect when taken lots of damage.",
        .labels = {"Off", "On"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "c_ui",
        .binding = &shader_injection.c_ui,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = false,
        .label = "UI*",
        .section = "Custom",
        .tooltip = "*Not comprehensive, enough for Photo Mode.",
        .labels = {"Off", "On"},
        .is_global = true,
    },
};

void OnPresetOff() {
  renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
}

renodx::mods::shader::CustomShaders custom_shaders = {
    __ALL_CUSTOM_SHADERS,
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

bool OnDraw(reshade::api::command_list *cmd_list, uint32_t vertex_count, uint32_t instance_count, uint32_t first_vertex, uint32_t first_instance) {
    auto* shader_state = renodx::utils::shader::GetCurrentState(cmd_list);
    auto* pixel_state = renodx::utils::shader::GetCurrentPixelState(shader_state);
    auto pixel_shader_hash = renodx::utils::shader::GetCurrentPixelShaderHash(pixel_state);
    if (pixel_shader_hash == 0u) return false;
    // auto* swapchain_state = renodx::utils::swapchain::GetCurrentState(cmd_list);

    //case: UI 
    if (
        shader_injection.c_ui < 1.0f &&
        (
            pixel_shader_hash == 3761067718u /* 0xE02D56C6 */ ||
            pixel_shader_hash == 2298556114u /* 0x89012ED2 */ ||
            pixel_shader_hash == 2308274710u /* 0x89957A16 */ //TODO: this is bugged! 0x89957A16 is missed!!!
        )
    ) {
        return true;
    }
    
    return false; 
}

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Blur)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        // renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;  // From spec ops the line //TODO: needed?
        renodx::mods::shader::expected_constant_buffer_index = CBUFFER;
        // renodx::mods::shader::allow_multiple_push_constants = true;
        // renodx::mods::shader::use_pipeline_layout_cloning = true;
        // renodx::mods::shader::trace_unmodified_shaders = true;
        renodx::mods::shader::constant_buffer_offset = 50 * 4;  // From spec ops the line //TODO: needed?

        renodx::mods::swapchain::expected_constant_buffer_index = CBUFFER;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;  // From spec ops the line //TODO: needed?
        renodx::mods::swapchain::use_resource_cloning = true;
        // renodx::mods::swapchain::use_auto_upgrade = true;
        // renodx::mods::swapchain::swapchain_proxy_revert_state = true; //Blur: not necessary

        renodx::mods::swapchain::force_borderless = false; //Blur: Not needed
        renodx::mods::swapchain::prevent_full_screen = true; ///Blur: must, else forever stuck try fullscreen

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceForceTearing",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Force Tearing",
              .section = "Display Proxy (Restart Req.)",
              .tooltip = "Force the swapchain to tear regardless settings.",
              .labels = {"Off", "On"},
              .is_global = true,
            //   .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::force_screen_tearing = (setting->GetValue() == 1.f);
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

        renodx::mods::swapchain::set_color_space = false; //Blur: required DX9
        renodx::mods::swapchain::use_device_proxy = true; //Blur: required DX9
        // renodx::mods::swapchain::swapchain_proxy_compatibility_mode = false;

        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            // {
            //     reshade::api::device_api::d3d12,
            //     {
            //         .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
            //         .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
            //     },
            // },
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

        //Blur: Color
        renodx::mods::swapchain::resource_upgrade_infos.push_back({
            .old_format = reshade::api::format::b8g8r8a8_unorm,
            .new_format = reshade::api::format::r16g16b16a16_float,
            .ignore_size = true,
            .use_resource_view_cloning = false,
            // .use_resource_view_hot_swap = true,
            .aspect_ratio = renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER,
            // .dimensions = {renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER, renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER, 0},
            .usage_include = reshade::api::resource_usage::render_target,
        });

        //peak nits
        reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  

        //random
        renodx::utils::random::binds.push_back(RANDOM_FLOAT);

        //draw
        reshade::register_event<reshade::addon_event::draw>(OnDraw);

        //build date
        settings.push_back(new renodx::utils::settings::Setting{
            .value_type = renodx::utils::settings::SettingValueType::TEXT,
            .label = "Build Date: " + build_date + " - " + build_time,
            .section = "Credits",
        });

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);  // peak nits
      // renodx::utils::random::Use(fdw_reason); //TODO: needed?
      reshade::unregister_addon(h_module);
      reshade::unregister_event<reshade::addon_event::draw>(OnDraw);
      break;
  }

  renodx::utils::random::Use(fdw_reason);
  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

  return TRUE;
}
