dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."ViewportHandling.lua")

render_target		 = 1 -- mfd0 
indicator_type       = indicator_types.COMMON
page_subsets    	 = {LockOn_Options.script_path.."CMFD/Indicator/CMFD_HUD_Camera_page.lua"}
pages 				 = {{1}}
init_pageID     	 = 1
purposes 	 = {render_purpose.SCREENSPACE_INSIDE_COCKPIT}

camera = -- superseeded by ccSimplestFLIR when used with it.
{
	pos		  = {0 ,0 ,0},
	elevation = 0,
	fov 	  = math.atan(0.5 * 36/100)--FED-100 100 mm , film 35mm 24x36
}

update_screenspace_diplacement(36/24,true,0)
dedicated_viewport_arcade = dedicated_viewport
debug=true
