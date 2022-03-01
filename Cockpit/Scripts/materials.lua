dofile(LockOn_Options.script_path.."fonts.lua")

materials = {}
fonts = {}
textures = {}

materials["green"]	= {0, 255, 0, 255}
materials["white"]	= {255, 255, 255, 255}
materials["cyan"]	= {0, 255, 255, 255}
materials["amber"]	= {255, 194, 0, 255}
materials["red"]	= {255, 0, 0, 255}
materials["black"]	= {0, 0, 0, 255}


-- -------FONTS----------

fonts["a29b_font_hud_green"]					= {fontdescription["a29b_font_hud"], 10, materials["green"]}
fonts["font_Arial_white"]				= {fontdescription["font_Arial"], 10, materials["white"]}
fonts["font_Bold_Arial_white"]			= {fontdescription["font_Arial"], 10, materials["white"]}
fonts["font_Arial_green"]				= {fontdescription["font_Arial"], 10, materials["green"]}
fonts["font_Arial_cyan"]				= {fontdescription["font_Arial"], 10, materials["cyan"]}
fonts["font_Bold_Arial_green"]				= {fontdescription["Hercules_TPOD_font"], 10, materials["green"]}
fonts["font_Bold_Arial_cyan"]				= {fontdescription["Hercules_TPOD_font"], 10, materials["cyan"]}
fonts["font_Arial_green_background"]				= {fontdescription["font_Arial_background"], 10, materials["green"]}
fonts["font_Arial_amber"]				= {fontdescription["font_Arial"], 10, materials["amber"]}
fonts["font_Arial_red"]					= {fontdescription["font_Arial"], 10, materials["red"]}
fonts["font_Arial_black"]					= {fontdescription["font_Arial"], 10, materials["black"]}


textures["BFI_Back"]			= {LockOn_Options.script_path.."BFI/Resources/a29b_BFI_Back.png", materials["white"]}
textures["BFI_Background"]		= {LockOn_Options.script_path.."BFI/Resources/a29b_BFI_Background.png", materials["white"]}
textures["BFI_Bank"]			= {LockOn_Options.script_path.."BFI/Resources/a29b_BFI_Bank.png", materials["white"]}
textures["BFI_Horizon"]			= {LockOn_Options.script_path.."BFI/Resources/a29b_BFI_Horizon.bmp", materials["white"]}
textures["BFI_Ias"]				= {LockOn_Options.script_path.."BFI/Resources/a29b_BFI_Ias.bmp", materials["white"]}
textures["BFI_Base"]			= {nil, materials["white"]}

preload_texture={
	LockOn_Options.script_path.."/BFI/Resources/a29b_BFI_Back.png",
	LockOn_Options.script_path.."/BFI/Resources/a29b_BFI_Background.png",
		LockOn_Options.script_path.."/BFI/Resources/a29b_BFI_Bank.png",
		LockOn_Options.script_path.."/BFI/Resources/a29b_BFI_Horizon.bmp",
		LockOn_Options.script_path.."/HDD/Resources/a29b_BFI_Ias.bmp",
		-- LockOn_Options.script_path.."/CMFD/Resources/a29b_font_CMFD.dds",
	}


dofile(LockOn_Options.script_path .. "CMFD/materials.lua")
dofile(LockOn_Options.script_path .. "HUD/materials.lua")
dofile(LockOn_Options.script_path .. "UFCP/materials.lua")


-- symbologyPaths =    {	LockOn_Options.script_path.."HUD/Resources",
--                     }
