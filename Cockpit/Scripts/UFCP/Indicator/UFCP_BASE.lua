
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "UFCP/UFCP_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "UFCP/UFCP_Defs.lua")

local page_root = create_page_root()

local aspect = GetAspect()

local width  	   = 1;
local height 	   = width * GetAspect()
local back   	   = CreateElement "ceMeshPoly"
back.material 	   =  MakeMaterial(nil,{10,10,10,255})
back.vertices 	   = {{-width, height},
					  { width, height},
					  { width,-height},
					  {-width,-height}}
back.indices	  = {0,1,2;0,2,3}
back.level		     = DEFAULT_LEVEL
back.h_clip_relation = h_clip_relations.REWRITE_LEVEL
back.blend_mode 	 = blend_mode.IBM_NO_WRITECOLOR
back.isvisible		= false -- visible ou pas pour debug
Add(back)

