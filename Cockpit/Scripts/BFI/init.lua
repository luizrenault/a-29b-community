dofile(LockOn_Options.script_path.."functions.lua")

startup_print("BFI: load")

dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."BFI/materials.lua")

-- dofile(LockOn_Options.common_script_path.."ViewportHandling.lua")

indicator_type       = indicator_types.COMMON----------------------
purposes = {render_purpose.GENERAL}
init_pageID     = 1
-- purposes 	   = {render_purpose.GENERAL}
--subset ids
BASE    = 1
INDICATION = 2

page_subsets  = {
[BASE]    		= LockOn_Options.script_path.."BFI/base_page.lua",
[INDICATION]    = LockOn_Options.script_path.."BFI/indication_page.lua",
}
pages = 
{
	{
	 BASE,
	 INDICATION
	 },
}

dofile(LockOn_Options.common_script_path.."ViewportHandling.lua") 
try_find_assigned_viewport("A29B_BFI")

-- update_screenspace_diplacement(SelfWidth/SelfHeight,false)
-- dedicated_viewport_arcade = dedicated_viewport
startup_print("BFI: load end")