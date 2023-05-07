dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."ViewportHandling.lua")

render_target		 = 2 -- mfd0 
indicator_type       = indicator_types.COMMON
page_subsets    	 = {LockOn_Options.script_path.."MAP/page.lua"}
pages 				 = {{1}}
init_pageID     	 = 1

purposes 	 = {render_purpose.SCREENSPACE_INSIDE_COCKPIT}

update_screenspace_diplacement(36/24,false,0)
dedicated_viewport_arcade = dedicated_viewport

screen_condition = 1
map_volume = 1000
chart_type = 1
