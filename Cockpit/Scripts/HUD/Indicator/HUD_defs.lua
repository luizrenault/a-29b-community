dofile(LockOn_Options.common_script_path .. "elements_defs.lua")
dofile(LockOn_Options.script_path .. "materials.lua")
dofile(LockOn_Options.script_path .."HUD/HUD_ID_defs.lua")

local page_root_name = nil



-- 1mrad=0.001radian=0.0573degrees
SetScale(MILLYRADIANS)
--SetScale(FOV)

-- 15.2 deg x 17 deg
HUD_HALF_WIDTH  = math.rad(15.2) * 1000
HUD_HALF_HEIGHT = math.rad(17.0) * 1000

-- 角度/弧度换算
DEGREE_TO_MRAD = 17.4532925199433
DEGREE_TO_RAD  = 0.0174532925199433
RAD_TO_DEGREE  = 57.29577951308233
MRAD_TO_DEGREE = 0.05729577951308233

-- 默认clip层
HUD_DEFAULT_LEVEL     = 9
HUD_NOCLIP_LEVEL      = HUD_DEFAULT_LEVEL - 1

INDTEXTURE_PATH       = IND_TEX_PATH

HUD_IND_COLOR         = materials["HUD_IND_DEF"]
HUD_IND_COLOR_R       = materials["HUD_IND_RED"]
HUD_IND_COLOR_G       = materials["HUD_IND_GREEN"]
HUD_IND_COLOR_B       = materials["HUD_IND_BLUE"]
HUD_IND_COLOR_W       = materials["HUD_IND_WHITE"]
HUD_IND_COLOR_D       = materials["HUD_IND_DARK"]
HUD_IND_COLOR_HIDE    = materials["HUD_IND_HIDE"]



HUD_MAT_DEF       = "hud_mesh_def"
HUD_MAT_BASE1     = "hud_mesh_base1"
HUD_MAT_BASE2     = "hud_mesh_base2"

HUD_TEX_IND1      = "hud_tex_ind1"
HUD_TEX_IND1_R    = "hud_tex_ind1_r"
HUD_TEX_IND1_Y    = "hud_tex_ind1_y"

HUD_TEX_CLIP      = "hud_tex_clip"

HUD_TEX_IND2      = "hud_tex_ind2"
HUD_TEX_IND2_R    = "hud_tex_ind2_r"
HUD_TEX_IND2_Y    = "hud_tex_ind2_y"

HUD_LINE_DEF      = "hud_line_dashed_def"

--[[
local font_desc = fontdescription["a29b_font_hud"]
HUD_IND_FONT    = MakeFont(font_desc, HUD_IND_COLOR,   "HUD_IND_FONT")
HUD_IND_FONT_R  = MakeFont(font_desc, HUD_IND_COLOR_R, "HUD_IND_FONT_R")
HUD_IND_FONT_G  = MakeFont(font_desc, HUD_IND_COLOR_G, "HUD_IND_FONT_G")
HUD_IND_FONT_B  = MakeFont(font_desc, HUD_IND_COLOR_B, "HUD_IND_FONT_B")
HUD_IND_FONT_W  = MakeFont(font_desc, HUD_IND_COLOR_W, "HUD_IND_FONT_W")
]]

HUD_IND_FONT    = "hud_font_def"
HUD_IND_FONT_G  = "hud_font_g"
HUD_IND_FONT_B  = "hud_font_b"
HUD_IND_FONT_W  = "hud_font_w"
HUD_IND_FONT_R  = "hud_font_r"


local fontscale = 1 -- 0.75

HUD_FONT_W = 0.0045 * 144 / 128 * 1.27
HUD_FONT_H = fontscale * HUD_FONT_W

HUD_STRINGDEFS_DEF     = {HUD_FONT_W, HUD_FONT_H, HUD_FONT_W * 0.032625, 0}
HUD_STRINGDEFS_DEF_X08 = {0.8 * HUD_FONT_W, 0.8 * HUD_FONT_H, 0, 0}
HUD_STRINGDEFS_DEF_X15 = {1.5 * HUD_FONT_W, 1.5 * HUD_FONT_H, 0, 0}
HUD_STRINGDEFS_DEF_X20 = {2.0 * HUD_FONT_W, 2.0 * HUD_FONT_H, 0, 0}


DEF_BOX_INDICES = { 0,1,2, 0,2,3 }

fpm_name = "hud_fpm"

HUD_TEX_IND1_W  = 1200
HUD_TEX_IND1_H  = 1200
HUD_TEX_IND2_W  = 1200
HUD_TEX_IND2_H  = 1200

MIL2MMIL = 1000
MMIL2MIL = 0.001

horizon_offset   = -0.0 * DEGREE_TO_MRAD
vert_bias        = -1.5 * DEGREE_TO_MRAD
center_vert_bias = -4.0 * DEGREE_TO_MRAD

general_vert_bias = -54.118
spd_bar_vert_bias = general_vert_bias
alt_bar_vert_bias = general_vert_bias
hdg_bar_vert_bias =  16.198


collimated = true


HDG_origin_pos	= 130

-- Set screen units and indicator scale

-- MFD screen units definitions, also units conversion
-- PX - F-16 - raster indicator pixel

function roundDI(value)
	if value > 0 then
		return math.floor(value + 0.5)
	else
		return math.ceil(value - 0.5)
	end
end

MeterToIn					= 39.3701
InToMeter					= 1 / MeterToIn

local PixelsPerSide			= 480
local HalfPixelsPerSide		= PixelsPerSide / 2

local ScreenSizeInch		= 4		-- inches

-- Currently this values are used
local PXtoIn_		= ScreenSizeInch / PixelsPerSide
local InToPX_		= 1.0 / PXtoIn_

local DegToRad_		= math.rad(1)
local RadToDeg_		= 1.0 / DegToRad_

local DegToMil_		= math.rad(1) * 1000
local MilToDeg_		= 1.0 / DegToMil_

local RadToMil_		= 1000
local MilToRad_		= 1.0 / RadToMil_

-- PX is a pixel in MFD indicators.
function PXtoIn(param) return (param or 1) * PXtoIn_ end						-- PX to inches
function InToPX(param) return (param or 1) * InToPX_ end						-- inches to PX

function DegToRad(param) return (param or 1) * DegToRad_ end
function RadToDeg(param) return (param or 1) * RadToDeg_ end

function DegToMil(param) return (param or 1) * DegToMil_ end
function MilToDeg(param) return (param or 1) * MilToDeg_ end

function RadToMil(param) return (param or 1) * RadToMil_ end
function MilToRad(param) return (param or 1) * MilToRad_ end



function AddElementObject(object)
    if not object.name or string.len(object.name) < 1 then
        object.name = create_guid_string()
    end
    
    if (type(object.stringdefs) ~= "table") or (next(object.stringdefs) == nil) then
        object.stringdefs   = HUD_STRINGDEFS_DEF
    end
    
    if (not object.level) or (object.level < HUD_DEFAULT_LEVEL) then
        object.level        = HUD_DEFAULT_LEVEL
    end
    
    -- object.h_clip_relation  = h_clip_relations.COMPARE
    object.isdraw           = true
    object.isvisible        = true
    object.use_mipfilter    = true
    object.additive_alpha   = true
    object.collimated       = true
    Add(object)
end

function HUD_tex_coord(UL_X,UL_Y,W,H,SZX,SZY)
    local ux = UL_X / SZX
    local uy = UL_Y / SZY
    local w  = W / SZX
    local h  = H / SZY
    return {{ux + w, uy},
            {ux + w, uy + h},
            {ux    , uy + h},
            {ux    , uy}}
end

function SetMeshCircle(object, radius, numpts)
    local verts = {}
    local inds = {}

    step = math.rad(360.0/numpts)
    for i = 1, numpts do
        verts[i] = {radius * math.cos(i * step), radius * math.sin(i * step)}
    end

    j = 0
    for i = 0, 29 do
        j = j + 1
        inds[j] = 0
        j = j + 1
        inds[j] = i + 1
        j = j + 1
        inds[j] = i + 2
    end

    object.vertices = verts
    object.indices  = inds

end

function AddHUDElement(object)
    object.use_mipfilter      = true
    object.h_clip_relation    = h_clip_relations.COMPARE  
    object.level              = HUD_DEFAULT_LEVEL
    object.additive_alpha     = true --additive blending 
    object.collimated         = true
    Add(object)
end

function AddToFPM(elem)
    elem.parent_element = fpm_name
    AddHUDElement(elem)
    return elem
end

function AddToGunCross(elem)
    --elem.parent_element  = "hud_gun_cross"
    AddHUDElement(elem)
    return elem
end

-------------------------








-- Stroke symbol with points described in a .svg file
function addStrokeSymbol(name, set, align, pos, parent, controllers, scale, material)
	local symbol		= CreateElement "ceSMultiLine"
	setSymbolCommonProperties(symbol, name, pos, parent, controllers, material)
	setSymbolAlignment(symbol, align)
	setStrokeSymbolProperties(symbol)
	symbol.points_set	= set
    symbol.scale		= scale or 1
    symbol.collimated   = true -- Added
	Add(symbol)
	return symbol
end



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
	addStrokeCircle("HUD_Roll_Indicator_Arc", radius-longLine, {0,0}, parent, nill, { math.rad(-45), math.rad(-135)})
end

-- Pitch Ladder (PL) line
-- text shift (x, y) from the horizontal line end
local PL_text_shift_x				= 2
local PL_text_shift_y				= 0
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
		local ydev		= 0
		local lineRot	= 0
		-- each pitch line is rotated by the pitch / 2 angle
		if pitchLimited < 0 then
			lineRot = pitchLimited / 2
			length     = width / math.cos(math.rad(lineRot))
			ydev       = width * math.sin(math.rad(lineRot))
		end

		addStrokeLine(name.."_hor_"..side_name, length, {half_gap * side, 0}, (lineRot - 90) * side, lineOrigin.name, nil, shift_y < 0, PL_negline_stroke, PL_negline_gap)
		if tick > 0 then
			addStrokeLine(name.."_tick_"..side_name, tick, {(half_gap + length) * side, ydev}, tick_rot, lineOrigin.name)
		end
		
		if shift_y ~= 0 and pitch ~= 0 then
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
	return lineOrigin
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
	return lineOrigin
end

function create_page_root()
    local page_root = addPlaceholder("HUD_PageRoot", {0,0})
    page_root_name = page_root.name
	page_root.element_params = {"HUD_ON", "HUD_BRIGHT"}
	page_root.controllers = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}
    return page_root
end


