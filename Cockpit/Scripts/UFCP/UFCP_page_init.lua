dofile(LockOn_Options.script_path.."UFCP/UFCP_pageID_defs.lua")
dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path .. "materials.lua")
dofile(LockOn_Options.script_path .. "Indicator/utils.lua")



indicator_type = indicator_types.COMMON
purposes       = {render_purpose.GENERAL}

local cmfd_page_path = LockOn_Options.script_path .. "UFCP/Indicator/"

page_subsets = {
    [SUB_PAGE_ID.BASE        ] = cmfd_page_path .. "UFCP_BASE.lua",
    [SUB_PAGE_ID.MAIN        ] = cmfd_page_path .. "UFCP_MAIN.lua",
    [SUB_PAGE_ID.OFF         ] = cmfd_page_path .. "UFCP_OFF.lua",
}

pages = {
    [PAGE_ID] = {SUB_PAGE_ID.BASE,  SUB_PAGE_ID.MAIN, SUB_PAGE_ID.OFF},
}

-- debugGUI = true

init_pageID = PAGE_ID

-- dofile(LockOn_Options.common_script_path.."ViewportHandling.lua")

-- local w = LockOn_Options.screen.width;
-- local h = LockOn_Options.screen.height;

-- local hud_only_view_position = best_fit_rect(0, h * (1 - 50/120), w/3 , h * 50/120, Viewport_Align.left, Viewport_Align.vcenter, UFCP_aspect)
-- dedicated_viewport           = hud_only_view_position
-- dedicated_viewport_arcade    = hud_only_view_position

-- local default_viewport = try_find_assigned_viewport('A29B_UFCP', 'UFCP')
-- if default_viewport then
--     dedicated_viewport = {default_viewport.x, default_viewport.y, default_viewport.width, default_viewport.height}
--     dedicated_viewport_arcade = {default_viewport.x, default_viewport.y, default_viewport.width, default_viewport.height}
--     purposes                  = {render_purpose.GENERAL, render_purpose.SCREENSPACE_INSIDE_COCKPIT, render_purpose.HUD_ONLY_VIEW}
--     render_target_always      = true
-- end

dofile(LockOn_Options.common_script_path.."ViewportHandling.lua")
try_find_assigned_viewport("A29B_UFCP")
