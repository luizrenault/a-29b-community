dofile(LockOn_Options.common_script_path.."elements_defs.lua")
SetScale(FOV)

-- picture					 = CreateElement "ceTexPoly"
-- picture.name			 = "picture_base"
-- picture.vertices		 = {{-1, 1},
-- 							{ 1, 1},
-- 							{ 1,-1},
-- 							{-1,-1}}
-- picture.indices			 = {0, 1, 2, 0, 2, 3}
-- picture.tex_coords		 = {{0, 0},
--                             {1, 0},
--                             {1, 1},
--                             {0, 1}}
-- picture.material		 = MakeMaterial(nil,{255,255,255,255})
-- picture.additive_alpha = false
-- Add(picture)



aspect 					= GetAspect()
render_tv				= CreateElement "ceTexPoly"
render_tv.vertices		= {{-1, aspect},
						   { 1, aspect},
						   { 1,-aspect},
						   {-1,-aspect}}
render_tv.indices			= {0, 1, 2, 0, 2, 3}
render_tv.tex_coords		= {{0,0},
						   {1,0},
						   {1,1},
						   {0,1}}
render_tv.material		= "render_target_"..string.format("%d",GetRenderTarget() + 1)
-- render_tv.controllers 	= {{"render_purpose",render_purpose.GENERAL,
-- 											 render_purpose.HUD_ONLY_VIEW,
-- 											 render_purpose.SCREENSPACE_OUTSIDE_COCKPIT}}
render_tv.isvisible = false
Add(render_tv)


local width  	   = 1;
local height 	   = width * GetAspect()
local back   	   = CreateElement "ceMeshPoly"
back.material 	   =  MakeMaterial(nil,{255,255,255,255})
back.vertices 	   = {{-width, height},
					  { width, height},
					  { width,-height},
					  {-width,-height}}
back.indices	  = {0,1,2;0,2,3}
back.level		     = DEFAULT_LEVEL
back.h_clip_relation = h_clip_relations.REWRITE_LEVEL
back.blend_mode 	 = blend_mode.IBM_NO_WRITECOLOR
Add(back)


local render_tv					= CreateElement "ceTexPoly"
render_tv.vertices		= {{-1, aspect},
                             { 1, aspect},
                             { 1,-aspect},
                             {-1,-aspect}}
render_tv.indices			= {0, 1, 2, 0, 2, 3}
render_tv.tex_coords		= {{0,0},
                             {1,0},
                             {1,1},
                             {0,1}}
render_tv.material		=  MakeMaterial("mfd"..string.format("%d",GetRenderTarget()),{255,255,255,255})
-- render_tv.controllers 	= {{"to_render_target",0}}
render_tv.h_clip_relation = h_clip_relations.REWRITE_LEVEL
render_tv.level 		    = DEFAULT_LEVEL
render_tv.blend_mode 		= blend_mode.IBM_REGULAR_RGB_ONLY
Add(render_tv)


