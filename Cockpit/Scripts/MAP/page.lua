dofile(LockOn_Options.common_script_path.."elements_defs.lua")


SetScale(FOV)
picture					 = CreateElement "ceTexPoly"
picture.name			 = "picture"
picture.vertices		 = {{-1, 1},
							{ 1, 1},
							{ 1,-1},
							{-1,-1}}
picture.indices			 = {0, 1, 2, 0, 2, 3}
picture.tex_coords		 = {{0, 0},
                            {1, 0},
                            {1, 1},
                            {0, 1}}
picture.material		 = "render_target_3"
picture.isvisible = false
picture.level = 1
Add(picture)



