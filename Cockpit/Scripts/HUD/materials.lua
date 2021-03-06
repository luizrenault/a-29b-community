
IND_TEX_PATH = LockOn_Options.script_path .. "HUD/Resources/"
-- -- COMMON
-- materials["IND_COMMON_RED"]      = {255,   0,   0, 255}
-- materials["DBG_GREY"]            = { 25,  25,  25, 255}
-- materials["DBG_BLACK"]           = {  0,   0,   0, 100}
-- materials["DBG_RED"]             = {255,   0,   0, 100}
-- materials["DBG_GREEN"]           = {  0, 255,   0, 100}
-- materials["BLACK"]               = {  0,   0,   0, 255}
-- materials["SIMPLE_WHITE"]        = {255, 255, 255, 255}
-- materials["PURPLE"]              = {255,   0, 255, 255}

-- HUD
materials["HUD_IND_DEF"]         = {  0, 255,   0, 255}
materials["HUD_IND_CLIP"]        = {  0, 255,   0,   4}
materials["HUD_IND_RED"]         = {255,   0,   0, 255}
materials["HUD_IND_GREEN"]       = {  0, 255,   0, 255}
materials["HUD_IND_BLUE"]        = {  0,   0, 255, 255}
materials["HUD_IND_WHITE"]       = {255, 255, 255, 255}
materials["HUD_IND_YELLOW"]      = {255, 255,   0, 240}
materials["HUD_IND_DARK"]        = {  0,   0,   0, 255}
materials["HUD_IND_HIDE"]        = {  0,   0,   0,   0}

materials["HUD_IND_BASE1"]       = {  0, 255,   0,   4}
materials["HUD_IND_BASE2"]       = {255, 255,   0,   4}


-- ------- TEXTURES -------
-- textures = {}

-- -- COMMON
-- textures["ARCADE"]               = {"arcade.tga", materials["IND_COMMON_RED"]}
-- textures["ARCADE_PUPRLE"]        = {"arcade.tga", materials["PURPLE"]}
-- textures["ARCADE_WHITE"]         = {"arcade.tga", materials["SIMPLE_WHITE"]}

-- HUD
textures["hud_tex_ind1"]         = {IND_TEX_PATH .. "Indication_HUD_1.dds", materials["HUD_IND_DEF"]}
textures["hud_tex_ind1_r"]       = {IND_TEX_PATH .. "Indication_HUD_1.dds", materials["HUD_IND_RED"]}
textures["hud_tex_ind1_y"]       = {IND_TEX_PATH .. "Indication_HUD_1.dds", materials["HUD_IND_YELLOW"]}

textures["hud_tex_ind2"]         = {nil, materials["HUD_IND_DEF"]}
textures["hud_tex_ind2_r"]       = {nil, materials["HUD_IND_RED"]}
textures["hud_tex_ind2_y"]       = {nil, materials["HUD_IND_YELLOW"]}

textures["hud_tex_clip"]         = {IND_TEX_PATH .. "Indication_HUD_clip.dds", materials["HUD_IND_CLIP"]}

textures["hud_mesh_def"]         = {nil, materials["HUD_IND_DEF"]}
textures["hud_mesh_base1"]       = {nil, materials["HUD_IND_BASE1"]}
textures["hud_mesh_base2"]       = {nil, materials["HUD_IND_BASE2"]}

textures["hud_line_dashed_def"]  = {IND_TEX_PATH .. "a29b_Indication_line_Dashed.dds", materials["HUD_IND_DEF"]}


-- ------- FONTS ----------

-- fonts = {}
-- -- GENERAL FONTS
-- --fonts["font_general_keys"]       = {fontdescription["font_general_loc"], 10, {255,75,75,255}}
-- --fonts["font_hints_kneeboard"]    = {fontdescription["font_general_loc"], 10, {100,0,100,255}}

-- HUD
fonts["hud_font_def"]   = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_DEF"]}
fonts["hud_font_g"]     = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_GREEN"]}
fonts["hud_font_b"]     = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_BLUE"]}
fonts["hud_font_w"]     = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_WHITE"]}
fonts["hud_font_r"]     = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_RED"]}


dbg_drawStrokesAsWire = false

materials["HUD"]						= {2, 255, 20, 385}
materials["FONT_DED"]					= {121, 255, 19, 255}	-- {251, 220, 0, 255}
materials["FONT_PFLD"]					= {121, 255, 19, 255}	-- {251, 220, 0, 255}
materials["MASK_MATERIAL_PURPLE"]		= {255, 0, 255, 30}


materials["INDICATION_COMMON_RED"]		= {255, 0, 0, 255}
materials["INDICATION_COMMON_WHITE"]	= {255, 255, 255, 255}
materials["INDICATION_COMMON_GREEN"]	= {0, 255, 0, 255}
materials["INDICATION_COMMON_LBLUE"]	= {0, 200, 255, 255}
materials["INDICATION_COMMON_AMBER"]	= {255,161,45,255}
materials["MASK_MATERIAL"]				= {255, 0, 255, 50}

materials["DBG_RED"]					= {255, 0, 0, 100}
materials["DBG_GREEN"]					= {0, 255, 0, 100}

materials["HUD"]						= {2, 255, 20, 385}
materials["FONT_DED"]					= {121, 255, 19, 255}	-- {251, 220, 0, 255}
materials["FONT_PFLD"]					= {121, 255, 19, 255}	-- {251, 220, 0, 255}
materials["MASK_MATERIAL_PURPLE"]		= {255, 0, 255, 30}

materials["MFD_BACKGROUND"]				= {0, 0, 0, 255}
materials["MFD_FONT_BKGND_WHITE"]		= {255, 255, 255, 255}

materials["LMFD_MATERIAL"]				= {255, 255, 255, 255}			-- Default color for all MFDs
materials["RMFD_MATERIAL"]				= materials["LMFD_MATERIAL"]	-- Default color for all MFDs
materials["MFD_BLACK"]					= {0, 0, 0, 255}

materials["TGP_STBY_BLACK"]				= {0, 0, 0, 255}
materials["TGP_STBY_DGRAY"]				= {5, 5, 5, 255}

local HUD_mat = materials["HUD"]
materials["HUD_GREEN_FOV"]				= {HUD_mat[0], HUD_mat[1], HUD_mat[2], 100} -- used for FOV lens render

materials["UHF_RADIO"]					= {179, 198, 85, 255}
materials["UHF_RADIO_CHANNEL_MAP"]		= {0, 0, 0, 250}

materials["EHSI_BACKGROUND"]			= {0, 0, 0, 255}
materials["EHSI_BLACK"]					= {0, 0, 0, 255}
materials["EHSI_WHITE"]					= {255, 255, 255, 255}
materials["EHSI_GRAY"]					= {200, 200, 200, 255}
materials["EHSI_RED"]					= {255,   0,   0, 255}
materials["EHSI_BLUE"]					= { 23, 140, 255, 255}
materials["EHSI_YELLOW"]				= {255, 255, 100, 255}
materials["EHSI_GOLD"]					= {255, 250, 173, 255}
materials["RWR_STROKE"]					= {0, 255, 0, 230}
materials["CMDS_GREEN"]					= {0, 255, 0, 255}
-- HMD
materials["HMD_SYMBOLOGY_MATERIAL"]		= {2, 255, 20, 255}


-------TEXTURES-------

local ResourcesPath = LockOn_Options.script_path.."HUD/Resources/"

-- textures["ARCADE"]							= {"arcade.tga",	materials["INDICATION_COMMON_RED"]}			-- Control Indicator
-- textures["ARCADE_WHITE"]					= {"arcade.tga",	materials["INDICATION_COMMON_WHITE"]}		-- Control Indicator

-- textures["INDICATION_RWR"]					= {ResourcesPath.."RWR/indication_RWR.tga", materials["INDICATION_COMMON_GREEN"]}
-- textures["INDICATION_RWR_LINE"]				= {"arcade.tga",							materials["INDICATION_COMMON_GREEN"]}
-- textures["INDICATION_TGP"]					= {ResourcesPath.."Displays/tgp_texture.tga",	materials["INDICATION_COMMON_WHITE"]}

-- textures["DED_BIG_OFF"]						= {ResourcesPath.."Displays/ded_font_big.dds",	materials["FONT_DED"]}

-------FONTS----------

fonts["font_stroke_HUD"]			= {fontdescription["font_stroke_HUD"], 10, materials["HUD"]}
fonts["font_stroke_HUD_R"]			= {fontdescription["font_stroke_HUD"], 10, {255, 0, 0, 255}}

fonts["font_DED"]					= {fontdescription["font_DED"], 10, materials["FONT_DED"]}
fonts["font_DED_inv"]				= {fontdescription["font_DED_inv"], 10, materials["FONT_DED"]}

fonts["font_PFLD"]					= {fontdescription["font_PFLD"], 10, materials["FONT_PFLD"]}
fonts["font_PFLD_inv"]				= {fontdescription["font_PFLD_inv"], 10, materials["FONT_PFLD"]}

fonts["font_stroke_LMFD"]			= {fontdescription["font_stroke_MFD"], 10, materials["LMFD_MATERIAL"]}
fonts["font_stroke_RMFD"]			= {fontdescription["font_stroke_MFD"], 10, materials["RMFD_MATERIAL"]}
fonts["font_stroke_MFD_Black"]		= {fontdescription["font_stroke_MFD_Wide"], 10, materials["MFD_BLACK"]}
fonts["font_TGP"]					= {fontdescription["font_TGP"], 10, materials["INDICATION_COMMON_WHITE"]}

fonts["font_UHF_RADIO"]				= {fontdescription["font_UHF_RADIO"], 10, materials["UHF_RADIO"]}
fonts["font_UHF_RADIO_CH_MAP"]		= {fontdescription["font_UHF_RADIO"], 10, materials["UHF_RADIO_CHANNEL_MAP"]}

fonts["font_stroke_EHSI"]			= {fontdescription["font_stroke_EHSI"], 10, materials["EHSI_WHITE"]}
fonts["font_stroke_EHSI_BLACK"]		= {fontdescription["font_stroke_EHSI"], 10, materials["EHSI_BLACK"]}

--fonts["font_RWR"]					= {fontdescription["font_stroke_RWR"], 10, materials["RWR_STROKE"]}
fonts["font_RWR"]					= {fontdescription["font_RWR"], 10, materials["RWR_STROKE"]}
fonts["font_CMDS"]					= {fontdescription["font_CMDS"], 10, materials["CMDS_GREEN"]}

-- HMD
fonts["font_HMD"]					= {fontdescription["font_stroke_HMD"], 10, materials["HMD_SYMBOLOGY_MATERIAL"]}

fonts["font_general_keys"]			= {fontdescription["font_general_loc"], 10, materials["INDICATION_COMMON_RED"]}
fonts["font_hints_kneeboard"]		= {fontdescription["font_general_loc"], 10, {100,0,100,255}}

-- path for stroke symbology
symbologyPaths =    {	LockOn_Options.script_path.."HUD/Resources",}

