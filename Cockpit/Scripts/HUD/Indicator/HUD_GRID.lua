function basic_dump (o)
	if type(o) == "number" then
	  return tostring(o)
	elseif type(o) == "string" then
	  return string.format("%q", o)
	else -- nil, boolean, function, userdata, thread; assume it can be converted to a string
	  return tostring(o)
	end
end
function dump (name, value, saved, result)
	seen = seen or {}       -- initial value
	result = result or ""
	result=result..name.." = "
	if type(value) ~= "table" then
	  result=result..basic_dump(value).."\n"
	  log.info(result)
	  result = ""
	elseif type(value) == "table" then
	  if seen[value] then    -- value already saved?
		result=result.."->"..seen[value].."\n"  -- use its previous name
		log.info(result)
		result = ""
		else
		seen[value] = name   -- save name for next time
		result=result.."{}\n"     -- create a new table
		log.info(result)
		result = ""
		  for k,v in pairs(value) do      -- save its fields
		  local fieldname = string.format("%s[%s]", name,
										  basic_dump(k))
		  if fieldname~="_G[\"seen\"]" then
			result=dump(fieldname, v, seen, result)
		  end
		end
	  end
	end
	return result
  end

-- dump("_G", _G)
-- dump("_G", getmetatable(_G))

-- dump("GetSelf", GetSelf())
-- dump("GetSelf", getmetatable(GetSelf()))

-- dump("controller", ccIndicator)
-- dump("controller", getmetatable(ccIndicator))

-- dump("DCS", DCS)
-- dump("DCS", getmetatable(DCS))

-- local sensor_data = get_base_data()

-- dump("sensor_data", sensor_data)
-- dump("sensor_data", sensor_data)

dofile(LockOn_Options.script_path .. "HUD/Indicator/HUD_defs.lua")
dofile(LockOn_Options.script_path .. "HUD/HUD_ID_defs.lua")

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

-- object = addStrokeSymbol("HUD_Base", {"a29hud", "nav-mode"}, "FromSet", {0, -34}, nil, nil, 0.85, "INDICATION_COMMON_RED")
-- object = addStrokeSymbol("HUD_Base", {"a29hud", "landing-mode"}, "FromSet", {0, 0}, nil, nil, 0.9, "INDICATION_COMMON_AMBER")


local HUD_BoresightRoot = addStrokeSymbol("HUD_Boresight_Cross", {"stroke_symbols_HUD", "1-boresight-cross"}, "FromSet", {0, math.rad(1.2)*1000})

-- Flight Path Marker - FPM
local HUD_FPM_origin = addPlaceholder("HUD_FPM_origin", {0, 0}, nil, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_FPM_Pos"}})
HUD_FPM_origin.element_params = {"HUD_DCLT", "HUD_BRIGHT"}
HUD_FPM_origin.controllers = {{"parameter_compare_with_number",0,0}, {"opacity_using_parameter", 1}}


object = addStrokeSymbol("HUD_FPM", {"stroke_symbols_HUD", "2-flightpath-marker"}, "FromSet", {0, 0}, HUD_FPM_origin.name, {{"HUD_FPM_Flash"}})
object.element_params = {"HUD_FPM_SLIDE", "HUD_FPM_VERT", "HUD_DRIFT_CO", "HUD_BRIGHT"}
object.controllers = {{"move_left_right_using_parameter", 0, 0.75}, {"move_up_down_using_parameter", 1, 0.75}, {"parameter_compare_with_number",2,0}, {"opacity_using_parameter", 3}}

object = addStrokeSymbol("HUD_FPM_CO", {"stroke_symbols_HUD", "2-flightpath-marker-co"}, "FromSet", {0, 0}, HUD_FPM_origin.name, {{"HUD_FPM_Flash"}})
object.element_params = {"HUD_FPM_VERT", "HUD_DRIFT_CO", "HUD_BRIGHT"}
object.controllers = {{"move_up_down_using_parameter", 0, 0.75}, {"parameter_compare_with_number",1,1}, {"opacity_using_parameter", 2}}

-- FPM cross
object = addStrokeSymbol("HUD_FPM_Cross", {"stroke_symbols_HUD", "fpm-cross"}, "FromSet", {0, 0}, "HUD_FPM", {{"HUD_FPM_Cross"}})
object.element_params = {"HUD_FPM_CROSS", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}

-- -- AoA bracket
-- addStrokeSymbol("HUD_AoA_bracket", {"stroke_symbols_HUD", "aoa-bracket"}, "FromSet", {0, 0}, HUD_FPM_origin.name, {{"HUD_AoA_bracket"}})

-- -- Great steering circle cue "tadpole"
-- addStrokeSymbol("HUD_Tadpole", {"stroke_symbols_HUD", "3-great-steering-circle"}, "FromSet", nil, HUD_FPM_origin.name, {{"HUD_Tadpole_Pos", 50}})	-- 50 milradians for maximum offset

-- Pitch Ladder (PL)
local PL_origin = addPlaceholder("HUD_PL_origin", {0, 0}, HUD_FPM_origin.name, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_PitchLadder_Show"}, {"HUD_PitchLadder_PosRot"}})
PL_origin.element_params            = {"HUD_PITCH", "HUD_ROLL", "HUD_PL_SLIDE"}
PL_origin.controllers 		        = {{"move_left_right_using_parameter", 2, 0.75}, {"rotate_using_parameter",1, 1 }, {"move_up_down_using_parameter",0,-0.75}, }

local PL_horizon_line_half_gap		= 16
local PL_long_horizon_line_width	= 70

local PL_pitch_line_half_gap		= 16
local PL_pitch_line_width			= 25
local PL_pitch_line_tick			= 4


-- long line - horizon
object = add_PL_line("PL_horizon_long_line", PL_long_horizon_line_width, PL_horizon_line_half_gap, 0, 0, 0, {{"HUD_PL_GhostHorizon", 0}}, PL_origin.name)
-- object.element_params = {"HUD_PL_GHOST"}
-- object.controllers = {{"parameter_compare_with_number",0,0}}

-- object = add_PL_GhostHorizon("PL_GhostHorizon_", PL_long_horizon_line_width, PL_horizon_line_half_gap, {{"HUD_PitchLadder_Show"}, {"HUD_PL_GhostHorizon", 1}}, {0, 0})
-- object.element_params = {"HUD_PL_GHOST"}
-- object.controllers = {{"parameter_compare_with_number",0,1}}

-- -85 to +85 degrees
local counterBegin = -85
local counterEnd   = -counterBegin
for i = counterBegin, counterEnd, 5 do
	if i ~= 0 then
		object = add_PL_line("PL_pitch_line_"..i, PL_pitch_line_width, PL_pitch_line_half_gap, PL_pitch_line_tick, DegToMil(i), i, {{"HUD_PitchLadder_Limit", DegToMil(10)}}, PL_origin.name)
	end
end

-- Roll Indicator
local HUD_RI_origin	= addPlaceholder("HUD_RI_origin", {0, -60}, nil, {{"HUD_RI_Pos"}})
HUD_RI_origin.element_params = {"HUD_MODE", "HUD_BRIGHT"}
HUD_RI_origin.controllers = {{"parameter_compare_with_number", 0, HUD_MODE_ID.LANDING}, {"opacity_using_parameter", 1}}

local HUD_RI_origin_rot	= addPlaceholder("HUD_RI_origin_rot", {0, 0}, HUD_RI_origin.name)
HUD_RI_origin_rot.element_params = {"HUD_RI_ROLL"}
HUD_RI_origin_rot.controllers = {{"rotate_using_parameter", 0, 1}}
addRollIndicator(90, 8, 2, HUD_RI_origin.name)
addStrokeSymbol("HUD_Roll_Indicator_Caret", {"stroke_symbols_HUD", "11-roll-caret"}, "FromSet", {0, -94}, HUD_RI_origin_rot.name, {{"HUD_RI_Roll", -55}})


--
local HUD_Indication_bias = addPlaceholder("HUD_Indication_bias", {0, 0}, nil, {{"HUD_Indication_Bias"}})


-- Velocity numerics
local HUD_Vel_num_origin	= addPlaceholder("HUD_Vel_num_origin", {-93, 0}, HUD_Indication_bias.name)
HUD_Vel_num_origin.element_params = {"HUD_VAH"}
HUD_Vel_num_origin.controllers = {{"parameter_compare_with_number",0,0}}

object = addStrokeText("HUD_Velocity_num", "520", STROKE_FNT_DFLT_100_NARROW, "RightCenter", {0, 0}, HUD_Vel_num_origin.name, {{"HUD_Velocity_Num"}}, {"%3.0f"})
object.element_params = {"HUD_IAS", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

addStrokeSymbol("HUD_Velocity_box", {"stroke_symbols_HUD", "9-velocity-box"}, "FromSet", {-9, 0}, HUD_Vel_num_origin.name)
addStrokeLine("HUD_VelScaleLine", 10, {13, 0}, 90, HUD_Vel_num_origin.name)

-- Velocity scale
local velScale50KnotsStep		= 25
local velScaleLongTickLen		= 5
local velScaleShortTickLen		= 3
local Mil_PerOneKnots			= velScale50KnotsStep / 50



local HUD_VelScale_origin = addPlaceholder("HUD_VelScale_origin", {-87.5 + velScaleLongTickLen, 0}, HUD_Indication_bias.name, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_VelScaleOrigin"}})
HUD_VelScale_origin.element_params = {"HUD_VAH", "HUD_BRIGHT"}
HUD_VelScale_origin.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}


local HUD_VelScale_originLong  = addPlaceholder("HUD_VelScale_originLong", {0, 0}, HUD_VelScale_origin.name, {{"HUD_VelScaleVerPos", 0, Mil_PerOneKnots}})
local HUD_VelScale_originShort = {}
for j = 1,4 do
	HUD_VelScale_originShort[j] = addPlaceholder("HUD_VelScale_originShort"..j, {0, 0}, HUD_VelScale_origin.name, {{"HUD_VelScaleVerPos", 10 * j, Mil_PerOneKnots}})
end

for i = 1, 4 do
	local posY = velScale50KnotsStep * (i - 2)-- + velScale50KnotsStep / 2
	addStrokeLine("HUD_VelScaleTickLong_"..i, velScaleLongTickLen, {0, posY}, 90, HUD_VelScale_originLong.name, {{"HUD_VelScaleHide", i, 0}})
	for j = 1,4 do
		addStrokeLine("HUD_VelScaleTickShort_"..j..i, velScaleShortTickLen, {0, posY}, 90, HUD_VelScale_originShort[j].name, {{"HUD_VelScaleHide", i, j}})
	end

	addStrokeText("HUD_VelScaleNumerics_"..i, tostring(i), STROKE_FNT_DFLT_100_NARROW, "RightCenter", {-velScaleLongTickLen - 1, posY}, HUD_VelScale_originLong.name, {{"HUD_VelScaleText", i}})
end
--
addStrokeLine("HUD_Window2_VelScaleLine", 10, {velScaleLongTickLen + 4.5, 0}, 90, HUD_VelScale_origin.name)

-- Altitude numerics
local HUD_Alt_num_origin	= addPlaceholder("HUD_Alt_num_origin", {115, 0}, HUD_Indication_bias.name)
HUD_Alt_num_origin.element_params = {"HUD_VAH", "HUD_BRIGHT"}
HUD_Alt_num_origin.controllers = {{"parameter_compare_with_number",0,0}, {"opacity_using_parameter", 1}}

object = addStrokeText("HUD_Altitude_num_k", "10", STROKE_FNT_DFLT_100_NARROW, "RightCenter", {-20, 0}, HUD_Alt_num_origin.name, {{"HUD_Altitude_Num", 0}}, {"%1.0f"})
object.element_params = {"HUD_ALT_K", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

addStrokeText("HUD_Altitude_num_comma", ".", STROKE_FNT_DFLT_100_NARROW, "CenterCenter", {-19.5, 0}, HUD_Alt_num_origin.name)

object = addStrokeText("HUD_Altitude_num", "20", STROKE_FNT_DFLT_100_NARROW, "RightCenter", {-3, 0}, HUD_Alt_num_origin.name, {{"HUD_Altitude_Num", 1}}, {"%03.0f"})
object.element_params = {"HUD_ALT_N", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

addStrokeSymbol("HUD_Altitude_box", {"stroke_symbols_HUD", "10-altitude-box"}, "FromSet", {-15, 0}, HUD_Alt_num_origin.name)
addStrokeLine("HUD_AltScaleLine", 10, {-41, 0}, -90, HUD_Alt_num_origin.name)

-- Altitude scale
local altScale500FeetStep		= 25
local altScaleLongTickLen		= 5
local altScaleShortTickLen		= 3
local Mil_Per100Feet			= altScale500FeetStep / 50

local HUD_AltScale_origin = addPlaceholder("HUD_AltScale_origin", {86 - altScaleLongTickLen, 0}, HUD_Indication_bias.name, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_AltScaleOrigin"}})
HUD_AltScale_origin.element_params = {"HUD_VAH"}
HUD_AltScale_origin.controllers = {{"parameter_compare_with_number",0,1}}

local HUD_AltScale_originLong  = addPlaceholder("HUD_AltScale_originLong", {0, 0}, HUD_AltScale_origin.name, {{"HUD_AltScaleVerPos", 0, Mil_Per100Feet}})
local HUD_AltScale_originShort = {}
for j = 1,4 do
	HUD_AltScale_originShort[j] = addPlaceholder("HUD_AltScale_originShort"..j, {0, 0}, HUD_AltScale_origin.name, {{"HUD_AltScaleVerPos", 10 * j, Mil_Per100Feet}})
end

for i = 1, 4 do
	local posY = altScale500FeetStep * (i - 2)-- + velScale50KnotsStep / 2
	addStrokeLine("HUD_AltScaleTickLong_"..i, altScaleLongTickLen, {0, posY}, -90, HUD_AltScale_originLong.name, {{"HUD_AltScaleHide", i, 0}})
	for j = 1,4 do
		addStrokeLine("HUD_AltScaleTickShort_"..j..i, altScaleShortTickLen, {0, posY}, -90, HUD_AltScale_originShort[j].name, {{"HUD_AltScaleHide", i, j}})
	end

	addStrokeText("HUD_AltScaleNumericsL_"..i, tostring(i), STROKE_FNT_DFLT_100_NARROW, "RightCenter", {altScaleLongTickLen + 10.5, posY}, HUD_AltScale_originLong.name, {{"HUD_AltScaleText", i, 0}})
	addStrokeText("HUD_AltScale_comma"..i, ".", STROKE_FNT_DFLT_100_NARROW, "CenterCenter", {altScaleLongTickLen + 11.5, posY}, HUD_AltScale_originLong.name, {{"HUD_AltScaleText", i, 1}})
	addStrokeText("HUD_AltScaleNumericsR_"..i, tostring(i), STROKE_FNT_DFLT_100_NARROW, "RightCenter", {altScaleLongTickLen + 16.5, posY}, HUD_AltScale_originLong.name, {{"HUD_AltScaleText", i, 2}})
end
addStrokeLine("HUD_AltScaleLine", 10, {-velScaleLongTickLen - 4.5, 0}, -90, HUD_AltScale_origin.name)

-- Heading numerics
local HUD_Hdg_origin	= addPlaceholder("HUD_Hdg_origin", {0, 95}, nil, {{"HUD_AA_Gun_HideIfActive"}, {"HUD_Heading_Bias"}})
HUD_Hdg_origin.element_params = {"HUD_VAH", "HUD_BRIGHT"}
HUD_Hdg_origin.controllers = {{"parameter_compare_with_number",0,0}, {"opacity_using_parameter", 1}}

object = addStrokeText("HUD_Heading_num", "360", STROKE_FNT_DFLT_100_NARROW, "CenterCenter", {0, -12.5}, HUD_Hdg_origin.name, {{"HUD_Heading_Num"}}, {"%03.0f"})
object.element_params = {"HUD_HDG", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

addStrokeBox("HUD_Heading_box", 17, 11, "CenterCenter", {0, -12.5}, HUD_Hdg_origin.name)

-- Heading scale
-- heading scale
local hdgScaleTenDegreesStep	= 32
local hdgScaleLongTickLen		= 5
local hdgScaleTextShiftY		= 2
local Mil_PerOneDegree			= hdgScaleTenDegreesStep / 10

local HUD_HdgScale_origin = addPlaceholder("HUD_HdgScale_origin", {0, 0}, HUD_Hdg_origin.name, {{"HUD_HdgScaleOrigin"}})		--  -53
HUD_HdgScale_origin.element_params = {"HUD_VAH", "HUD_BRIGHT"}
HUD_HdgScale_origin.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}

local HUD_HdgScale_originLong  = addPlaceholder("HUD_HdgScale_originLong", {0, 0}, HUD_HdgScale_origin.name, {{"HUD_HdgScaleHorPos", 0, Mil_PerOneDegree}})
local HUD_HdgScale_originShort = addPlaceholder("HUD_HdgScale_originShort", {0, 0}, HUD_HdgScale_origin.name, {{"HUD_HdgScaleHorPos", -5, Mil_PerOneDegree}})

for i = 1, 3 do
	local posX = hdgScaleTenDegreesStep * (i - 2) - hdgScaleTenDegreesStep / 2
	addStrokeLine("HUD_HeadingTickLong_"..i, -hdgScaleLongTickLen, {posX, 0}, 0, HUD_HdgScale_originLong.name, {{"HUD_HdgScaleHide", (i - 2), 0}})
	addStrokeLine("HUD_HeadingTickShort_"..i, -hdgScaleLongTickLen * 0.5, {posX, 0}, 0, HUD_HdgScale_originShort.name, {{"HUD_HdgScaleHide", (i - 2), 1}})
	addStrokeText("HUD_HeadingNumerics_"..i, tostring(i), STROKE_FNT_DFLT_100_NARROW, "CenterTop", {posX, - (hdgScaleLongTickLen + hdgScaleTextShiftY)}, HUD_HdgScale_originLong.name, {{"HUD_HeadingScaleText", (i - 2)}})
end

-- heading index
addStrokeLine("HUD_HeadingScaleIndex", 2 * hdgScaleLongTickLen, {0, 2}, 0, HUD_HdgScale_origin.name)

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
object.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}

object = addStrokeText("HUD_Rdy", "S", STROKE_FNT_DFLT_120, "CenterCenter", {-70, 75})
object.element_params = {"HUD_RDY_S", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}


-- DOI
object = addStrokeSymbol("HUD_Doi", {"stroke_symbols_HUD", "hud-doi"}, "FromSet", {94, 45})
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
object = addStrokeText("HUD_Time", "00:00", STROKE_FNT_DFLT_120, "CenterCenter", {74, -88}, nil, nil, {"%02.0f:","%02.0f"})
object.element_params = {"HUD_TIME_MIN", "HUD_TIME_SEC", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",1,-0.05, 60}, {"opacity_using_parameter", 2}}


-- FTY distance indicator
object = addStrokeText("HUD_FTI_Dist", "22.3>08", STROKE_FNT_DFLT_120, "CenterCenter", {80, -99}, nil, nil, {"%02.1f>","%02.0f"})
object.element_params = {"HUD_FTI_DIST", "HUD_FTI_NUM", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",0,-0.05, 99.94}, {"opacity_using_parameter", 2}}

object = addStrokeText("HUD_FTI_Dist_100", "22.3>08", STROKE_FNT_DFLT_120, "CenterCenter", {80, -99}, nil, nil, {"%3.0f>","%02.0f"})
object.element_params = {"HUD_FTI_DIST", "HUD_FTI_NUM", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter", 0, 0}, {"text_using_parameter", 1, 1}, {"parameter_in_range",0, 99.95, 999.5}, {"opacity_using_parameter", 2}}

object = addStrokeText("HUD_FTI_Dist_XXX", "22.3>08", STROKE_FNT_DFLT_120, "CenterCenter", {80, -99}, nil, nil, {"XXX>%02.0f"})
object.element_params = {"HUD_FTI_DIST", "HUD_FTI_NUM", "HUD_BRIGHT"}
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
object.element_params = {"HUD_MODE_TXT", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}

-- AoA
object = addStrokeText("HUD_AoA", "", STROKE_FNT_DFLT_120, "RightCenter", {-100, -71}, nil, nil, {"%.1f"})
object.element_params = {"HUD_AOA", "HUD_BRIGHT"}
object.controllers = {{"text_using_parameter",0,0}, {"parameter_in_range", 0, -9.1, 40.1}, {"opacity_using_parameter", 1}}

-- EGIR
object = addStrokeText("HUD_EGIR_OFF", "OFF", STROKE_FNT_DFLT_120, "RightCenter", {-65, -93})
object.element_params = {"HUD_EGIR", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number", 0, 0}, {"opacity_using_parameter", 1}}

object = addStrokeText("HUD_EGIR_ALIGN", "ALIGN", STROKE_FNT_DFLT_120, "RightCenter", {-65, -93})
object.element_params = {"HUD_EGIR", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number", 0, 1}, {"opacity_using_parameter", 1}}

-- WARNING
object = addStrokeText("HUD_WARN", "WARN", STROKE_FNT_DFLT_120, "CenterCenter", {0, 0})
object.element_params = {"HUD_WARNING", "HUD_BRIGHT"}
object.controllers = {{"parameter_compare_with_number", 0, 1}, {"opacity_using_parameter", 1}}
