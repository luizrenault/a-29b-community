dofile(LockOn_Options.script_path.."CMFD/CMFD_pageID_defs.lua")
cmfd_id = CMFD.LCMFD

dofile(LockOn_Options.script_path.."CMFD/CMFD_init_COMMON.lua")

-- debugGUI = true

init_pageID = PAGE_ID

-- dofile(LockOn_Options.common_script_path.."ViewportHandling.lua")

-- -- -- MFCD position in HUD only view
-- -- -- MFCD_set_screenspace_displacement(3/4, -1, 0.8)
-- -- local w = LockOn_Options.screen.width;
-- -- local h = LockOn_Options.screen.height;

-- -- local hud_only_view_position = best_fit_rect(0, h * (1 - 50/120), w/3 , h * 50/120, Viewport_Align.left, Viewport_Align.vcenter, MFCD_aspect)
-- -- dedicated_viewport           = hud_only_view_position
-- -- dedicated_viewport_arcade    = hud_only_view_position


-- -- local default_viewport = try_find_assigned_viewport('A29B_LEFT_MFCD', 'LEFT_MFCD')
-- -- if default_viewport then
-- --     dedicated_viewport = {default_viewport.x, default_viewport.y, default_viewport.width, default_viewport.height}
-- --     dedicated_viewport_arcade = {default_viewport.x, default_viewport.y, default_viewport.width, default_viewport.height}
-- --     purposes                  = {render_purpose.GENERAL, render_purpose.SCREENSPACE_INSIDE_COCKPIT, render_purpose.HUD_ONLY_VIEW}
-- --     render_target_always      = true
-- -- end

dofile(LockOn_Options.common_script_path.."ViewportHandling.lua") 
try_find_assigned_viewport("A29B_LEFT_MFCD")
