dofile(LockOn_Options.common_script_path .. "devices_defs.lua")
dofile(LockOn_Options.script_path .. "materials.lua")

indicator_type = indicator_types.COLLIMATOR
purposes       = {render_purpose.GENERAL, render_purpose.HUD_ONLY_VIEW}

-- debugGUI = true
local script_path = LockOn_Options.script_path

-- SUB_PAGE_ID
HUD_PAGE_BASE       = 0
HUD_PAGE_OFF        = 1
HUD_PAGE_NORMAL     = 2
HUD_PAGE_GRID       = 3

page_subsets  = {
    [HUD_PAGE_BASE]    = script_path .. "HUD/Indicator/HUD_BASE.lua",   
    [HUD_PAGE_OFF]     = script_path .. "HUD/Indicator/HUD_OFF.lua",    
    [HUD_PAGE_NORMAL]  = script_path .. "HUD/Indicator/HUD_NORMAL.lua", 
    [HUD_PAGE_GRID]    = script_path .. "HUD/Indicator/HUD_GRID.lua",   
}

-- PAGE_ID
HUD_PAGESET_OFF    = 0
HUD_PAGESET_NORMAL = 1
HUD_PAGESET_GRID   = 2
HUD_PAGESET_TEST   = 3 -- to be removed

pages = {
    [HUD_PAGESET_OFF]    = { HUD_PAGE_BASE, HUD_PAGE_OFF },        
    [HUD_PAGESET_NORMAL] = { HUD_PAGE_BASE, HUD_PAGE_NORMAL, },    
    [HUD_PAGESET_GRID]   = { HUD_PAGE_BASE, HUD_PAGE_GRID },       
    -- [HUD_PAGESET_TEST]   = { HUD_PAGE_GENERAL },                   
}

init_pageID = HUD_PAGESET_GRID

mat_tbl = {
    "hud_tex_ind1",
    "hud_tex_ind2",
    
    "hud_mesh_def",
    "hud_mesh_base1",
    "hud_mesh_base2",
    
    "hud_tex_clip",
    "hud_line_dashed_def",
    
    "hud_font_def",
    "hud_font_g",
    "hud_font_b",
    "hud_font_w",
    "hud_font_r",
}

brightness_sensitive_materials = mat_tbl
opacity_sensitive_materials    = mat_tbl
color_sensitive_materials      = mat_tbl

is_colored   = true
day_color    = {0, 1.0, 0}
night_color  = {0, 0.5, 0}

