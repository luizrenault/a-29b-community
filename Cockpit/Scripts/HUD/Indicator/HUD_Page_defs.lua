dofile(LockOn_Options.script_path.."HUD/symbology_defs.lua")

dofile(LockOn_Options.script_path.."HUD/indicator/Units.lua")

-- dofile(LockOn_Options.script_path.."Computers/MMC_Types.lua")

-- Scale
SetScale(MILLYRADIANS)


-- stroke_font			= "font_stroke_HUD"
-- stroke_material		= "HUD"

if override_materials == true then
	default_material	= override_material
	stroke_font			= override_font
else
	default_material	= stroke_material
end

z_disabled				= true

DEFAULT_LEVEL = 11

HUD_TFOV_mils			= DegToMil(10)	-- HUD Total Vield of View radius in milliradians

dbg_addIndicatorCenter()

boresightShiftY = 98		--DegToMil(4.8)

-- Fonts

-- WARNING! The only available fonts sizes
-- Do not define your own sizes!

-- Currently used miliradians
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


STROKE_FNT_DFLT_100			= 1
STROKE_FNT_DFLT_100_NARROW	= 2
STROKE_FNT_DFLT_75			= 3
STROKE_FNT_DFLT_120			= 4

stringdefs[STROKE_FNT_DFLT_100]			= {fontScaleY_100, fontScaleX_100, fontIntercharScale_100, fontInterlineScale_100}
stringdefs[STROKE_FNT_DFLT_100_NARROW]	= {fontScaleY_100, fontScaleX_100, fontIntercharScale_75,  fontInterlineScale_100}
stringdefs[STROKE_FNT_DFLT_75]			= {fontScaleY_75,  fontScaleX_75,  fontIntercharScale_75,  fontInterlineScale_75}
stringdefs[STROKE_FNT_DFLT_120]			= {fontScaleY_120, fontScaleX_120, fontIntercharScale_120, fontInterlineScale_120}

-- Functions
function addRollIndicator(radius, longLine, delta, parent)
	local radiusS = radius - delta				-- short ticks
	local shortLine = longLine - delta
	for i = 1,7 do
		if i~=3 and i~=5 then
			local aStep = 15 * (i-4)
			addStrokeLine("HUD_Roll_IndicatorL_"..i, longLine, {radius * math.sin(math.rad(aStep)), -radius * math.cos(math.rad(aStep))}, aStep, parent)
		end
		if i~=1 and i~=4 and i~=7 then
			local aStep = 10 * (i-4)
			addStrokeLine("HUD_Roll_IndicatorS_"..i, shortLine, {radiusS * math.sin(math.rad(aStep)), -radiusS * math.cos(math.rad(aStep))}, aStep, parent)
		end
	end
end

-- Pitch Ladder (PL) line
-- text shift (x, y) from the horizontal line end
local PL_text_shift_x				= -3
local PL_text_shift_y				= 5
-- negative pitch line is dashed
local PL_negline_stroke				= 5
local PL_negline_gap				= 2

function add_PL_line(name, width, half_gap, tick, shift_y, pitch, controllers, origin_name)
	
	local lineOrigin = addPlaceholder(name.."_origin", {0, shift_y}, origin_name, controllers)
	
	-- 0 - left side of the pitch line, 1 - right side respectively
	for i = 0, 1 do
		local side
		local side_name
		if i == 0 then
			side = -1
			side_name = "left"
		else
			side = 1
			side_name = "right"
		end

		local tick_rot
		if shift_y < 0 then
			-- negative pitch
			tick_rot = 0
		else
			-- positive pitch
			tick_rot = 180
		end
		
		local pitchLimited
		if pitch > 90 then
			-- above 90 degrees
			pitchLimited = pitch - 180
			tick_rot = 0
		elseif pitch < -90 then
			-- below -90 degrees
			pitchLimited = pitch + 180
			tick_rot = 180
		else
			pitchLimited = pitch
		end
		
		local length	= width
		local lineRot	= 0
		-- each pitch line is rotated by the pitch / 2 angle
		if pitchLimited < 0 then
			lineRot = pitchLimited / 2
			length     = width / math.cos(math.rad(lineRot))
		end

		addStrokeLine(name.."_hor_"..side_name, length, {half_gap * side, 0}, (lineRot - 90) * side, lineOrigin.name, nil, shift_y < 0, PL_negline_stroke, PL_negline_gap)
		if tick > 0 then
			addStrokeLine(name.."_tick_"..side_name, tick, {half_gap * side, 0}, tick_rot, lineOrigin.name)
		end
		
		if shift_y ~= 0 then
			local text_shift_y
			-- pitch numerics text is inverted below -90 and above 90 degrees
			local inverted
			if shift_y < 0 then
				if pitch > -90 then
					inverted = false
					text_shift_y = PL_text_shift_y + length * math.sin(math.rad(lineRot))
				else
					inverted = true
					text_shift_y = -PL_text_shift_y - length * math.sin(math.rad(lineRot))
				end
			else
				if pitch < 90 then
					inverted = false
					text_shift_y = -PL_text_shift_y - length * math.sin(math.rad(lineRot))
				else
					inverted = true
					text_shift_y = PL_text_shift_y + length * math.sin(math.rad(lineRot))
				end
			end
			
			local textAlign
			if side < 0 then
				if inverted == false then
					textAlign = "RightCenter"
				else
					textAlign = "LeftCenter"
				end
			else
				if inverted == false then
					textAlign = "LeftCenter"
				else
					textAlign = "RightCenter"
				end
			end
			
			local pitchToPrint
			if pitchLimited < 0 then
				pitchToPrint = -pitchLimited
			else
				pitchToPrint = pitchLimited
			end
			
			local text = addStrokeText(name.."_numerics_"..side_name, ""..pitchToPrint, STROKE_FNT_DFLT_75, textAlign, {(half_gap + width + PL_text_shift_x) * side, text_shift_y}, lineOrigin.name)
			
			if inverted == true then
				text.init_rot = {180}
			end
			
		end
	end
end

-- Ghost horizon
-- ghost horizon is dashed
local PL_ghostHor_stroke			= 20
local PL_ghostHor_gap				= 20

function add_PL_GhostHorizon(name, length, half_gap, controllers, pos)
	local lineOrigin = addPlaceholder(name.."_origin", pos, nil, controllers)
	-- 0 - left side of the pitch line, 1 - right side respectively
	for i = 0, 1 do
		local side
		local side_name
		if i == 0 then
			side = -1
			side_name = "left"
		else
			side = 1
			side_name = "right"
		end

		addStrokeLine(name..side_name, length, {half_gap * side, 0}, -90 * side, lineOrigin.name, nil, true, PL_ghostHor_stroke, PL_ghostHor_gap)
	end
end

-- 2.5 degrees line
function add_PL_25_line(name, length, half_gap, parent, controllers, pos)
	local lineOrigin = addPlaceholder(name.."_origin", pos, parent, controllers)
	for i = 0, 1 do
		local side
		local side_name
		if i == 0 then
			side = -1
			side_name = "left"
		else
			side = 1
			side_name = "right"
		end

		addStrokeLine(name..side_name, length, {half_gap * side, 0}, -90 * side, lineOrigin.name, nil, true, PL_negline_stroke, PL_negline_gap)
	end
end

-- Debug grid
function draw_dbg_grid(step, halfWidth, material)
	local lines_count = math.ceil(halfWidth / step)
	
	for i = 1, lines_count do
		addStrokeLine("grid_line_v_"..i,  halfWidth * 2, { step * (i-1), -halfWidth}, 0, nil, nil, nil, nil, nil, material)
		addStrokeLine("grid_line_v2_"..i, halfWidth * 2, {-step * (i-1), -halfWidth}, 0, nil, nil, nil, nil, nil, material)
		addStrokeLine("grid_line_h_"..i,  halfWidth * 2, {-halfWidth,  step * (i-1)}, -90, nil, nil, nil, nil, nil, material)
		addStrokeLine("grid_line_h2_"..i, halfWidth * 2, {-halfWidth, -step * (i-1)}, -90, nil, nil, nil, nil, nil, material)
	end
end

-- SPI symbol
function addSpiSymbols()

	addStrokeLine("Target Line", 45, {0, boresightShiftY}, 0, nil, {{"HUD_TargetLine"}})

	local TGT = addStrokeBox("TGT", 10, 10, "CenterCenter", nil, nil, {{"HUD_TGT_Show"}})
	addStrokeCircle("Target dot", 0.1, nil, TGT.name)
	add_X_Over("TGT X", 10, 10, nil, TGT.name, {{"HUD_TGT_Limit"}})

	local TGT_Mask = openMaskArea(0, "TGT_Mask", nil, nil, nil, TGT.name)
	set_box_w_h(TGT_Mask, 10, 10)

	-- Rhombus - STPT, STR, RP, IP point
	local Rhombus_PH = addPlaceholder("Rhombus PH", nil, nil, {{"HUD_Rhombus_Symbol"}})
	local Rhombus_Sym = addStrokeBox("Reference point", 6, 6, "CenterCenter", nil, Rhombus_PH.name)
	Rhombus_Sym.init_rot	= {45}
	add_X_Over("Rhombus X", 7, 7, nil, Rhombus_PH.name, {{"HUD_Rhombus_Limit"}})

	local Rhombus_Mask = openMaskArea(0, "Rhombus_Mask", nil, nil, nil, Rhombus_PH.name)
	set_box_w_h(Rhombus_Mask, 7, 7)
	Rhombus_Mask.init_rot	= {45}

	-- Pull up point (PUP)
	local PUP_Sym = addStrokeCircle("Pull up point", 8, nil, nil, {{"HUD_PUP_Symbol"}})
	add_X_Over("Pull up point X", 9, 9, nil, PUP_Sym.name, {{"HUD_PUP_Limit"}})

	-- TODO Offset aimpoint

	closeMaskArea(1, "Rhombus_Mask_Close", Rhombus_Mask.vertices, Rhombus_Mask.indices, Rhombus_Mask.init_pos)
	closeMaskArea(1, "TGT_Mask_Close", TGT_Mask.vertices, TGT_Mask.indices, TGT_Mask.init_pos)
end

-- Azimuth Steering Line
function addAzimuthSteeringLine(name, controllers)
	local FPM_ASL_root = addPlaceholder(name.."_HUD_ASL_root", {0, 0}, nil, {{"HUD_FPM_Pos"}})
	local ASL_root = addPlaceholder(name.."_ASL_root", {0, 0}, FPM_ASL_root.name, controllers)
	addStrokeLine(name.."_Azimuth_Steering_Line_Top", 500, nil, 0, ASL_root.name)
	addStrokeLine(name.."_Azimuth_Steering_Line_Down", 500, nil, 180, ASL_root.name)
	return ASL_root
end
