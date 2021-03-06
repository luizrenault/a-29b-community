
IND_TEX_PATH = LockOn_Options.script_path .. "CMFD/Resources/"
	-- CMFDs
-- -- COMMON
-- materials["IND_COMMON_RED"]      = {255,   0,   0, 255}
-- materials["DBG_GREY"]            = { 25,  25,  25, 255}
-- materials["DBG_BLACK"]           = {  0,   0,   0, 100}
-- materials["DBG_RED"]             = {255,   0,   0, 100}
-- materials["DBG_GREEN"]           = {  0, 255,   0, 100}
-- materials["BLACK"]               = {  0,   0,   0, 255}
-- materials["SIMPLE_WHITE"]        = {255, 255, 255, 255}
-- materials["PURPLE"]              = {255,   0, 255, 255}

-- -- HUD
-- materials["HUD_IND_DEF"]         = {  0, 255,   0, 255}
-- materials["HUD_IND_CLIP"]        = {  0, 255,   0,   4}
-- materials["HUD_IND_RED"]         = {255,   0,   0, 255}
-- materials["HUD_IND_GREEN"]       = {  0, 255,   0, 255}
-- materials["HUD_IND_BLUE"]        = {  0,   0, 255, 255}
-- materials["HUD_IND_WHITE"]       = {255, 255, 255, 255}
-- materials["HUD_IND_YELLOW"]      = {255, 255,   0, 240}
-- materials["HUD_IND_DARK"]        = {  0,   0,   0, 255}
-- materials["HUD_IND_HIDE"]        = {  0,   0,   0,   0}

-- materials["HUD_IND_BASE1"]       = {  0, 255,   0,   4}
-- materials["HUD_IND_BASE2"]       = {255, 255,   0,   4}

-- CMFDs
materials["CMFD_IND_DEF"]        = {  0, 255,   0, 240}
materials["CMFD_IND_RED"]        = {255,   0,   0, 240}
materials["CMFD_IND_GREEN"]      = {  0, 255,   0, 150}
materials["CMFD_IND_DGREEN"]     = {  3,  67,  40, 240}
materials["CMFD_IND_BLUE"]       = {  0,   0, 255, 240}
materials["CMFD_IND_CYAN"]       = {  0,   178, 255, 255}
materials["CMFD_IND_BLUE_L"]     = { 70, 130, 180, 255}
materials["CMFD_IND_BLACK"]      = {  0,   0,   0, 255}
materials["CMFD_IND_DARK"]       = {  0,   0,   0, 128}
materials["CMFD_IND_WHITE"]      = {255, 255, 255, 255}
materials["CMFD_IND_WHITE_Y"]    = {255, 255, 240, 240}
materials["CMFD_IND_PINK"]       = {160,  32, 240, 240}
materials["CMFD_IND_MAGENTA"]    = {255,  0, 255, 255}
materials["CMFD_IND_YELLOW"]     = {255, 255,   0, 240}
materials["CMFD_IND_SKY"]        = { 47, 135, 255, 255}
materials["CMFD_IND_GRND"]       = { 204,   91,   35, 255}
materials["CMFD_IND_BOXBASE"]    = {255, 255, 255,   0}
materials["CMFD_IND_W_BASE"]     = {255, 255, 255, 255}

-- -- UFCP
-- materials["UFCP_IND_DEF"]        = {192, 255,   0, 255}
-- materials["UFCP_IND_CURSOR"]     = {  0, 255,   0, 128}
-- materials["UFCP_IND_PAGEBASE"]   = {255,   0,   0,  50}

-- -- RADIO
-- materials["RADIO_IND_DEF"]       = {  0, 255,   0, 150}
-- materials["RADIO_IND_RED"]       = {255,   0,   0, 240}
-- materials["RADIO_IND_YELLOW"]    = {255, 255,   0, 240}

-- -- CLOCK
-- materials["CLOCK_IND_DEF"]       = {  0, 255,   0, 150}
-- materials["CLOCK_IND_RED"]       = {255,   0,   0, 240}
-- materials["CLOCK_IND_YELLOW"]    = {255, 255,   0, 240}

-- ------- TEXTURES -------
-- textures = {}

-- -- COMMON
-- textures["ARCADE"]               = {"arcade.tga", materials["IND_COMMON_RED"]}
-- textures["ARCADE_PUPRLE"]        = {"arcade.tga", materials["PURPLE"]}
-- textures["ARCADE_WHITE"]         = {"arcade.tga", materials["SIMPLE_WHITE"]}

-- -- HUD
-- textures["hud_tex_ind1"]         = {IND_TEX_PATH .. "Indication_HUD_1.dds", materials["HUD_IND_DEF"]}
-- textures["hud_tex_ind1_r"]       = {IND_TEX_PATH .. "Indication_HUD_1.dds", materials["HUD_IND_RED"]}
-- textures["hud_tex_ind1_y"]       = {IND_TEX_PATH .. "Indication_HUD_1.dds", materials["HUD_IND_YELLOW"]}

textures["hud_tex_ind2"]         = {nil, materials["HUD_IND_DEF"]}
textures["hud_tex_ind2_r"]       = {nil, materials["HUD_IND_RED"]}
textures["hud_tex_ind2_y"]       = {nil, materials["HUD_IND_YELLOW"]}

-- textures["hud_tex_clip"]         = {IND_TEX_PATH .. "Indication_HUD_clip.dds", materials["HUD_IND_CLIP"]}

-- textures["hud_mesh_def"]         = {nil, materials["HUD_IND_DEF"]}
-- textures["hud_mesh_base1"]       = {nil, materials["HUD_IND_BASE1"]}
-- textures["hud_mesh_base2"]       = {nil, materials["HUD_IND_BASE2"]}

-- textures["hud_line_dashed_def"]  = {IND_TEX_PATH .. "a29b_Indication_line_Dashed.dds", materials["HUD_IND_DEF"]}

-- -- UFCP
-- textures["ufcd_mesh_def"]        = {nil, materials["UFCP_IND_DEF"]}
-- textures["ufcd_mesh_cursor"]     = {nil, materials["UFCP_IND_CURSOR"]}
-- textures["ufcd_mesh_pagebase"]   = {nil, materials["UFCP_IND_PAGEBASE"]}

-- -- RADIO
-- textures["radio_mesh_def"]       = {nil, materials["RADIO_IND_DEF"]}
-- textures["radio_mesh_r"]         = {nil, materials["RADIO_IND_RED"]}
-- textures["radio_mesh_y"]         = {nil, materials["RADIO_IND_YELLOW"]}

-- -- Clock
-- textures["clock_mesh_def"]       = {nil, materials["CLOCK_IND_DEF"]}

-- -- CMFDs
textures["cmfd_tex_eicas"]        = {IND_TEX_PATH .. "a29b_cmfd.png", materials["CMFD_IND_WHITE"]}

-- textures["cmfd_tex_ind1"]        = {IND_TEX_PATH .. "Indication_CMFD_1.dds", materials["CMFD_IND_DEF"]}
-- textures["cmfd_tex_ind1_g"]      = {IND_TEX_PATH .. "Indication_CMFD_1.dds", materials["CMFD_IND_GREEN"]}
-- textures["cmfd_tex_ind1_w"]      = {IND_TEX_PATH .. "Indication_CMFD_1.dds", materials["CMFD_IND_WHITE"]}
-- textures["cmfd_tex_ind1_wy"]     = {IND_TEX_PATH .. "Indication_CMFD_1.dds", materials["CMFD_IND_WHITE_Y"]}
-- textures["cmfd_tex_ind1_y"]      = {IND_TEX_PATH .. "Indication_CMFD_1.dds", materials["CMFD_IND_YELLOW"]}
-- textures["cmfd_tex_ind1_r"]      = {IND_TEX_PATH .. "Indication_CMFD_1.dds", materials["CMFD_IND_RED"]}

-- textures["cmfd_tex_ind2"]        = {IND_TEX_PATH .. "Indication_CMFD_2.dds", materials["CMFD_IND_DEF"]}
-- textures["cmfd_tex_ind2_g"]      = {IND_TEX_PATH .. "Indication_CMFD_2.dds", materials["CMFD_IND_GREEN"]}
-- textures["cmfd_tex_ind2_w"]      = {IND_TEX_PATH .. "Indication_CMFD_2.dds", materials["CMFD_IND_WHITE"]}
-- textures["cmfd_tex_ind2_wy"]     = {IND_TEX_PATH .. "Indication_CMFD_2.dds", materials["CMFD_IND_WHITE_Y"]}
-- textures["cmfd_tex_ind2_y"]      = {IND_TEX_PATH .. "Indication_CMFD_2.dds", materials["CMFD_IND_YELLOW"]}
-- textures["cmfd_tex_ind2_r"]      = {IND_TEX_PATH .. "Indication_CMFD_2.dds", materials["CMFD_IND_RED"]}

-- textures["cmfd_tex_ind3"]        = {IND_TEX_PATH .. "Indication_CMFD_3.dds", materials["CMFD_IND_DEF"]}
-- textures["cmfd_tex_ind3_g"]      = {IND_TEX_PATH .. "Indication_CMFD_3.dds", materials["CMFD_IND_GREEN"]}
-- textures["cmfd_tex_ind3_w"]      = {IND_TEX_PATH .. "Indication_CMFD_3.dds", materials["CMFD_IND_WHITE"]}
-- textures["cmfd_tex_ind3_wy"]     = {IND_TEX_PATH .. "Indication_CMFD_3.dds", materials["CMFD_IND_WHITE_Y"]}
-- textures["cmfd_tex_ind3_y"]      = {IND_TEX_PATH .. "Indication_CMFD_3.dds", materials["CMFD_IND_YELLOW"]}
-- textures["cmfd_tex_ind3_r"]      = {IND_TEX_PATH .. "Indication_CMFD_3.dds", materials["CMFD_IND_RED"]}
-- textures["cmfd_tex_ind3_bl"]     = {IND_TEX_PATH .. "Indication_CMFD_3.dds", materials["CMFD_IND_BLUE_L"]}

-- textures["cmfd_tex_ind4"]        = {IND_TEX_PATH .. "Indication_CMFD_4.dds", materials["CMFD_IND_DEF"]}
-- textures["cmfd_tex_ind4_g"]      = {IND_TEX_PATH .. "Indication_CMFD_4.dds", materials["CMFD_IND_GREEN"]}
-- textures["cmfd_tex_ind4_w"]      = {IND_TEX_PATH .. "Indication_CMFD_4.dds", materials["CMFD_IND_WHITE"]}
-- textures["cmfd_tex_ind4_wy"]     = {IND_TEX_PATH .. "Indication_CMFD_4.dds", materials["CMFD_IND_WHITE_Y"]}
-- textures["cmfd_tex_ind4_y"]      = {IND_TEX_PATH .. "Indication_CMFD_4.dds", materials["CMFD_IND_YELLOW"]}
-- textures["cmfd_tex_ind4_r"]      = {IND_TEX_PATH .. "Indication_CMFD_4.dds", materials["CMFD_IND_RED"]}

-- textures["cmfd_tex_ind5"]        = {IND_TEX_PATH .. "Indication_CMFD_5.dds", materials["CMFD_IND_DEF"]}
-- textures["cmfd_tex_ind5_g"]      = {IND_TEX_PATH .. "Indication_CMFD_5.dds", materials["CMFD_IND_GREEN"]}
-- textures["cmfd_tex_ind5_w"]      = {IND_TEX_PATH .. "Indication_CMFD_5.dds", materials["CMFD_IND_WHITE"]}
-- textures["cmfd_tex_ind5_wy"]     = {IND_TEX_PATH .. "Indication_CMFD_5.dds", materials["CMFD_IND_WHITE_Y"]}
-- textures["cmfd_tex_ind5_y"]      = {IND_TEX_PATH .. "Indication_CMFD_5.dds", materials["CMFD_IND_YELLOW"]}
-- textures["cmfd_tex_ind5_r"]      = {IND_TEX_PATH .. "Indication_CMFD_5.dds", materials["CMFD_IND_RED"]}

-- textures["cmfd_line_dashed_def"] = {IND_TEX_PATH .. "a29b_Indication_line_Dashed.dds", materials["CMFD_IND_DEF"]}
-- textures["cmfd_line_dashed_r"]   = {IND_TEX_PATH .. "a29b_Indication_line_Dashed.dds", materials["CMFD_IND_RED"]}
-- textures["cmfd_line_dashed_w"]   = {IND_TEX_PATH .. "a29b_Indication_line_Dashed.dds", materials["CMFD_IND_WHITE"]}
-- textures["cmfd_line_dashed_y"]   = {IND_TEX_PATH .. "a29b_Indication_line_Dashed.dds", materials["CMFD_IND_YELLOW"]}


textures["cmfd_mesh_def"]        = {nil, materials["CMFD_IND_DEF"]}
textures["cmfd_mesh_cyan"]        = {nil, materials["CMFD_IND_CYAN"]}
textures["cmfd_mesh_r"]          = {nil, materials["CMFD_IND_RED"]}
textures["cmfd_mesh_g"]          = {nil, materials["CMFD_IND_GREEN"]}
textures["cmfd_mesh_b"]          = {nil, materials["CMFD_IND_BLUE"]}
textures["cmfd_mesh_d"]          = {nil, materials["CMFD_IND_DARK"]}
textures["cmfd_mesh_w"]          = {nil, materials["CMFD_IND_WHITE"]}
textures["cmfd_mesh_wy"]         = {nil, materials["CMFD_IND_WHITE_Y"]} -- 略带淡黄色
textures["cmfd_mesh_p"]          = {nil, materials["CMFD_IND_PINK"]}
textures["cmfd_mesh_y"]          = {nil, materials["CMFD_IND_YELLOW"]}
textures["cmfd_mesh_sky"]        = {nil, materials["CMFD_IND_SKY"]}
textures["cmfd_mesh_gnd"]        = {nil, materials["CMFD_IND_GRND"]}
textures["cmfd_mesh_boxbase"]    = {nil, materials["CMFD_IND_BOXBASE"]}
textures["cmfd_mesh_whitebase"]  = {nil, materials["CMFD_IND_W_BASE"]}



-- ------- FONTS ----------

-- fonts = {}
-- -- GENERAL FONTS
-- --fonts["font_general_keys"]       = {fontdescription["font_general_loc"], 10, {255,75,75,255}}
-- --fonts["font_hints_kneeboard"]    = {fontdescription["font_general_loc"], 10, {100,0,100,255}}

-- -- HUD
-- fonts["hud_font_def"]   = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_DEF"]}
-- fonts["hud_font_g"]     = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_GREEN"]}
-- fonts["hud_font_b"]     = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_BLUE"]}
-- fonts["hud_font_w"]     = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_WHITE"]}
-- fonts["hud_font_r"]     = {fontdescription["a29b_font_hud"], 10, materials["HUD_IND_RED"]}

-- CMPDs
fonts["cmfd_font_def"]  = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_DEF"]}
fonts["cmfd_font_g"]    = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_GREEN"]}
fonts["cmfd_font_dg"]   = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_DGREEN"]}
fonts["cmfd_font_b"]    = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_BLUE"]}
fonts["cmfd_font_cyan"] = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_CYAN"]}
fonts["cmfd_font_magenta"] = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_MAGENTA"]}
fonts["cmfd_font_w"]    = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_WHITE"]}
fonts["cmfd_font_k"]    = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_BLACK"]}
fonts["cmfd_font_wy"]   = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_WHITE_Y"]}
fonts["cmfd_font_d"]    = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_DARK"]}
fonts["cmfd_font_r"]    = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_RED"]}
fonts["cmfd_font_y"]    = {fontdescription["font_CMFD"], 10, materials["CMFD_IND_YELLOW"]}

-- fonts["cmfd_font_stroke_def"]  = {fontdescription["font_CMFD_stroke"], 10, materials["CMFD_IND_DEF"]}
-- fonts["cmfd_font_stroke_g"]    = {fontdescription["font_CMFD_stroke"], 10, materials["CMFD_IND_GREEN"]}
-- fonts["cmfd_font_stroke_dg"]   = {fontdescription["font_CMFD_stroke"], 10, materials["CMFD_IND_DGREEN"]}
-- fonts["cmfd_font_stroke_b"]    = {fontdescription["font_CMFD_stroke"], 10, materials["CMFD_IND_BLUE"]}
-- fonts["cmfd_font_stroke_w"]    = {fontdescription["font_CMFD_stroke"], 10, materials["CMFD_IND_WHITE"]}
-- fonts["cmfd_font_stroke_wy"]   = {fontdescription["font_CMFD_stroke"], 10, materials["CMFD_IND_WHITE_Y"]}
-- fonts["cmfd_font_stroke_d"]    = {fontdescription["font_CMFD_stroke"], 10, materials["CMFD_IND_DARK"]}
-- fonts["cmfd_font_stroke_r"]    = {fontdescription["font_CMFD_stroke"], 10, materials["CMFD_IND_RED"]}


-- fonts["cmfd_wpn_font_def"]  = {fontdescription["font_CMFD_wpn"], 10, materials["CMFD_IND_DEF"]}
-- fonts["cmfd_wpn_font_g"]    = {fontdescription["font_CMFD_wpn"], 10, materials["CMFD_IND_GREEN"]}
-- fonts["cmfd_wpn_font_dg"]   = {fontdescription["font_CMFD_wpn"], 10, materials["CMFD_IND_DGREEN"]}
-- fonts["cmfd_wpn_font_b"]    = {fontdescription["font_CMFD_wpn"], 10, materials["CMFD_IND_BLUE"]}
-- fonts["cmfd_wpn_font_w"]    = {fontdescription["font_CMFD_wpn"], 10, materials["CMFD_IND_WHITE"]}
-- fonts["cmfd_wpn_font_wy"]   = {fontdescription["font_CMFD_wpn"], 10, materials["CMFD_IND_WHITE_Y"]}
-- fonts["cmfd_wpn_font_d"]    = {fontdescription["font_CMFD_wpn"], 10, materials["CMFD_IND_DARK"]}
-- fonts["cmfd_wpn_font_r"]    = {fontdescription["font_CMFD_wpn"], 10, materials["CMFD_IND_RED"]}

-- -- test
-- --fonts["cmfd_wpn_svg_font_def"]  = {fontdescription["font_CMFD_wpn_svg"], 10, materials["CMFD_IND_DEF"]}

-- -- UFC
-- fonts["ufcp_font_def"]     = {fontdescription["font_UFCP"], 10, materials["UFCP_IND_DEF"]}
-- fonts["ufcp_font_cursor"]  = {fontdescription["font_UFCP"], 10, materials["UFCP_IND_CURSOR"]}

-- -- Radio Panel
-- fonts["radio_font_def"]     = {fontdescription["font_RADIO"], 10, materials["RADIO_IND_DEF"]}
-- fonts["radio_font_y"]       = {fontdescription["font_RADIO"], 10, materials["RADIO_IND_YELLOW"]}
-- fonts["radio_font_cursor"]  = {fontdescription["font_RADIO"], 10, materials["RADIO_IND_DEF"]}

-- -- Clock
-- fonts["clock_font_def"]     = {fontdescription["font_CLOCK"], 10, materials["CLOCK_IND_DEF"]}

