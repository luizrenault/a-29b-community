dofile(LockOn_Options.script_path.."BFI/definitions.lua")

local width  	   = 1;
local height 	   = width * GetAspect()
local back   	   = CreateElement "ceMeshPoly"
back.material 	   =  MakeMaterial(nil,{0,0,0,255})
back.vertices 	   = {{-width, height},
					  { width, height},
					  { width,-height},
					  {-width,-height}}
back.indices	  = {0,1,2;0,2,3}
back.element_params   = {"DC"} 
back.controllers 	   = {{"parameter_in_range",0,22,28.05}}
back.level		     = DISPLAY_DEFAULT_LEVEL
back.h_clip_relation = h_clip_relations.REWRITE_LEVEL
back.blend_mode 	 = blend_mode.IBM_NO_WRITECOLOR
back.isvisible		= true -- visible ou pas pour debug
Add(back)
