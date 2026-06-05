dofile(LockOn_Options.script_path .. "HUD/Indicator/HUD_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "HUD/HUD_ID_defs.lua")
dofile(LockOn_Options.script_path .. "Systems/avionics_api.lua")
dofile(LockOn_Options.script_path .. "Systems/weapon_system_api.lua")

DEFAULT_LEVEL = 9
default_material = HUD_TEX_IND2
default_parent = page_root_name
additive_alpha		= true
collimated			= true
default_element_params={"HUD_BRIGHT"}
default_controllers={{"opacity_using_parameter", 0}}

stroke_font			= "font_stroke_HUD"
stroke_material		= default_material
stroke_thickness  = 1 --0.25
stroke_fuzziness  = 0.6

xScale = GetScale() * math.sqrt(GetAspect()) * 1000
yScale = GetScale() * 1000

local lclScale = GetScale()

glyphHeight_100			= 7.0
glyphWidth_100			= 4.0
fontScaleY_100			= glyphHeight_100 * lclScale
fontScaleX_100			= glyphWidth_100 * lclScale
fontIntercharDflt_100	= 2.0
fontInterlineDflt_100	= 2.0
fontIntercharScale_100	= fontIntercharDflt_100 * lclScale
fontInterlineScale_100	= fontInterlineDflt_100 * lclScale

glyphHeight_75			= 6.0
glyphWidth_75			= 3.0
fontScaleY_75			= glyphHeight_75 * lclScale
fontScaleX_75			= glyphWidth_75 * lclScale
fontIntercharDflt_75	= 1.5
fontInterlineDflt_75	= 2.0
fontIntercharScale_75	= fontIntercharDflt_75 * lclScale
fontInterlineScale_75	= fontInterlineDflt_75 * lclScale

glyphHeight_120			= 8.0
glyphWidth_120			= 4.0
fontScaleY_120			= glyphHeight_120 * lclScale
fontScaleX_120			= glyphWidth_120 * lclScale
fontIntercharDflt_120	= 2.0
fontInterlineDflt_120	= 2.0
fontIntercharScale_120	= fontIntercharDflt_120 * lclScale
fontInterlineScale_120	= fontInterlineDflt_120 * lclScale

glyphHeight_60			= 5.0
glyphWidth_60			= 3.0
fontScaleY_60			= glyphHeight_60 * lclScale
fontScaleX_60			= glyphWidth_60 * lclScale
fontIntercharDflt_60	= 1.5
fontInterlineDflt_60	= 2.0
fontIntercharScale_60	= fontIntercharDflt_60 * lclScale
fontInterlineScale_60	= fontInterlineDflt_60 * lclScale


STROKE_FNT_DFLT_100			= #stringdefs+1
STROKE_FNT_DFLT_100_NARROW	= #stringdefs+2
STROKE_FNT_DFLT_75			= #stringdefs+3
STROKE_FNT_DFLT_120			= #stringdefs+4

stringdefs[STROKE_FNT_DFLT_100]			= {fontScaleY_100, fontScaleX_100, fontIntercharScale_100, fontInterlineScale_100}
stringdefs[STROKE_FNT_DFLT_100_NARROW]	= {fontScaleY_100, fontScaleX_100, fontIntercharScale_75,  fontInterlineScale_100}
stringdefs[STROKE_FNT_DFLT_75]			= {fontScaleY_75,  fontScaleX_75,  fontIntercharScale_75,  fontInterlineScale_75}
stringdefs[STROKE_FNT_DFLT_120]			= {fontScaleY_120, fontScaleX_120, fontIntercharScale_120, fontInterlineScale_120}


-- base                      = CreateElement "ceMeshPoly"
-- base.name                 = "HUD_Center"
-- base.primitivetype        = "triangles"
-- base.init_pos             = {0, 0, 0.0}
-- base.material             = HUD_MAT_BASE1
-- base.vertices             ={{math.rad(-7.6)*1000, math.rad(5.5)*1000}, {math.rad(7.6)*1000,math.rad(5.5)*1000}, {math.rad(7.6)*1000,math.rad(-11.5)*1000}, {math.rad(-7.6)*1000,math.rad(-11.5)*1000},}
-- base.indices              = default_box_indices
-- base.isvisible            = true
-- base.scale=0.5
-- AddElementObject(base)

create_page_root()

local grid
grid                      = CreateElement "ceMeshPoly"
grid.primitivetype        = "lines"
grid.init_pos             = {0, 0, 0.0}
grid.material             = HUD_TEX_IND2
grid.vertices             ={{math.rad(-7.6)*1000, math.rad(5.5)*1000}, {math.rad(7.6)*1000,math.rad(5.5)*1000}, {math.rad(7.6)*1000,math.rad(-11.5)*1000}, {math.rad(-7.6)*1000,math.rad(-11.5)*1000},}
grid.indices              = {0,1, 1,2, 2,3, 3,0}
grid.isvisible            = true
-- AddElementObject(grid)
grid = nil

grid                      = CreateElement "ceMeshPoly"
grid.primitivetype        = "lines"
grid.init_pos             = {0, 0, 0.0}
grid.material             = HUD_TEX_IND2
grid.vertices             = {
                                {math.rad(-7.6)*1000, math.rad(1.2)*1000}, {math.rad(7.6)*1000,math.rad(1.2)*1000},
                                {0, math.rad(5.5)*1000}, {0,math.rad(-11.5)*1000},
                                {math.rad(-7.6)*1000, math.rad(-3.7)*1000}, {math.rad(7.6)*1000,math.rad(-3.7)*1000},
                                {math.rad(-7.6)*1000, 0}, {math.rad(7.6)*1000,0},
                            }
grid.indices              = {0,1, 2,3, 4,5, 6,7}
grid.isvisible            = true
-- AddElementObject(grid)
grid = nil

-- HUD boresight cross


-- print_message_to_user("Scale: ".. tostring(GetScale()))

-- SetCustomScale(0.8*GetScale())

boresightShiftY = 98		--DegToMil(4.8)

local object


local HUD_BoresightRoot = addStrokeSymbol("HUD_Boresight_Cross", {"a29b_stroke_symbols_HUD", "1-boresight-cross"}, "CenterCenter", {0, DegToMil(1.2)})

-- FYT
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "aim9lm-caged"}, "CenterCenter", {0, 0})
object.element_params = {"HUD_BRIGHT", "HUD_FYT_HIDE", "CMFD_NAV_FYT_VALID", "HUD_FYT_AZIMUTH", "HUD_FYT_ELEVATION"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number", 1, 0},
	{"parameter_compare_with_number",2,1},
	{"move_left_right_using_parameter", 3, xScale},
	{"move_up_down_using_parameter", 4, yScale},
}
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
object.element_params = {"HUD_BRIGHT", "HUD_FYT_OS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}

-- OAP
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "8-oap"}, "CenterCenter", {0, 0})
object.element_params = {"HUD_BRIGHT", "HUD_OAP_HIDE", "CMFD_NAV_FYT_VALID", "HUD_OAP_AZIMUTH", "HUD_OAP_ELEVATION"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number",1,0},
	{"parameter_compare_with_number",2,1},
	{"move_left_right_using_parameter", 3, xScale},
	{"move_up_down_using_parameter", 4, yScale},
}

object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
object.element_params = {"HUD_BRIGHT", "HUD_OAP_OS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}


-- CCRP
local HUD_CCRP_origin = addPlaceholder(nil, {0,0})
HUD_CCRP_origin.element_params = {"HUD_CCRP"}
HUD_CCRP_origin.controllers = {{"parameter_compare_with_number", 0, 1}}

-- TD Target Designator
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "5-target"}, "CenterCenter", {0, 0}, HUD_CCRP_origin.name)
object.element_params = {"HUD_BRIGHT", "HUD_TD_HIDE", "HUD_FYT_AZIMUTH", "HUD_FYT_ELEVATION", "HUD_CCIP_DELAYED"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number", 1, 0},
	{"move_left_right_using_parameter", 2, xScale},
	{"move_up_down_using_parameter", 3, yScale},
	{"parameter_compare_with_number", 4, 0},
}

object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
object.element_params = {"HUD_BRIGHT", "HUD_TD_OS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}

-- TLL Target Locator Line
object = addStrokeLine(nil, 30, {0,DegToMil(1.2)}, 0, HUD_CCRP_origin.name)
object.vertices = {{8, 0}, {40,0}}
object.element_params = {"HUD_BRIGHT", "HUD_TD_HIDE", "HUD_TD_ANGLE"}
object.controllers = {{"opacity_using_parameter", 0}, 
						{"parameter_compare_with_number",1,1},
						{"rotate_using_parameter", 2, 1}}

-- SL Steering Line
object = addStrokeLine(nil, 30, {0,0}, 0, HUD_CCRP_origin.name)
object.vertices = {{0, 200}, {0,-200}}
object.element_params = {"HUD_BRIGHT", "HUD_TD_HIDE", "HUD_SL_AZIMUTH", "HUD_ROLL"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number", 1, 0},
	{"move_left_right_using_parameter", 2, xScale},
	{"rotate_using_parameter", 3,1},
}
-- SI Solution Indicator
object = addStrokeLine(nil, 10, {0,0}, 0, object.name)
object.vertices = {{-5,0}, {5,0}}
object.element_params = {"HUD_BRIGHT", "HUD_SI_HIDE", "HUD_SI_ELEVATION"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number", 1, 0},
	{"move_up_down_using_parameter", 2, yScale},
}

-- Max Range Circle
object = addStrokeCircle(nil, 50, {0, 0}, HUD_CCRP_origin.name)
object.element_params = {"HUD_BRIGHT", "HUD_MAX_RANGE"}
object.controllers = { {"opacity_using_parameter", 0},  {"parameter_compare_with_number", 1, 1},}


-- CCIP Gun
local HUD_CCIP_GUN_origin = addPlaceholder(nil, {0,0})
HUD_CCIP_GUN_origin.element_params = {"AVIONICS_MASTER_MODE", "WPN_MASS"}
HUD_CCIP_GUN_origin.controllers = {
	{"parameter_in_range",0,AVIONICS_MASTER_MODE_ID.GUN-0.5, AVIONICS_MASTER_MODE_ID.GUN_R + 0.5},
	{"parameter_compare_with_number", 1, WPN_MASS_IDS.LIVE},
}
-- CCIP Gun cue
object = addStrokeCircle(nil, 16, {0,0}, HUD_CCIP_GUN_origin.name)
object.element_params = {"HUD_BRIGHT", "HUD_CCIP_PIPER_AZIMUTH", "HUD_CCIP_PIPER_ELEVATION"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"move_left_right_using_parameter", 1, xScale},
	{"move_up_down_using_parameter", 2, yScale},
}
object = addStrokeCircle(nil, 1, {0,0}, object.name)

-- CCIP Gun out of screen
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
object.element_params = {"HUD_BRIGHT", "HUD_CCIP_PIPER_HIDDEN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}

-- CCIP
local HUD_CCIP_origin = addPlaceholder(nil, {0,0})
HUD_CCIP_origin.element_params = {"AVIONICS_MASTER_MODE", "WPN_MASS", "WPN_SELECTED_WEAPON_TYPE"}
HUD_CCIP_origin.controllers = {
	{"parameter_in_range",0,AVIONICS_MASTER_MODE_ID.CCIP-0.5, AVIONICS_MASTER_MODE_ID.CCIP_R + 0.5},
	{"parameter_compare_with_number", 1, WPN_MASS_IDS.LIVE},
	{"parameter_in_range",2, WPN_WEAPON_TYPE_IDS.AG_WEAPON_BEG, WPN_WEAPON_TYPE_IDS.AG_WEAPON_END},
}

-- CCIP Rocket
local HUD_CCIP_ROCKET_origin = addPlaceholder(nil, {0,0}, HUD_CCIP_origin.name)
HUD_CCIP_ROCKET_origin.element_params = {"WPN_SELECTED_WEAPON_TYPE"}
HUD_CCIP_ROCKET_origin.controllers = {
	{"parameter_compare_with_number",0,WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_ROCKET},
}

-- CCIP Rocket cue
object = addStrokeCircle(nil, 12, {0,0}, HUD_CCIP_ROCKET_origin.name)
object.element_params = {"HUD_BRIGHT", "HUD_CCIP_PIPER_AZIMUTH", "HUD_CCIP_PIPER_ELEVATION"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"move_left_right_using_parameter", 1, xScale},
	{"move_up_down_using_parameter", 2, yScale},
}
object = addStrokeCircle(nil, 1, {0,0}, object.name)
object = addStrokeCircle(nil, 16, {0,0}, object.name)
object.controllers = {{"piper_range"}}
object.init_rot = {90}

local rocket_piper = object
object = addPlaceholder(nil, {0, 0}, rocket_piper.name)
object.init_rot = {-30-90}
object = addStrokeLine(nil, 6, {0, 16}, 0, object.name)
object = addPlaceholder(nil, {0, 0}, rocket_piper.name)
object.init_rot = {-180-90}
object = addStrokeLine(nil, 6, {0, 16}, 0, object.name)


-- CCIP out of screen
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
object.element_params = {"HUD_BRIGHT", "HUD_CCIP_PIPER_HIDDEN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}

-- CCIP Bomb
local HUD_CCIP_BOMB_origin = addPlaceholder(nil, {0,0}, HUD_CCIP_origin.name)
HUD_CCIP_BOMB_origin.element_params = {"WPN_SELECTED_WEAPON_TYPE", "HUD_CCIP_DELAYED"}
HUD_CCIP_BOMB_origin.controllers = {
	{"parameter_compare_with_number",0,WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB},
	{"parameter_compare_with_number",1,0},
}

-- CCIP Bomb cue
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "4-impact-point"}, "CenterCenter", {0, 0}, HUD_CCIP_BOMB_origin.name)
object.element_params = {"HUD_BRIGHT", "HUD_CCIP_PIPER_AZIMUTH", "HUD_CCIP_PIPER_ELEVATION"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"move_left_right_using_parameter", 1, xScale},
	{"move_up_down_using_parameter", 2, yScale},
}

-- CCIP out of screen
-- object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
-- object.element_params = {"HUD_BRIGHT", "HUD_CCIP_PIPER_HIDDEN"}
-- object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}


-- CCIP Bomb Line
object = addSimpleLine(nil, 10, {0,0}, 0, HUD_CCIP_BOMB_origin.name, nil, 0.5, 0.5, 0.5, false, HUD_MAT_DEF)
object.element_params = {"HUD_BRIGHT", "HUD_PIPER_LINE_A_X", "HUD_PIPER_LINE_A_Y", "HUD_PIPER_LINE_B_X", "HUD_PIPER_LINE_B_Y"}
object.controllers = {
	{"opacity_using_parameter", 0},
	{"line_object_set_point_using_parameters", 0, 1, 2, xScale, yScale},
	{"line_object_set_point_using_parameters", 1, 3, 4, xScale, yScale},
}

-- CCIP Delayed Indicator
object = addStrokeLine(nil, 10, {0,0}, 0, HUD_CCIP_BOMB_origin.name)
object.vertices = {{-5,0}, {5,0}}
object.element_params = {"HUD_BRIGHT", "HUD_CCIP_DELAYED_AZIMUTH", "HUD_CCIP_DELAYED_ELEVATION", "HUD_CCIP_PIPER_HIDDEN", "HUD_ROLL"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"move_left_right_using_parameter", 1, xScale},
	{"move_up_down_using_parameter", 2, yScale},
	{"parameter_compare_with_number", 3, 1},
	{"rotate_using_parameter", 4},
}


-- CCIP Delayed Target Designator
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "4-impact-point"}, "CenterCenter", {0, 0}, HUD_CCRP_origin.name)
object.element_params = {"HUD_BRIGHT", "HUD_TD_HIDE", "HUD_TD_AZIMUTH", "HUD_TD_ELEVATION", "HUD_CCIP_DELAYED"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number", 1, 0},
	{"move_left_right_using_parameter", 2, xScale},
	{"move_up_down_using_parameter", 3, yScale},
	{"parameter_compare_with_number", 4, 1},
}
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
object.element_params = {"HUD_BRIGHT", "HUD_TD_OS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}

-- INT
local HUD_INT_origin = addPlaceholder(nil, {0,0})
HUD_INT_origin.element_params = {"AVIONICS_MASTER_MODE", "WPN_MSL_CAGED"}
HUD_INT_origin.controllers = {
	{"parameter_in_range",0,AVIONICS_MASTER_MODE_ID.INT_B-0.5, AVIONICS_MASTER_MODE_ID.INT_L + 0.5},
	{"parameter_in_range", 1, -0.05, 1.05},
}

-- IR Caged
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "aim9lm-caged"}, "CenterCenter", {0, 0}, HUD_INT_origin.name)
object.element_params = {"HUD_BRIGHT", "WPN_MSL_CAGED"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number",1,1},
}

-- IR Uncaged
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "aim9lm-uncaged"}, "CenterCenter", {0, 0}, HUD_INT_origin.name)
object.element_params = {"HUD_BRIGHT", "WPN_MSL_CAGED", "HUD_IR_MISSILE_TARGET_AZIMUTH", "HUD_IR_MISSILE_TARGET_ELEVATION"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number",1,0},
	{"move_left_right_using_parameter", 2, xScale},
	{"move_up_down_using_parameter", 3, yScale},
}

-- IR out of screen
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
object.element_params = {"HUD_BRIGHT", "HUD_MSL_HIDDEN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}

-- MSL recticle
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "msl-recticle"}, "CenterCenter", {0, 0}, HUD_INT_origin.name)
object.element_params = {"HUD_BRIGHT"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
}

-- DGFT
local HUD_DGFT_origin = addPlaceholder(nil, {0,0}, HUD_BoresightRoot.name)
HUD_DGFT_origin.element_params = {"AVIONICS_MASTER_MODE"}
HUD_DGFT_origin.controllers = {
	{"parameter_in_range",0,AVIONICS_MASTER_MODE_ID.DGFT_B-0.5, AVIONICS_MASTER_MODE_ID.DGFT_L + 0.5},
}

-- IR Caged
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "aim9lm-caged"}, "CenterCenter", {0, 0}, HUD_DGFT_origin.name)
object.element_params = {"HUD_BRIGHT", "WPN_MSL_CAGED"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number",1,1},
}

-- IR Uncaged
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "aim9lm-uncaged"}, "CenterCenter", {0, -DegToMil(1.2)}, HUD_DGFT_origin.name)
object.element_params = {"HUD_BRIGHT", "WPN_MSL_CAGED", "HUD_IR_MISSILE_TARGET_AZIMUTH", "HUD_IR_MISSILE_TARGET_ELEVATION"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number",1,0},
	{"move_left_right_using_parameter", 2, xScale},
	{"move_up_down_using_parameter", 3, yScale},
}

-- IR out of screen
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, object.name)
object.element_params = {"HUD_BRIGHT", "HUD_MSL_HIDDEN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}

-- Piper
local HUD_Piper_origin = addPlaceholder(nil, {0,0}, HUD_DGFT_origin.name)
HUD_Piper_origin.element_params = {"HUD_PIPER_X", "HUD_PIPER_Y"}
HUD_Piper_origin.controllers = {
	{"move_left_right_using_parameter", 0, 1},
	{"move_up_down_using_parameter", 1, 1},
}


-- LCOS SSLC SNAP piper
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "4-impact-point"}, "CenterCenter", {0, 0}, HUD_Piper_origin.name)

-- LCOS SSLC SNAP out of screen
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, 0}, HUD_Piper_origin.name)
object.element_params = {"HUD_BRIGHT", "HUD_PIPER_HIDDEN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1}}

-- LCOS SSLC recticle
local HUD_DGFT_LCOS_object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "gun-recticle"}, "CenterCenter", {0, 0}, HUD_Piper_origin.name)
HUD_DGFT_LCOS_object.element_params = {"HUD_BRIGHT", "WPN_AA_SIGHT"}
HUD_DGFT_LCOS_object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_in_range", 1, WPN_AA_SIGHT_IDS.LCOS-0.05 , WPN_AA_SIGHT_IDS.SSLC+0.05}, 
}

-- LCOS Line #2
object = addSimpleLine(nil, 10, {0,0}, 0, HUD_DGFT_origin.name, nil, 0.5, 0.5, 0.5, false, HUD_MAT_DEF)
object.element_params = {"HUD_BRIGHT", "WPN_AA_SIGHT", "HUD_PIPER_LINE_A_X", "HUD_PIPER_LINE_A_Y"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number", 1, WPN_AA_SIGHT_IDS.LCOS}, 
	{"line_object_set_point_using_parameters", 1, 2, 3, 1, 1}, 
}

-- LCOS line #2
object = addSimpleLine(nil, 10, {0,0}, 0, HUD_DGFT_origin.name, nil, 0.5, 0.5, 0.5, false, HUD_MAT_DEF)
object.element_params = {"HUD_BRIGHT", "WPN_AA_SIGHT", "HUD_PIPER_LINE_B_X", "HUD_PIPER_LINE_B_Y", "HUD_PIPER_LINE_C_X", "HUD_PIPER_LINE_C_Y"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_compare_with_number", 1, WPN_AA_SIGHT_IDS.LCOS}, 
	{"line_object_set_point_using_parameters", 0, 2, 3, 1, 1}, 
	{"line_object_set_point_using_parameters", 1, 4, 5, 1, 1}, 
}


-- SNAP Line #1
local HUD_SNAP_LINE1_Object = addSimpleLine(nil, 10, {0,0}, 0, HUD_DGFT_origin.name, nil, 0.5, 0.5, 0.5, false, HUD_MAT_DEF)
HUD_SNAP_LINE1_Object.element_params = {"HUD_BRIGHT", "WPN_AA_SIGHT", "HUD_PIPER_LINE_A_X", "HUD_PIPER_LINE_A_Y"}
HUD_SNAP_LINE1_Object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_in_range", 1, WPN_AA_SIGHT_IDS.SSLC - 0.5, WPN_AA_SIGHT_IDS.SNAP + 0.05}, 
	{"line_object_set_point_using_parameters", 1, 2, 3, 1, 1}, 
}

-- SNAP Line #2
local HUD_SNAP_LINE2_Object = addSimpleLine(nil, 10, {0,0}, 0, HUD_SNAP_LINE1_Object.name, nil, 0.5, 0.5, 0.5, false, HUD_MAT_DEF)
HUD_SNAP_LINE2_Object.element_params = {"HUD_BRIGHT", "WPN_AA_SIGHT", "HUD_PIPER_LINE_A_X", "HUD_PIPER_LINE_A_Y", "HUD_PIPER_LINE_B_X", "HUD_PIPER_LINE_B_Y"}
HUD_SNAP_LINE2_Object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_in_range", 1, WPN_AA_SIGHT_IDS.SSLC - 0.5, WPN_AA_SIGHT_IDS.SNAP + 0.05}, 
	{"move_left_right_using_parameter", 2, 1},
	{"move_up_down_using_parameter", 3, 1},
	{"line_object_set_point_using_parameters", 1, 4, 5, 1, 1}, 
}
object = addStrokeLine(nil, 30, {-15, 0}, -90, HUD_SNAP_LINE2_Object.name)

-- SNAP Line #3
local HUD_SNAP_LINE3_Object = addSimpleLine(nil, 10, {0,0}, 0, HUD_SNAP_LINE2_Object.name, nil, 0.5, 0.5, 0.5, false, HUD_MAT_DEF)
HUD_SNAP_LINE3_Object.element_params = {"HUD_BRIGHT", "WPN_AA_SIGHT", "HUD_PIPER_LINE_B_X", "HUD_PIPER_LINE_B_Y", "HUD_PIPER_LINE_C_X", "HUD_PIPER_LINE_C_Y"}
HUD_SNAP_LINE3_Object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_in_range", 1, WPN_AA_SIGHT_IDS.SSLC - 0.5, WPN_AA_SIGHT_IDS.SNAP + 0.05}, 
	{"move_left_right_using_parameter", 2, 1},
	{"move_up_down_using_parameter", 3, 1},
	{"line_object_set_point_using_parameters", 1, 4, 5, 1, 1}, 
}
object = addStrokeLine(nil, 15, {-7.5, 0}, -90, HUD_SNAP_LINE3_Object.name)
object = addStrokeLine(nil, 10, {-5, 0}, -90, HUD_SNAP_LINE3_Object.name)
object.element_params = {"HUD_BRIGHT", "WPN_AA_SIGHT", "HUD_PIPER_LINE_C_X", "HUD_PIPER_LINE_C_Y"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"parameter_in_range", 1, WPN_AA_SIGHT_IDS.SSLC - 0.5, WPN_AA_SIGHT_IDS.SNAP + 0.05}, 
	{"move_left_right_using_parameter", 3, -1},
	{"move_up_down_using_parameter", 2, 1},
}


-- Flight Path Marker - FPM
local HUD_FPM_origin = addPlaceholder("HUD_FPM_origin", {0, 0})
HUD_FPM_origin.element_params = {"HUD_DCLT", "HUD_BRIGHT"}
HUD_FPM_origin.controllers = {{"parameter_compare_with_number",0,0}, {"opacity_using_parameter", 1}}


object = addStrokeSymbol("HUD_FPM", {"a29b_stroke_symbols_HUD", "2-flightpath-marker"}, "FromSet", {0, 0}, HUD_FPM_origin.name, {{"HUD_FPM_Flash"}})
object.element_params = {"HUD_FPM_SLIDE", "HUD_FPM_VERT", "UFCP_DRIFT_CO", "HUD_BRIGHT"}
object.controllers = {{"move_left_right_using_parameter", 0, xScale}, {"move_up_down_using_parameter", 1, yScale}, {"parameter_compare_with_number",2,0}, {"opacity_using_parameter", 3}}

object = addStrokeSymbol("HUD_FPM_CO", {"a29b_stroke_symbols_HUD", "2-flightpath-marker-co"}, "FromSet", {0, 0}, HUD_FPM_origin.name, {{"HUD_FPM_Flash"}})
object.element_params = {"HUD_FPM_VERT", "UFCP_DRIFT_CO", "HUD_BRIGHT"}
object.controllers = {{"move_up_down_using_parameter", 0, yScale}, {"parameter_compare_with_number",1,1}, {"opacity_using_parameter", 2}}

-- ILS
object = addStrokeSymbol("HUD_ILS_LOC", {"a29b_stroke_symbols_HUD", "ils-loc"}, "FromSet", {0, 0}, "HUD_FPM", {{"HUD_FPM_Flash"}})
object.element_params = {"NAV_ILS_LOC_DEV", "NAV_ILS_LOC_VALID", "HUD_BRIGHT", "AVIONICS_ANS_MODE", "AVIONICS_MASTER_MODE"}
object.controllers = {{"move_left_right_using_parameter", 0, 1}, {"parameter_compare_with_number",1,1}, {"opacity_using_parameter", 2}, {"parameter_compare_with_number",3,AVIONICS_ANS_MODE_IDS.ILS}, {"parameter_in_range", 4, AVIONICS_MASTER_MODE_ID.NAV - 0.05, AVIONICS_MASTER_MODE_ID.LANDING + 0.05}}

object = addStrokeSymbol("HUD_ILS_GS", {"a29b_stroke_symbols_HUD", "ils-loc"}, "FromSet", {0, 0}, "HUD_FPM", {{"HUD_FPM_Flash"}})
object.init_rot={-90};
object.element_params = {"NAV_ILS_GS_DEV", "NAV_ILS_GS_VALID", "HUD_BRIGHT", "AVIONICS_ANS_MODE", "AVIONICS_MASTER_MODE"}
object.controllers = {{"move_left_right_using_parameter", 0, 1}, {"parameter_compare_with_number",1,1}, {"opacity_using_parameter", 2}, {"parameter_compare_with_number",3,AVIONICS_ANS_MODE_IDS.ILS}, {"parameter_in_range", 4, AVIONICS_MASTER_MODE_ID.NAV - 0.05, AVIONICS_MASTER_MODE_ID.LANDING + 0.05}}

-- FPM cross
object = addStrokeSymbol("HUD_FPM_Cross", {"a29b_stroke_symbols_HUD", "fpm-cross"}, "FromSet", {0, 0}, "HUD_FPM", {{"HUD_FPM_Cross"}})
object.element_params = {"HUD_FPM_CROSS", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}

-- AoA bracket
object = addStrokeSymbol("HUD_AoA_bracket", {"a29b_stroke_symbols_HUD", "aoa-bracket"}, "FromSet", {0, 0}, "HUD_FPM", {{"HUD_AoA_bracket"}})
object.element_params = {"HUD_BRIGHT", "AVIONICS_MASTER_MODE", "BASE_SENSOR_WOW_LEFT_GEAR", "HUD_AOA_DELTA"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,AVIONICS_MASTER_MODE_ID.LANDING},  {"parameter_compare_with_number",2,0}, {"move_up_down_using_parameter", 3, DegToMil(1)/1000/2}}


-- -- Great steering circle cue "tadpole"
-- addStrokeSymbol("HUD_Tadpole", {"a29b_stroke_symbols_HUD", "3-great-steering-circle"}, "FromSet", nil, HUD_FPM_origin.name, {{"HUD_Tadpole_Pos", 50}})	-- 50 milradians for maximum offset

-- Pitch Ladder (PL)
local PL_origin = addPlaceholder("HUD_PL_origin", {0, 0}, HUD_FPM_origin.name, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_PitchLadder_Show"}, {"HUD_PitchLadder_PosRot"}})
PL_origin.element_params            = {"HUD_PITCH", "HUD_ROLL", "HUD_PL_SLIDE"}
PL_origin.controllers 		        = {{"move_left_right_using_parameter", 2, xScale}, {"rotate_using_parameter",1, 1 }, {"move_up_down_using_parameter",0,-yScale}, }

local PL_horizon_line_half_gap		= 16
local PL_long_horizon_line_width	= 70

local PL_pitch_line_half_gap		= 16
local PL_pitch_line_width			= 25
local PL_pitch_line_tick			= 4


-- long line - horizon
object = add_PL_line("PL_horizon_long_line", PL_long_horizon_line_width, PL_horizon_line_half_gap, 0, 0, 0, {{"HUD_PL_GhostHorizon", 0}}, PL_origin.name)
-- object.element_params = {"HUD_PITCH"}
-- object.controllers = {{"parameter_in_range",0,math.rad(-5), math.rad(5)}}

-- object = add_PL_GhostHorizon("PL_GhostHorizon_", PL_long_horizon_line_width, PL_horizon_line_half_gap, {{"HUD_PitchLadder_Show"}, {"HUD_PL_GhostHorizon", 1}}, {0, 0})
-- object.parent_element = PL_origin.name
-- object.element_params = {"HUD_PITCH"}
-- object.controllers = {{"parameter_in_range",0,-10, math.rad(-5)}}

object = add_PL_line("PL_horizon_25_line", PL_pitch_line_width*xScale, PL_pitch_line_half_gap, 0, DegToMil(-2.5), 0, nil, PL_origin.name)
object.element_params = {"AVIONICS_MASTER_MODE"}
object.controllers = {{"parameter_compare_with_number", 0, AVIONICS_MASTER_MODE_ID.LANDING}}

-- -80 to +80 degrees
local counterBegin = -80
local counterEnd   = -counterBegin
for i = counterBegin, counterEnd, 5 do
	local ang=math.abs(i)
	if i ~= 0 and ang ~= 65 and ang~= 75 then
		object = add_PL_line("PL_pitch_line_"..i, PL_pitch_line_width, PL_pitch_line_half_gap, PL_pitch_line_tick, DegToMil(i), i, {{"HUD_PitchLadder_Limit", DegToMil(10)}}, PL_origin.name)
		object.element_params = {"HUD_PL"}
		object.controllers = {{"parameter_compare_with_number", 0, 1}}
	end
end
addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "7-pup"}, "CenterCenter", {0, DegToMil(90)}, PL_origin.name)
addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "7-pup"}, "CenterCenter", {0, DegToMil(-90)}, PL_origin.name)
addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "fpm-cross"}, "CenterCenter", {0, DegToMil(-90)}, PL_origin.name,nil, 0.5)


-- Roll Indicator
local HUD_RI_origin	= addPlaceholder("HUD_RI_origin", {0, -60}, nil, {{"HUD_RI_Pos"}})
HUD_RI_origin.element_params = {"AVIONICS_MASTER_MODE", "HUD_BRIGHT"}
HUD_RI_origin.controllers = {{"parameter_compare_with_number", 0, AVIONICS_MASTER_MODE_ID.LANDING}, {"opacity_using_parameter", 1}}

local HUD_RI_origin_rot	= addPlaceholder("HUD_RI_origin_rot", {0, 0}, HUD_RI_origin.name)
HUD_RI_origin_rot.element_params = {"HUD_RI_ROLL"}
HUD_RI_origin_rot.controllers = {{"rotate_using_parameter", 0, 1}}
addRollIndicator(90, 8, 2, HUD_RI_origin.name)
addStrokeSymbol("HUD_Roll_Indicator_Caret", {"a29b_stroke_symbols_HUD", "11-roll-caret"}, "FromSet", {0, -94}, HUD_RI_origin_rot.name, {{"HUD_RI_Roll", -55}})

--
local HUD_Indication_bias = addPlaceholder("HUD_Indication_bias", {0, 0}, nil, {{"HUD_Indication_Bias"}})

-- Velocity numerics
local HUD_Vel_num_origin	= addPlaceholder("HUD_Vel_num_origin", {-93, 0}, HUD_Indication_bias.name)
HUD_Vel_num_origin.element_params = {"UFCP_VAH"}
HUD_Vel_num_origin.controllers = {{"parameter_compare_with_number",0,0}}

object = addStrokeText("HUD_Velocity_num", "520", STROKE_FNT_DFLT_100_NARROW, "RightCenter", {0, 0}, HUD_Vel_num_origin.name, {{"HUD_Velocity_Num"}}, {"%3.0f"})
object.element_params = {"HUD_IAS", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

addStrokeSymbol("HUD_Velocity_box", {"a29b_stroke_symbols_HUD", "9-velocity-box"}, "FromSet", {-9, 0}, HUD_Vel_num_origin.name)
addStrokeLine("HUD_VelNumLine", 10, {13, 0}, 90, HUD_Vel_num_origin.name)

-- Velocity scale
local velScale20KnotsStep		= 25
local velScaleLongTickLen		= 4
local velScaleShortTickLen		= 2
local Mil_PerOneKnots			= velScale20KnotsStep / 50

local HUD_VelScale_origin = addPlaceholder("HUD_VelScale_origin", {-90, 0}, HUD_Indication_bias.name, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_VelScaleOrigin"}})
HUD_VelScale_origin.element_params = {"UFCP_VAH", "HUD_BRIGHT"}
HUD_VelScale_origin.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}


local HUD_VelScale_originLong  = addPlaceholder("HUD_VelScale_originLong", {-velScaleShortTickLen, 0}, HUD_VelScale_origin.name, {{"HUD_VelScaleVerPos", 0, Mil_PerOneKnots}})
HUD_VelScale_originLong.element_params = {"HUD_VEL_SCALE_MOVE"}
HUD_VelScale_originLong.controllers = { {"move_up_down_using_parameter",0, -velScale20KnotsStep/20/1000*yScale}}

local HUD_VelScale_originShort = {}
for j = 1,4 do
	HUD_VelScale_originShort[j] = addPlaceholder("HUD_VelScale_originShort"..j, {0, 0}, HUD_VelScale_originLong.name, {{"HUD_VelScaleVerPos", 10 * j, Mil_PerOneKnots}})
end

for i = 1, 4 do
	local posY = velScale20KnotsStep * (i - 2.5)
	object = addStrokeLine("HUD_VelScaleTickLong_"..i, velScaleLongTickLen, {0, posY}, 90, HUD_VelScale_originLong.name, {{"HUD_VelScaleHide", i, 0}})
	object.element_params = {"HUD_BRIGHT", "HUD_VEL_SCALE_MOVE", "HUD_IAS"}
	if i == 1 then
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , 0.05}, {"parameter_in_range",2, 19.95 , 999}}
	elseif i==2 then
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",2, 19.95 , 999}}
	end
	for j = 1,3 do
		object = addStrokeLine("HUD_VelScaleTickShort_"..j..i, velScaleShortTickLen, {0, posY + j*velScale20KnotsStep/4}, 90, HUD_VelScale_originShort[j].name, {{"HUD_VelScaleHide", i, j}})
		object.element_params = {"HUD_BRIGHT", "HUD_VEL_SCALE_MOVE", "HUD_IAS"}
		if i == 1 then
			object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , (j)*5+0.05}, {"parameter_in_range",2, 19.95 , 999}}
		elseif i == 2 then
			object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",2, 19.95 , 999}}
		elseif i == 4 then
			object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1,j*5-0.05, 20.05}}
		end
	end
	object = addStrokeText("HUD_VelScaleNumerics_"..i, tostring(i), STROKE_FNT_DFLT_100_NARROW, "RightCenter", {-velScaleLongTickLen - 1, posY}, HUD_VelScale_originLong.name, {{"HUD_VelScaleText", i}}, {"%02.0f"})
	object.element_params = {"HUD_BRIGHT", "HUD_VEL_SCALE_MOVE", "HUD_VEL_SCALE_NUM_"..i, "HUD_IAS"}
	if i == 1 then
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , 0.05}, {"text_using_parameter",2,0}, {"parameter_in_range",3, 19.95 , 999}}
	elseif i == 2 then
		object.controllers = { {"opacity_using_parameter", 0}, {"text_using_parameter",2,0}, {"parameter_in_range",3, 19.95 , 999}}
	else 
		object.controllers = { {"opacity_using_parameter", 0}, {"text_using_parameter",2,0}}
	end
end

local HUD_Velocity_CueOrigin = addPlaceholder("HUD_Velocity_CueOrigin", {0,0}, HUD_VelScale_origin.name)
HUD_Velocity_CueOrigin.element_params = {"HUD_VEL_CUE_MOVE", "HUD_VEL_CUE_VALUE"}
HUD_Velocity_CueOrigin.controllers = {{"move_up_down_using_parameter",0, velScale20KnotsStep/20/1000*yScale}, {"parameter_in_range", 1, 0, 999}}
object = addStrokeSymbol("HUD_Velocity_Cue", {"a29b_stroke_symbols_HUD", "AA-DLZ-range"}, "RightCenter", {0, 0}, HUD_Velocity_CueOrigin.name)
object.init_rot = {180}
object = addStrokeText("HUD_VelCueNumerics", 0, STROKE_FNT_DFLT_100_NARROW, "LeftCenter", {7,0}, HUD_Velocity_CueOrigin.name, nil, {"%02.0f"})
object.element_params = {"HUD_BRIGHT", "HUD_VEL_CUE_MOVE", "HUD_VEL_CUE_VALUE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, 27.5, 30.05}, {"text_using_parameter", 2, 0}}


addStrokeLine("HUD_VelScaleLine", 10, {10, 0}, 90, HUD_VelScale_origin.name)

-- Altitude numerics
local HUD_Alt_num_origin	= addPlaceholder("HUD_Alt_num_origin", {115, 0}, HUD_Indication_bias.name)
HUD_Alt_num_origin.element_params = {"UFCP_VAH", "HUD_BRIGHT"}
HUD_Alt_num_origin.controllers = {{"parameter_compare_with_number",0,0}, {"opacity_using_parameter", 1}}

object = addStrokeText("HUD_Altitude_num_k", "10", STROKE_FNT_DFLT_100_NARROW, "RightCenter", {-20, 0}, HUD_Alt_num_origin.name, {{"HUD_Altitude_Num", 0}}, {"%1.0f"})
object.element_params = {"HUD_ALT_K", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

addStrokeText("HUD_Altitude_num_comma", ".", STROKE_FNT_DFLT_100_NARROW, "CenterCenter", {-19.5, 0}, HUD_Alt_num_origin.name)

object = addStrokeText("HUD_Altitude_num", "20", STROKE_FNT_DFLT_100_NARROW, "RightCenter", {-3, 0}, HUD_Alt_num_origin.name, {{"HUD_Altitude_Num", 1}}, {"%03.0f"})
object.element_params = {"HUD_ALT_N", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

addStrokeSymbol("HUD_Altitude_box", {"a29b_stroke_symbols_HUD", "10-altitude-box"}, "FromSet", {-15, 0}, HUD_Alt_num_origin.name)
addStrokeLine("HUD_AltNumLine", 10, {-41, 0}, -90, HUD_Alt_num_origin.name)

-- Altitude scale
local altScale500FeetStep		= 25
local altScaleLongTickLen		= 4
local altScaleShortTickLen		= 2
local Mil_Per100Feet			= altScale500FeetStep / 50

local HUD_AltScale_origin = addPlaceholder("HUD_AltScale_origin", {84, 0}, HUD_Indication_bias.name, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_AltScaleOrigin"}})
HUD_AltScale_origin.element_params = {"UFCP_VAH"}
HUD_AltScale_origin.controllers = {{"parameter_compare_with_number",0,1}}

local HUD_AltScale_originLong  = addPlaceholder("HUD_AltScale_originLong", {altScaleShortTickLen, 0}, HUD_AltScale_origin.name, {{"HUD_AltScaleVerPos", 0, Mil_Per100Feet}})
HUD_AltScale_originLong.element_params = {"HUD_ALT_SCALE_MOVE"}
HUD_AltScale_originLong.controllers = { {"move_up_down_using_parameter",0, -altScale500FeetStep/500/1000*yScale}}

local HUD_AltScale_originShort = {}
for j = 1,4 do
	HUD_AltScale_originShort[j] = addPlaceholder("HUD_AltScale_originShort"..j, {0, 0}, HUD_AltScale_originLong.name, {{"HUD_AltScaleVerPos", 10 * j, Mil_Per100Feet}})
end

for i = 1, 4 do
	local posY = altScale500FeetStep * (i - 2.5)-- + velScale50KnotsStep / 2
	object = addStrokeLine("HUD_AltScaleTickLong_"..i, altScaleLongTickLen, {0, posY}, -90, HUD_AltScale_originLong.name, {{"HUD_AltScaleHide", i, 0}})
	if i == 1 then
		object.element_params = {"HUD_BRIGHT", "HUD_ALT_SCALE_MOVE"}
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , 0.05}}
	end
for j = 1,4 do
		object = addStrokeLine("HUD_AltScaleTickShort_"..j..i, altScaleShortTickLen, {0, posY + j*altScale500FeetStep/5}, -90, HUD_AltScale_originShort[j].name, {{"HUD_AltScaleHide", i, j}})
		object.element_params = {"HUD_BRIGHT", "HUD_ALT_SCALE_MOVE"}
		if i == 1 then
			object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , (j)*100+0.05}}
		elseif i == 4 then
			object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1,j*100-0.05, 500.05}}
		end
	end
	object = addStrokeText("HUD_AltScaleNumericsL_"..i, i, STROKE_FNT_DFLT_100_NARROW, "LeftCenter", {altScaleLongTickLen + altScaleShortTickLen, posY}, HUD_AltScale_originLong.name, {{"HUD_AltScaleText", i, 0}}, {"%04.1f"})
	object.element_params = {"HUD_BRIGHT", "HUD_ALT_SCALE_MOVE", "HUD_ALT_SCALE_NUM_"..i}
	if i == 1 then
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , 0.05}, {"text_using_parameter",2,0}}
	else 
		object.controllers = { {"opacity_using_parameter", 0}, {"text_using_parameter",2,0}}
	end
end
addStrokeLine("HUD_AltScaleLine", 10, {-10, 0}, -90, HUD_AltScale_origin.name)

local HUD_Alt_Cue_origin = addPlaceholder(nil, {0,0}, HUD_AltScale_origin.name)
HUD_Alt_Cue_origin.element_params = {"HUD_ALT_CUE_MOVE", "HUD_ALT_CUE_VALUE"}
HUD_Alt_Cue_origin.controllers = {{"move_up_down_using_parameter",0, altScale500FeetStep/500/1000*yScale}, {"parameter_in_range", 1, -0.05, 50000}}
object = addStrokeSymbol("HUD_Alt_Cue", {"a29b_stroke_symbols_HUD", "AA-DLZ-range"}, "RightCenter", {0, 0}, HUD_Alt_Cue_origin.name)
object = addStrokeText("HUD_AltCueNumerics", 0, STROKE_FNT_DFLT_100_NARROW, "RightCenter", {-7,0}, HUD_Alt_Cue_origin.name, nil, {"%04.1f"})
object.element_params = {"HUD_BRIGHT", "HUD_ALT_CUE_MOVE", "HUD_ALT_CUE_VALUE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, 775, 800.05}, {"text_using_parameter", 2, 0}}


-- Vertical Speed scale
local VSScale1000FeetStep		= 25 * 1.4/2
local VSScaleLongTickLen		= 4
local VSScaleShortTickLen		= 2
local VSMil_Per100Feet			= VSScale1000FeetStep / 50

local HUD_VSScale_origin = addPlaceholder(nil, {66, 0}, HUD_Indication_bias.name, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_AltScaleOrigin"}})
HUD_VSScale_origin.element_params = {"UFCP_VV"}
HUD_VSScale_origin.controllers = {{"parameter_compare_with_number",0,1}}

local HUD_VSScale_originLong  = addPlaceholder(nil, {VSScaleShortTickLen, 0}, HUD_VSScale_origin.name, {{"HUD_AltScaleVerPos", 0, VSMil_Per100Feet}})
local HUD_VSScale_originShort = {}
for j = 1,4 do
	HUD_VSScale_originShort[j] = addPlaceholder(nil, {0, 0}, HUD_VSScale_originLong.name, {{"HUD_AltScaleVerPos", 10 * j, VSMil_Per100Feet}})
end

for i = 1, 5 do
	local posY = VSScale1000FeetStep * (i -3)
	object = addStrokeLine(nil, VSScaleLongTickLen, {0, posY}, -90, HUD_VSScale_originLong.name, {{"HUD_AltScaleHide", j, 0}})
	if i ~= 5 then
		object = addStrokeLine(nil, VSScaleShortTickLen, {0, posY + VSScale1000FeetStep/2}, -90, HUD_VSScale_originShort[i].name, {{"HUD_AltScaleHide", i}})
	end
end
local HUD_VS_Cue_origin = addPlaceholder(nil, {0,0}, HUD_VSScale_origin.name)
HUD_VS_Cue_origin.element_params = {"HUD_VS_CUE_MOVE", "HUD_VS_CUE_VALUE"}
HUD_VS_Cue_origin.controllers = {{"move_up_down_using_parameter",0, VSScale1000FeetStep/1000/1000*yScale}, {"parameter_in_range", 1, -0.05, 50000}}
object = addStrokeSymbol(nil, {"a29b_stroke_symbols_HUD", "AA-DLZ-range"}, "RightCenter", {0, 0}, HUD_VS_Cue_origin.name)


-- Heading numerics
local HUD_Hdg_origin	= addPlaceholder("HUD_Hdg_origin", {0, 95}, nil, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_Heading_Bias"}})
HUD_Hdg_origin.element_params = {"UFCP_VAH", "HUD_BRIGHT"}
HUD_Hdg_origin.controllers = {{"parameter_compare_with_number",0,0}, {"opacity_using_parameter", 1}}
object = addStrokeText("HUD_Heading_num", "360", STROKE_FNT_DFLT_100_NARROW, "CenterCenter", {0, -12.5}, HUD_Hdg_origin.name, {{"HUD_Heading_Num"}}, {"%03.0f"})
object.element_params = {"HUD_HDG", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}
addStrokeBox("HUD_Heading_box", 17, 11, "CenterCenter", {0, -12.5}, HUD_Hdg_origin.name)

-- Heading scale
local hdgScaleTenDegreesStep	= 32
local hdgScaleLongTickLen		= 4
local hdgScaleTextShiftY		= 2
local Mil_PerOneDegree			= hdgScaleTenDegreesStep / 10

local HUD_HdgScale_origin = addPlaceholder("HUD_HdgScale_origin", {0, 97}, nil, {{"HUD_HdgScaleOrigin"}})		--  -53
HUD_HdgScale_origin.element_params = {"UFCP_VAH", "HUD_BRIGHT"}
HUD_HdgScale_origin.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}

local HUD_HdgScale_originLong  = addPlaceholder("HUD_HdgScale_originLong", {0, -hdgScaleTextShiftY}, HUD_HdgScale_origin.name, {{"HUD_HdgScaleHorPos", 0, Mil_PerOneDegree}})
HUD_HdgScale_originLong.element_params = {"HUD_HDG_SCALE_MOVE"}
HUD_HdgScale_originLong.controllers = { {"move_left_right_using_parameter",0, -hdgScaleTenDegreesStep/10/1000*xScale}}

local HUD_HdgScale_originShort = addPlaceholder("HUD_HdgScale_originShort", {0, 0}, HUD_HdgScale_originLong.name, {{"HUD_HdgScaleHorPos", -5, Mil_PerOneDegree}})

for i = 1, 4 do
	local posX = hdgScaleTenDegreesStep * (i - 2) 
	object = addStrokeLine("HUD_HeadingTickLong_"..i, -hdgScaleLongTickLen, {posX, 0}, 0, HUD_HdgScale_originLong.name, {{"HUD_HdgScaleHide", (i - 2), 0}})
	if i == 1 then
		object.element_params = {"HUD_BRIGHT", "HUD_HDG_SCALE_MOVE"}
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , 2.05}}
	elseif i == 4 then
		object.element_params = {"HUD_BRIGHT", "HUD_HDG_SCALE_MOVE"}
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, 7.95 , 10.05}}
	end
	object = addStrokeLine("HUD_HeadingTickShort_"..i, -hdgScaleLongTickLen * 0.5, {posX + hdgScaleTenDegreesStep/2, 0}, 0, HUD_HdgScale_originShort.name, {{"HUD_HdgScaleHide", (i - 2), 1}})
	object.element_params = {"HUD_BRIGHT", "HUD_HDG_SCALE_MOVE"}
	if i == 1 then
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , 7.05}}
	elseif i == 3 then
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, 2.95 , 10.05}}
	elseif i == 4 then
		object. isvisible = false
	end
	object = addStrokeText("HUD_HeadingNumerics_"..i, tostring(i), STROKE_FNT_DFLT_100_NARROW, "CenterTop", {posX, - (hdgScaleLongTickLen + hdgScaleTextShiftY)}, HUD_HdgScale_originLong.name, {{"HUD_HeadingScaleText", (i - 2)}}, {"%02.0f"})
	object.element_params = {"HUD_BRIGHT", "HUD_HDG_SCALE_MOVE", "HUD_HDG_SCALE_NUM_"..i}
	if i == 1 then
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, -0.05 , 2.05}, {"text_using_parameter",2, 0}}
	elseif i == 4 then
		object.controllers = { {"opacity_using_parameter", 0}, {"parameter_in_range",1, 7.95 , 10.05}, {"text_using_parameter",2, 0}}
	else 
		object.controllers = { {"opacity_using_parameter", 0}, {"text_using_parameter",2, 0}}
	end
end

local HUD_Hdg_Cue_origin = addPlaceholder(nil, {0,0}, HUD_HdgScale_origin.name)
HUD_Hdg_Cue_origin.element_params = {"HUD_HDG_CUE_MOVE", "HUD_HDG_CUE_VALUE"}
HUD_Hdg_Cue_origin.controllers = {{"move_left_right_using_parameter",0, hdgScaleTenDegreesStep/10/1000*xScale}, {"parameter_in_range", 1, -0.05, 360}}
object = addStrokeSymbol("HUD_Hdg_Cue", {"a29b_stroke_symbols_HUD", "AA-DLZ-range"}, "RightCenter", {0, 0}, HUD_Hdg_Cue_origin.name)
object.init_rot = {-90}

-- heading index
addStrokeLine("HUD_HeadingScaleIndex", 10, {0, 0}, 0, HUD_HdgScale_origin.name)

-- Normal Acceleration
object = addStrokeText("HUD_NormalAccel", "1.0", STROKE_FNT_DFLT_120, "CenterCenter", {-72.5, 65}, nil, nil, {"%1.1f"})
object.element_params = {"HUD_NORMAL_ACCEL", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

-- Max Acceleration
object = addStrokeText("HUD_MaxAccel", "1.0", STROKE_FNT_DFLT_120, "RightCenter", {-65, -71}, nil, nil, {"%1.1f"})
object.element_params = {"HUD_MAX_ACCEL", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"parameter_in_range", 0, -0.05, 100}, {"opacity_using_parameter", 1}}


-- Weapon Ready
object = addStrokeText("HUD_Rdy", "RDY", STROKE_FNT_DFLT_120, "CenterCenter", {-85, 75})
object.element_params = {"HUD_RDY", "HUD_BRIGHT"}
object.controllers = {{"parameter_in_range",0,0.95, 2.05}, {"opacity_using_parameter", 1}}

object = addStrokeText("HUD_Rdy_S", "S", STROKE_FNT_DFLT_120, "CenterCenter", {-70, 75})
object.element_params = {"HUD_RDY", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number",0,2}, {"opacity_using_parameter", 1}}


-- DOI
object = addStrokeSymbol("HUD_Doi", {"a29b_stroke_symbols_HUD", "hud-doi"}, "FromSet", {94, 45})
object.element_params = {"HUD_DOI", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}

-- Radar Altimeter
addStrokeText("HUD_Radar_Alt_R", "R", STROKE_FNT_DFLT_120, "CenterCenter", {60, -60})
addStrokeBox("HUD_Radar_Alt_Box", 27.5, 11, "CenterCenter", {85, -60})
object = addStrokeText("HUD_Radar_Alt", "5000", STROKE_FNT_DFLT_120, "RightCenter", {97.5, -60}, nil, nil, {"%03.0f"})
object.element_params = {"HUD_RADAR_ALT", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"parameter_in_range",0,-0.05,5005}, {"opacity_using_parameter", 1}}

object = addStrokeText("HUD_Radar_Alt_XXXX", "XXXX", STROKE_FNT_DFLT_120, "RightCenter", {97.5, -60})
object.element_params = {"HUD_RADAR_ALT", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number",0,-1}, {"opacity_using_parameter", 1}}

-- Range indicator
object = addStrokeText("HUD_Range", "324", STROKE_FNT_DFLT_120, "CenterCenter", {75, -77}, nil, nil, {"%.0f"})
object.element_params = {"HUD_RANGE", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter", 0, 0}, {"parameter_in_range",0,-0.05, 9999}, {"opacity_using_parameter", 1}}

-- Time indicator
object = addStrokeText("HUD_Time", "00:00", STROKE_FNT_DFLT_120, "CenterCenter", {74, -88}, nil, nil, {"%s"})
object.element_params = {"HUD_TIME", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter", 0, 0}, {"opacity_using_parameter", 1}}

-- FTY distance indicator
object = addStrokeText("HUD_FTI_Dist", "22.3>08", STROKE_FNT_DFLT_120, "CenterCenter", {80, -99}, nil, nil, {"%02.1f>","%02.0f"})
object.element_params = {"CMFD_NAV_FYT_DTK_DIST", "CMFD_NAV_FYT", "HUD_BRIGHT", "ADHSI_DTK"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",0,-0.05, 99.94}, {"opacity_using_parameter", 2}, {"parameter_compare_with_number", 3,0}}

object = addStrokeText("HUD_FTI_Dist_100", "22.3>08", STROKE_FNT_DFLT_120, "CenterCenter", {80, -99}, nil, nil, {"%3.0f>","%02.0f"})
object.element_params = {"CMFD_NAV_FYT_DTK_DIST", "CMFD_NAV_FYT", "HUD_BRIGHT", "ADHSI_DTK"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",0, 99.95, 999.5}, {"opacity_using_parameter", 2}, {"parameter_compare_with_number", 3,0}}

object = addStrokeText("HUD_DTK_Dist", "22.3>08", STROKE_FNT_DFLT_120, "CenterCenter", {80, -99}, nil, nil, {"%02.1f>D","%02.0f"})
object.element_params = {"CMFD_NAV_FYT_DTK_DIST", "CMFD_NAV_FYT", "HUD_BRIGHT", "ADHSI_DTK"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",0,-0.05, 99.94}, {"opacity_using_parameter", 2}, {"parameter_compare_with_number", 3, 1}}

object = addStrokeText("HUD_DTK_Dist_100", "22.3>08", STROKE_FNT_DFLT_120, "CenterCenter", {80, -99}, nil, nil, {"%3.0f>","%02.0f"})
object.element_params = {"CMFD_NAV_FYT_DTK_DIST", "CMFD_NAV_FYT", "HUD_BRIGHT", "ADHSI_DTK"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",0, 99.95, 999.5}, {"opacity_using_parameter", 2}, {"parameter_compare_with_number", 3, 1}}

object = addStrokeText("HUD_FTI_Dist_XXX", "22.3>08", STROKE_FNT_DFLT_120, "CenterCenter", {80, -99}, nil, nil, {"XXX>%02.0f"})
object.element_params = {"CMFD_NAV_FYT_DTK_DIST", "CMFD_NAV_FYT", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter", 1, 0}, {"parameter_compare_with_number",0,-1}, {"opacity_using_parameter", 2}}

-- VOR
object = addStrokeText("HUD_VOR", "101V090", STROKE_FNT_DFLT_120, "CenterCenter", {80, -110}, nil, nil, {"%2.1fV","%03.0f"})
object.element_params = {"HUD_VOR_DIST", "HUD_VOR_MAG", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",0,-0.05, 99.94}, {"opacity_using_parameter", 2}}

object = addStrokeText("HUD_VOR_100", "101V090", STROKE_FNT_DFLT_120, "CenterCenter", {80, -110}, nil, nil, {"%3.0fV","%03.0f"})
object.element_params = {"HUD_VOR_DIST", "HUD_VOR_MAG", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",0,99.95, 999.5}, {"opacity_using_parameter", 2}}

-- MACH
object = addStrokeText("HUD_Mach", "5000", STROKE_FNT_DFLT_120, "RightCenter", {-65, -60}, nil, nil, {"%01.2f"})
object.element_params = {"HUD_MACH", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"parameter_in_range",0,-0.05,2}, {"opacity_using_parameter", 1}}

-- Mode
object = addStrokeText("HUD_Mode", "", STROKE_FNT_DFLT_120, "RightCenter", {-65, -82}, nil, nil, {"%s"})
object.element_params = {"AVIONICS_MASTER_MODE_TXT", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

-- AoA
object = addStrokeText("HUD_AoA", "", STROKE_FNT_DFLT_120, "RightCenter", {-100, -71}, nil, nil, {"%.1f"})
object.element_params = {"HUD_AOA", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"parameter_in_range", 0, -9.1, 40.1}, {"opacity_using_parameter", 1}}

-- EGIR
object = addStrokeText("HUD_EGIR_OFF", "OFF", STROKE_FNT_DFLT_120, "RightCenter", {-65, -93})
object.element_params = {"HUD_EGIR", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number", 0, 0}, {"opacity_using_parameter", 1}}

object = addStrokeText("HUD_EGIR_ALIGN", "ALGN", STROKE_FNT_DFLT_120, "RightCenter", {-65, -93})
object.element_params = {"HUD_EGIR", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number", 0, 1}, {"opacity_using_parameter", 1}}

-- WARNING
object = addStrokeText("HUD_WARN", "WARN", STROKE_FNT_DFLT_120, "CenterCenter", {0, 0})
object.element_params = {"HUD_WARNING", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number", 0, 1}, {"opacity_using_parameter", 1}}

-- MG
object = addStrokeText(nil, "MG 500", STROKE_FNT_DFLT_120, "CenterCenter", {-80, -110}, nil, nil, {"MG %03.0f"})
object.element_params = {"HUD_BRIGHT", "WPN_AA_INTRG_QTY", "AVIONICS_MASTER_MODE"}
object.controllers = {
	{"opacity_using_parameter", 0}, 
	{"text_using_parameter", 1, 0}, 
	{"parameter_in_range",2,AVIONICS_MASTER_MODE_ID.DGFT_B-0.5, AVIONICS_MASTER_MODE_ID.GUN_M + 0.5},
}
