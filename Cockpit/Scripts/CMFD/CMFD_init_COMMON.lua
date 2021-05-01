dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path .. "materials.lua")

indicator_type = indicator_types.COMMON
purposes       = {render_purpose.GENERAL, render_purpose.HUD_ONLY_VIEW}

local cmfd_page_path = LockOn_Options.script_path .. "CMFD/Indicator/"
dofile(cmfd_page_path .. "../utils.lua")
dofile(cmfd_page_path .. "../CMFD_pageID_defs.lua")


page_subsets = {
    [SUB_PAGE_ID.BASE        ] = cmfd_page_path .. "FULL_BASE.lua",
    [SUB_PAGE_ID.OFF         ] = cmfd_page_path .. "CMFD_OFF.lua",
    [SUB_PAGE_ID.NOAUX       ] = cmfd_page_path .. "CMFD_NOAUX.lua",
    [SUB_PAGE_ID.MENU1       ] = cmfd_page_path .. "CMFD_Menu1.lua",
    [SUB_PAGE_ID.MENU2       ] = cmfd_page_path .. "CMFD_Menu2.lua",
    [SUB_PAGE_ID.DTE         ] = cmfd_page_path .. "CMFD_DTE.lua",
    [SUB_PAGE_ID.FLIR        ] = cmfd_page_path .. "CMFD_FLIR.lua",
    [SUB_PAGE_ID.DVR         ] = cmfd_page_path .. "CMFD_DVR.lua",
    [SUB_PAGE_ID.CHECKLIST   ] = cmfd_page_path .. "CMFD_CHECKLIST.lua",
    [SUB_PAGE_ID.PFL         ] = cmfd_page_path .. "CMFD_PFL.lua",
    [SUB_PAGE_ID.BIT         ] = cmfd_page_path .. "CMFD_BIT.lua",
    [SUB_PAGE_ID.NAV         ] = cmfd_page_path .. "CMFD_NAV.lua",
    [SUB_PAGE_ID.HSD         ] = cmfd_page_path .. "CMFD_HSD.lua",
    [SUB_PAGE_ID.HUD         ] = cmfd_page_path .. "CMFD_HUD.lua",
    [SUB_PAGE_ID.SMS         ] = cmfd_page_path .. "CMFD_SMS.lua",
    [SUB_PAGE_ID.EW          ] = cmfd_page_path .. "CMFD_EW.lua",
    [SUB_PAGE_ID.ADHSI       ] = cmfd_page_path .. "CMFD_ADHSI.lua",
    [SUB_PAGE_ID.UFCP        ] = cmfd_page_path .. "CMFD_UFCP.lua",
    [SUB_PAGE_ID.EICAS       ] = cmfd_page_path .. "CMFD_EICAS.lua",  
}

pages = {
    [PAGE_ID] = {
        SUB_PAGE_ID.BASE, 
        SUB_PAGE_ID.OFF,
        SUB_PAGE_ID.NOAUX,
        SUB_PAGE_ID.MENU1, 
        SUB_PAGE_ID.MENU2,
        SUB_PAGE_ID.DTE,
        SUB_PAGE_ID.FLIR,
        SUB_PAGE_ID.DVR,
        SUB_PAGE_ID.CHECKLIST,
        SUB_PAGE_ID.PFL,
        SUB_PAGE_ID.BIT,
        SUB_PAGE_ID.NAV,
        SUB_PAGE_ID.HSD,
        SUB_PAGE_ID.HUD,
        SUB_PAGE_ID.SMS,
        SUB_PAGE_ID.EW,
        SUB_PAGE_ID.ADHSI,
        SUB_PAGE_ID.UFCP,
        SUB_PAGE_ID.EICAS
    },
}

-- init_pageID = PAGE_ID.PAGE_ID_OFF

--used_render_mask = LockOn_Options.script_path .. "../Textures/IndicationTextures/mask_MFCD_day.dds" --"interleave" --default mask for TV
used_render_mask = "interleave" --default mask for TV


mat_tbl = {
    "cmfd_tex_eicas",

    "cmfd_tex_ind1",
    "cmfd_tex_ind1_g",
    "cmfd_tex_ind1_w",
    "cmfd_tex_ind1_wy",
    "cmfd_tex_ind1_y",
    "cmfd_tex_ind1_r",

    "cmfd_tex_ind2",
    "cmfd_tex_ind2_g",
    "cmfd_tex_ind2_w",
    "cmfd_tex_ind2_wy",
    "cmfd_tex_ind2_y",
    "cmfd_tex_ind2_r",

    "cmfd_tex_ind3",
    "cmfd_tex_ind3_g",
    "cmfd_tex_ind3_w",
    "cmfd_tex_ind3_wy",
    "cmfd_tex_ind3_y",
    "cmfd_tex_ind3_r",
    "cmfd_tex_ind3_bl",

    "cmfd_tex_ind4",
    "cmfd_tex_ind4_g",
    "cmfd_tex_ind4_w",
    "cmfd_tex_ind4_wy",
    "cmfd_tex_ind4_y",
    "cmfd_tex_ind4_r",

    "cmfd_tex_ind5",
    "cmfd_tex_ind5_g",
    "cmfd_tex_ind5_w",
    "cmfd_tex_ind5_wy",
    "cmfd_tex_ind5_y",
    "cmfd_tex_ind5_r",

    "cmfd_mesh_def",
    "cmfd_mesh_r",
    "cmfd_mesh_g",
    "cmfd_mesh_b",
    "cmfd_mesh_d",
    "cmfd_mesh_w",
    "cmfd_mesh_wy",
    "cmfd_mesh_p",
    "cmfd_mesh_y",
    "cmfd_mesh_sky",
    "cmfd_mesh_gnd",
    "cmfd_mesh_boxbase",
    "cmfd_mesh_whitebase",

    "cmfd_font_def",
    "cmfd_font_g",
    "cmfd_font_dg",
    "cmfd_font_b",
    "cmfd_font_w",
    "cmfd_font_wy",
    "cmfd_font_d",
    "cmfd_font_r",
    "ufcp_font_def",
}

-- MFCD Colors
brightness_sensitive_materials = mat_tbl
opacity_sensitive_materials    = mat_tbl

color_sensitive_materials      = {
    "cmfd_tex_ind1",
    "cmfd_tex_ind1_g",

    "cmfd_tex_ind2",
    "cmfd_tex_ind2_g",

    "cmfd_tex_ind3",
    "cmfd_tex_ind3_g",

    "cmfd_tex_ind4",
    "cmfd_tex_ind4_g",

    "cmfd_tex_ind5",
    "cmfd_tex_ind5_g",

    "cmfd_mesh_def",
    "cmfd_mesh_g",

    "cmfd_font_def",
    "cmfd_font_g",
    "cmfd_font_dg",

    "cmfd_wpn_font_def",
    "cmfd_wpn_font_g",
    --"cmfd_wpn_svg_font_def",
    "ufcp_font_def",
}

is_colored         = true

color_green_day    = {0, 1.0, 0}
color_green_night  = {0, 0.5, 0}

color_blue_day     = {0, 1.0, 0}
color_blue_night   = {0, 1.0, 0}

color_yellow_day   = {1.0, 1.0, 0}
color_yellow_night = {0.5, 0.5, 0}

color_orange_day   = {0.98, 0.38, 0}
color_orange_night = {0.49, 0.19, 0}

color_red_day      = {1.0, 0, 0}
color_red_night    = {0.5, 0, 0}

color_red2_day     = {1.0, 0, 0}
color_red2_night   = {0.5, 0, 0}

color_white_day    = {1.0, 1.0, 1.0}
color_white_night  = {0.5, 0.5, 0.5}

color_sky_day      = {47/255, 135/255, 1.0}
color_sky_night    = {23.5/255, 67.5/255, 0.5}

color_gnd_day      = {49/255, 5/255, 1/255}
color_gnd_night    = {24.5/255, 2.5/255, 0.5/255}

-- HUD only view diplacement
function CMFD_set_screenspace_displacement(aspect, left_center_right, zoom_value)
    local w = LockOn_Options.screen.width;
    local h = LockOn_Options.screen.height;

    if LockOn_Options.screen.oculus_rift then
        local ui_x,ui_y,ui_w,ui_h = get_UIMainView()
        w = ui_w;
        h = ui_h;
    end

    local x0 = 0
    local w0 = 0.5 * h

    local aspect     =     aspect or 1
    local zoom_value = zoom_value or 1
    local default_width  = w0

    if default_width > h then
       default_width = h
    end

    if default_width > 0.5 * w then
       default_width = 0.5 * w
    end

    default_width = default_width * math.abs(zoom_value)
    local default_height = default_width / aspect
    local default_y      = h - default_height
    local default_x      = w - default_width - x0

    if left_center_right == -1 then -- left
        default_x   = x0
    else
        if left_center_right == 0 then -- center
            default_x = default_x /2
        end
    end

    dedicated_viewport           = {default_x,default_y,default_width,default_height}
    dedicated_viewport_arcade = {default_x, 0        ,default_width,default_height}
end
