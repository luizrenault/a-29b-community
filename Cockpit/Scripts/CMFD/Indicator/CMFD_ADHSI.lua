dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "Systems/avionics_api.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

DEFAULT_LEVEL = 9
default_material = CMFD_FONT_DEF
stroke_font			= "cmfd_font_def"
stroke_material		= "HUD"
stroke_thickness  = 1 --0.25
stroke_fuzziness  = 0.6
additive_alpha		= true
default_element_params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}
default_controllers={{"opacity_using_parameter", 0}}

local page_root = create_page_root()
page_root.element_params = {"CMFD"..CMFDNu.."Format"}
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.ADHSI}}
default_parent      = page_root.name


local aspect = GetAspect()

local object

-- MODE
object = addStrokeText("ADHSI_MODE_EGI", "EGI", CMFD_STRINGDEFS_DEF_X1, "CenterCenter", {-0.87, 0.63}, nil, nil,nil, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.EGI}}
object = addStrokeText("ADHSI_MODE_VOR", "VOR", CMFD_STRINGDEFS_DEF_X1, "CenterCenter", {-0.87, 0.63})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.VOR}}
object = addStrokeText("ADHSI_MODE_GPS", "GPS", CMFD_STRINGDEFS_DEF_X1, "CenterCenter", {-0.87, 0.63}, nil, nil,nil, CMFD_FONT_B)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.GPS}}
object = addStrokeText("ADHSI_MODE_ILS", "ILS", CMFD_STRINGDEFS_DEF_X1, "CenterCenter", {-0.87, 0.63}, nil, nil,nil, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.ILS}}

-- Digital Speed
object = addStrokeText("ADHSI_IAS", "210", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.555, 1.09}, nil, nil, {"%03.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_IAS"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox("ADHSI_IAS_BOX", 0.144, 0.076, "CenterCenter", {0, 0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- Digital Altitude
object = addStrokeText("ADHSI_ALT", "5960", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.615, 1.09}, nil, nil, {"%5.0f'"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ALT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox("ADHSI_ALT_BOX", 0.24, 0.076, "CenterCenter", {-0.01, 0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- RALT
object = addStrokeText("ADHSI_RALT_TEXT", "RALT", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.667, 0.34})
object = addStrokeText("ADHSI_RALT", "9999", CMFD_STRINGDEFS_DEF_X08, "RightCenter", {0.95, 0.34}, nil, nil, {"%03.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_RALT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"parameter_in_range",1,-0.05,5005}}
object = addStrokeText("ADHSI_RALT_XXXX", "XXXX", CMFD_STRINGDEFS_DEF_X08, "RightCenter", {0.95, 0.34})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_RALT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,-1}}

-- VV
object = addStrokeText("ADHSI_VV_TEXT", "VV", CMFD_STRINGDEFS_DEF_X1, "CenterCenter", {0.877, 0.7}, nil, nil,nil, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addStrokeBox("ADHSI_VV_BOX", 0.147, 0.088, "CenterCenter", {0, 0}, object.name, nil, CMFD_MATERIAL_WHITE)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_VV"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- VV scale
local vvScale500ftStep		    = 0.05
local vvScaleLongTickLen		= 0.05
local vvScaleShortTickLen		= 0.025
local UnitsPerOneFeetPerMin		= 3 * vvScale500ftStep / 20000 -- don't know why

local VVScale_origin = addPlaceholder("ADHSI_VVScale_origin", {0.45, 0.665})
VVScale_origin.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_VV"}
VVScale_origin.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number",1,1} }

local VVScale_origin_indicator = addPlaceholder("VVScale_origin_indicator", {0.17, 0}, VVScale_origin.name)
VVScale_origin_indicator.element_params = {"ADHSI_VV_LIM"}
VVScale_origin_indicator.controllers = {{"move_up_down_using_parameter", 0, UnitsPerOneFeetPerMin}}

object = addFillArrowBox("ADHSI_VV_MBOX", 0.224, 0.064, "CenterCenter", {0, 0}, VVScale_origin_indicator.name, nil, CMFD_MATERIAL_CYAN)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addStrokeText("ADHSI_VV", "VV", CMFD_STRINGDEFS_DEF_X06, "CenterCenter", {0, 0}, VVScale_origin_indicator.name, nil,{" %+4.0f"}, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_VV"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}


addStrokeLine("VVScaleTickLong_0", vvScaleLongTickLen, {0, 0}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)
addStrokeLine("VVScaleTickLong_1", vvScaleLongTickLen, {0, 2*vvScale500ftStep}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)
addStrokeLine("VVScaleTickLong_2", vvScaleLongTickLen, {0, 4*vvScale500ftStep}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)
addStrokeLine("VVScaleTickLong_3", vvScaleLongTickLen, {0, -2*vvScale500ftStep}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)
addStrokeLine("VVScaleTickLong_4", vvScaleLongTickLen, {0, -4*vvScale500ftStep}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)

addStrokeLine("VVScaleTickShort_0", vvScaleShortTickLen, {0, vvScale500ftStep}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)
addStrokeLine("VVScaleTickShort_1", vvScaleShortTickLen, {0, 3*vvScale500ftStep}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)
addStrokeLine("VVScaleTickShort_2", vvScaleShortTickLen, {0, -vvScale500ftStep}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)
addStrokeLine("VVScaleTickShort_3", vvScaleShortTickLen, {0, -3*vvScale500ftStep}, -90, VVScale_origin.name, nil, nil, nil, nil, CMFD_MATERIAL_WHITE)

addStrokeText("VVScaleNumerics_0", "0", CMFD_STRINGDEFS_DEF_X07, "RightCenter", {-0.01, 0}, VVScale_origin.name, nil, nil, CMFD_FONT_W)
addStrokeText("VVScaleNumerics_1", "1", CMFD_STRINGDEFS_DEF_X07, "RightCenter", {-0.01, 2*vvScale500ftStep}, VVScale_origin.name, nil, nil, CMFD_FONT_W)
addStrokeText("VVScaleNumerics_2", "2", CMFD_STRINGDEFS_DEF_X07, "RightCenter", {-0.01, 4*vvScale500ftStep}, VVScale_origin.name, nil, nil, CMFD_FONT_W)
addStrokeText("VVScaleNumerics_3", "-1", CMFD_STRINGDEFS_DEF_X07, "RightCenter", {-0.01, -2*vvScale500ftStep}, VVScale_origin.name, nil, nil, CMFD_FONT_W)
addStrokeText("VVScaleNumerics_4", "-2", CMFD_STRINGDEFS_DEF_X07, "RightCenter", {-0.01, -4*vvScale500ftStep}, VVScale_origin.name, nil, nil, CMFD_FONT_W)


-- DA
object = addStrokeText("ADHSI_DA", "DA", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.735, 0.965}, nil, nil,{"DA %5.0f"}, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "UFCP_DA"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

-- DH
object = addStrokeText("ADHSI_DA", "DA", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.735, 0.21}, nil, nil,{"DH %5.0f"}, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "UFCP_DH"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}


-- Digital Heading
object = addStrokeText("ADHSI_HDG", "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.02, 1.22}, nil, nil, {"%03.0f`"}, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_HDG"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"parameter_in_range", 1, -0.05, 360.05}}
object = addStrokeText("ADHSI_NOHDG", "XXX", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.02, 1.22}, nil, nil, nil, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_HDG"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, -1}}
object = addStrokeBox("ADHSI_HDG_BOX", 0.16, 0.084, "CenterCenter", {-0.02, 1.22}, nil, nil, CMFD_MATERIAL_WHITE)


-- AP
object = addStrokeText("ADHSI_AP_TEXT", "AP", CMFD_STRINGDEFS_DEF_X1, "CenterCenter", {-0.865, 0.858})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_AP"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AP ROL
object = addStrokeText("ADHSI_ROL_TEXT", "ROL", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.552, 1.226})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_AP_ROL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AP HDG
object = addStrokeText("ADHSI_HDG_TEXT", "HDG", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.552, 1.226})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_AP_HDG"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AP PIT
object = addStrokeText("ADHSI_PIT_TEXT", "PIT", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.563, 1.226})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_AP_PIT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AP ALT
object = addStrokeText("ADHSI_ALT_TEXT", "ALT", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.563, 1.226})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_AP_ALT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AP NAV
object = addStrokeText("ADHSI_NAV_TEXT", "NAV", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.714, 1.226}, nil, nil, nil, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_AP_NAV"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AP LOC
object = addStrokeText("ADHSI_LOC_TEXT", "LOC", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.714, 1.226}, nil, nil, nil, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_AP_LOC"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AP GS
object = addStrokeText("ADHSI_GS_TEXT", "GS", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.715, 1.226}, nil, nil, nil, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_AP_GS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AP BCN
object = addStrokeText("ADHSI_BCN_TEXT", "BCN", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.785, 0.251})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_BCN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

object = addStrokeCircle("ADHSI_BCN_CIRCLE",0.05 , {-0.62, 0.245})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_BCN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

object = addStrokeText("ADHSI_BCN_CIRCLE_H_TEXT", "H", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.62, 0.245})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_BCN_H"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

object = addStrokeText("ADHSI_BCN_CIRCLE_L_TEXT", "L", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.62, 0.245})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_BCN_L"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- Attitude indicator
-- Pitch Ladder (PL)
local PL_pitch_line_width			= 0.2
local PL_pitch_line_step			= 0.015

local AD_origin = addPlaceholder("ADHSI_AD_origin", {-0.02, 0.7})

object = addStrokeCircleBox("ADHSI_AD_Frame", 0.52, {0,-0.1}, AD_origin.name, nil, {math.rad(45),math.rad(135)}, nil, nil, nil, CMFD_MATERIAL_WHITE)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object.h_clip_relation = h_clip_relations.REWRITE_LEVEL


object = addMeshCircleBox("ADHSI_AD_Frame_Clip", 0.519 , {0,-0.1}, AD_origin.name, nil, {math.rad(45),math.rad(135)}, nil, nil, nil, CMFD_MATERIAL_WHITE)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object.isvisible = false
object.h_clip_relation = h_clip_relations.INCREASE_IF_LEVEL

local PL_origin = addPlaceholder("ADHSI_PL_origin", {0, 0}, AD_origin.name)
PL_origin.element_params = {"ADHSI_ROLL", "ADHSI_PITCH"}
PL_origin.controllers = {{"rotate_using_parameter",0, 1 }, {"move_up_down_using_parameter",1,-PL_pitch_line_step*4.15} }

object = addFillBox("ADHSI_AD_Ground", 6*PL_pitch_line_width, 120 * PL_pitch_line_step, "CenterCenter", {0,-60*PL_pitch_line_step}, PL_origin.name, nil, CMFD_MATERIAL_GRND)
setClipLevel(object, 1)
object = addFillBox("ADHSI_AD_Sky", 6*PL_pitch_line_width, 120 * PL_pitch_line_step, "CenterCenter", {0, 60*PL_pitch_line_step}, PL_origin.name, nil, CMFD_MATERIAL_SKY)
setClipLevel(object, 1)

-- -85 to +85 degrees
local counterBegin = -110
local counterEnd   = -counterBegin
for i = counterBegin, counterEnd, 5 do
    local material = "CMFD_IND_WHITE" 
    local font = CMFD_FONT_W
    if i <  0 then 
        material = "CMFD_IND_BLACK"
        font = CMFD_FONT_K
    end
if i % 10 == 5 then 
        object = addStrokeLine("ADHSI_pitch_line_"..i, PL_pitch_line_width/2, {-PL_pitch_line_width/4, i * PL_pitch_line_step},  -90, PL_origin.name, nil, nil, nil, nil, material)
        setClipLevel(object, 1)
    else 
        if i ~= 0 and i ~= 90 and i ~= -90 then 
            local text = math.abs(i)
            if text > 90 then text = 90 - text % 90 end
            object = addStrokeLine("ADHSI_pitch_line_"..i, PL_pitch_line_width, {-PL_pitch_line_width/2, i * PL_pitch_line_step},  -90, PL_origin.name, nil, nil, nil, nil, material) 	
            setClipLevel(object, 1)
            object = addStrokeText("ADHSI_pitch_line_text_left"..i, text, CMFD_STRINGDEFS_DEF_X07, "CenterCenter", {-PL_pitch_line_width / 1.4, i * PL_pitch_line_step}, PL_origin.name, nil, "%2.0f", font)
            setClipLevel(object, 1)
            if i > 90 or i < -90 then object.init_rot = {180} end
            object = addStrokeText("ADHSI_pitch_line_text_right"..i, text, CMFD_STRINGDEFS_DEF_X07, "CenterCenter", {PL_pitch_line_width / 1.4, i * PL_pitch_line_step}, PL_origin.name, nil, "%2.0f", font)
            setClipLevel(object, 1)
            if i > 90 or i < -90 then object.init_rot = {180} end
        elseif i == 0 then 
            object = addStrokeLine("ADHSI_pitch_line_"..i, 6 * PL_pitch_line_width, {-PL_pitch_line_width*3, i * PL_pitch_line_step},  -90, PL_origin.name, nil, nil, nil, nil, material) 	
            setClipLevel(object, 1)
        end
    end
end
object = addStrokeCircle("ADHSI_pitch_circle", 2 * PL_pitch_line_step, {0, -90 * PL_pitch_line_step}, PL_origin.name, nil, nil, nil, nil, nil,  CMFD_MATERIAL_DARK)
setClipLevel(object, 1)


-- Roll indicator
local ADHSI_AD_RI_Scale_origin = addPlaceholder("ADHSI_AD_RI_Scale_origin", {0,-0.1}, AD_origin.name)
ADHSI_AD_RI_Scale_origin.element_params = {"ADHSI_ROLL"}
ADHSI_AD_RI_Scale_origin.controllers = {{"rotate_using_parameter",0, 1 }}
object = addFillBox("ADHSI_AD_RI_0", 0.02, 0.08, "CenterCenter", {0, 0.51}, ADHSI_AD_RI_Scale_origin.name, nil, "CMFD_IND_BLACK")
object.vertices = {{-0.01, 0}, {0.01, 0}, {0,-0.06}}
object.indices = {0, 1, 2}
setClipLevel(object, 1)
local angles = {10, 20, 30, 45, 60}
local tracewidth
for i=1, #angles do
    local angle = angles[i]
    if angle == 30 or angle == 60 then tracewidth = 0.08 else tracewidth = 0.04 end
    object = addStrokeLine("ADHSI_AD_RI_" .. angle, tracewidth, {0.51 * math.cos(math.rad(angle+90)), 0.51 * math.sin(math.rad(angle+90))}, 180+angle,  ADHSI_AD_RI_Scale_origin.name,nil, nil, nil, nil, "CMFD_IND_BLACK")
    setClipLevel(object, 1)
    object = addStrokeLine("ADHSI_AD_RI_M" .. angle, tracewidth, {0.51 * math.cos(math.rad(-angle+90)), 0.51 * math.sin(math.rad(-angle+90))}, 180-angle,  ADHSI_AD_RI_Scale_origin.name,nil, nil, nil, nil, "CMFD_IND_BLACK")
    setClipLevel(object, 1)

end



-- TURN RATE
object = addMesh("ADHSI_TURN_RATE", nil, nil, {-0.03, -0.45}, "triangles", nil , nil, "CMFD_IND_WHITE")
SetCircleMeshStartEnd(object, 0.61, 0.58, 90-7.5/2, 7.5)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_TURN_RATE", "ADHSI_TURN_RATE_ON"}
object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 1, 1}, {"parameter_compare_with_number", 2, 1}}



------------------- HSI
stroke_thickness  = 0.25 --0.25
stroke_fuzziness  = 0.3
local HSI_radius = 0.445
local HSI_tick_lenght = 0.035

local HSI_Origin = addPlaceholder("HSI_Origin", {-0.0026, -0.61})
local HSI_Origin_Rot = addPlaceholder("HSI_Origin_Rot", {0,0}, HSI_Origin.name)
HSI_Origin_Rot.element_params = {"AVIONICS_HDG"}
HSI_Origin_Rot.controllers = {{"rotate_using_parameter", 0, math.rad(1)}}

for i = 0, 350, 10 do
    if i % 30 ~= 0 then
        object = addStrokeLine("HSI_tick_"..i, HSI_tick_lenght, {HSI_radius * math.sin(math.rad(i)), HSI_radius * math.cos(math.rad(i))}, -i, HSI_Origin_Rot.name, nil, nil, nil, nil, "CMFD_IND_WHITE")
    else
        local text
        if i == 0 then text = "N"
        elseif i == 90 then text = "E"
        elseif i == 180 then text = "S"
        elseif i == 270 then text = "W"
        else text = string.format("%02.0f", i/10)
        end
        object = addStrokeText("HSI_text_"..i, text, CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {(HSI_radius+HSI_tick_lenght/2) * math.sin(math.rad(i)), (HSI_radius+HSI_tick_lenght/2) * math.cos(math.rad(i))}, HSI_Origin_Rot.name, nil, {"%s"},CMFD_FONT_W)
        object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_HDG"}
        object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 1, -math.rad(1)}}
    end
end
-- COURSE BOX
stroke_thickness  = 0.5 --0.25
stroke_fuzziness  = 0.6
object = addStrokeBox("HSI_Course_box", 0.1755, 0.1855, "CenterCenter", {0.64, -0.95})
object = addStrokeText("HSI_Course_text", "CRS\n057`", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0,0}, object.name, nil, {"CRS\n%03.0f`"},CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_COURSE"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

-- DTK
object = addStrokeText("HSI_DTK_text", "DTK\n270`\n27.5", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.892,-0.95}, nil, nil, {"DTK\n%03.0f`\n", "%2.1f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_DTK_HDG", "ADHSI_DTK_DIST"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range",1 , -0.05, 360.05}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 2, 1}}

object = addStrokeText("HSI_NODTK_text", "DTK\nXXX`\nX.X", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.892,-0.95})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_DTK_HDG", "ADHSI_DTK_DIST"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, -1} }

object = addStrokeBox("HSI_DTK_box", 0.1755, 0.1855, "CenterCenter", {0.892,-0.95})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_DTK"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}


-- RAD SEL
object = addStrokeText("HSI_RAD_SEL_text", "RAD\n20", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.877, -0.560}, nil, nil, {"RAD\n%3.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_RAD_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

-- HDG SEL
object = addStrokeText("HSI_HDG_SEL_text", "HDG\n057", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.895, -0.560}, nil, nil, {"HDG\n%03.0f"},CMFD_FONT_CYAN)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_HDG_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
stroke_thickness  = 1.5 --0.25
stroke_fuzziness  = 0.6
local HSI_HDG_SEL_Origin = addPlaceholder("HSI_HDG_SEL_Origin", {0,0}, HSI_Origin_Rot.name)
HSI_HDG_SEL_Origin.element_params = {"ADHSI_HDG_SEL"}
HSI_HDG_SEL_Origin.controllers = {{"rotate_using_parameter", 0, -math.rad(1)}}
object = addStrokeBox("HSI_HDG_SEL_box", 0.06, 0.045, "CenterCenter", {0,HSI_radius + 3* HSI_tick_lenght}, HSI_HDG_SEL_Origin.name, nil, "CMFD_IND_CYAN")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addStrokeLine("HSI_HDG_SEL_line", 0.045, {0, -0.0225} , 0 , object.name, nil, nil, nil, nil, "CMFD_IND_CYAN")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- VOR Arrouw
stroke_thickness  = 1.5 --0.25
stroke_fuzziness  = 0.6
local HSI_VOR_Origin = addPlaceholder("HSI_VOR_Origin", {0,0}, HSI_Origin_Rot.name)
HSI_VOR_Origin.element_params = {"ADHSI_VOR_HDG", "AVIONICS_ANS_MODE"}
HSI_VOR_Origin.controllers = {{"rotate_using_parameter", 0, -math.rad(1)}, {"parameter_in_range",0,-0.05, 360.05}, {"parameter_in_range", 1, AVIONICS_ANS_MODE_IDS.EGI - 0.05, AVIONICS_ANS_MODE_IDS.GPS + 0.05}}
object = addStrokeBox("HSI_VOR_box", 0.02, 0.04, "CenterCenter", {0,-HSI_radius + 2* HSI_tick_lenght}, HSI_VOR_Origin.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addStrokeBox("HSI_VOR_box1", 0.03, 0.03, "CenterCenter", {0,HSI_radius - 2* HSI_tick_lenght}, HSI_VOR_Origin.name)
object.init_rot = {45}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- VOR No Signal
local HSI_VOR_RED_Origin = addPlaceholder("HSI_VOR_RED_Origin", {0,0}, HSI_Origin.name)
HSI_VOR_RED_Origin.element_params = {"ADHSI_VOR_HDG", "AVIONICS_ANS_MODE"}
HSI_VOR_RED_Origin.controllers = {{"parameter_compare_with_number",0, -1}, {"parameter_in_range", 1, AVIONICS_ANS_MODE_IDS.EGI - 0.05, AVIONICS_ANS_MODE_IDS.GPS + 0.05}}
HSI_VOR_RED_Origin.init_rot = {-90}
object = addStrokeBox("HSI_VOR_RED_box", 0.02, 0.04, "CenterCenter", {0,-HSI_radius + 2* HSI_tick_lenght}, HSI_VOR_RED_Origin.name, nil, "CMFD_IND_RED")
object = addStrokeBox("HSI_VOR_RED_box1", 0.03, 0.03, "CenterCenter", {0,HSI_radius - 2* HSI_tick_lenght}, HSI_VOR_RED_Origin.name, nil,  "CMFD_IND_RED")
object.init_rot = {45}


-- VOR DATA Indicator
object = addStrokeText("HSI_VOR_DATA_text", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.6, -0.086}, nil, nil, {"VOR\n", "%03.0f`\n", "%2.1f\n", "%02.0f:", "%02.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT",  "ADHSI_VOR_HDG", "ADHSI_VOR_DIST", "ADHSI_VOR_MIN", "ADHSI_VOR_SEC", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, -0.05, 360.05}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 1, 1}, {"text_using_parameter", 2, 2}, {"text_using_parameter", 3, 3}, {"text_using_parameter", 4, 4}, {"parameter_in_range", 5, AVIONICS_ANS_MODE_IDS.EGI - 0.05, AVIONICS_ANS_MODE_IDS.VOR + 0.05}}

object = addStrokeText("HSI_VOR_NODATA_text", "VOR\nXXX`\nX.X\nXX:XX", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.6, -0.086})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT",  "ADHSI_VOR_HDG", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, -1},  {"parameter_in_range", 2, AVIONICS_ANS_MODE_IDS.EGI - 0.05, AVIONICS_ANS_MODE_IDS.VOR + 0.05}}

-- GPS Arrow
stroke_thickness  = 1.5 --0.25
stroke_fuzziness  = 0.6
local HSI_GPS_Origin = addPlaceholder("HSI_GPS_Origin", {0,0}, HSI_Origin_Rot.name)
HSI_GPS_Origin.element_params = {"ADHSI_GPS_HDG", "AVIONICS_ANS_MODE"}
HSI_GPS_Origin.controllers = {{"rotate_using_parameter", 0, -math.rad(1)}, {"parameter_in_range",0 , -0.05, 360.05}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.GPS}}
object = addStrokeBox("HSI_GPS_box", 0.02, 0.04, "CenterCenter", {0,-HSI_radius + 2* HSI_tick_lenght}, HSI_GPS_Origin.name, nil, "CMFD_IND_BLUE")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addStrokeBox("HSI_GPS_box1", 0.03, 0.03, "CenterCenter", {0,HSI_radius - 2* HSI_tick_lenght}, HSI_GPS_Origin.name, nil, "CMFD_IND_BLUE")
object.init_rot = {45}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- GPS DATA Indicator
object = addStrokeText("HSI_GPS_DATA_text", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.6, -0.086}, nil, nil, {"GPS\n", "%03.0f`\n", "%2.1f\n", "%02.0f:", "%02.0f"}, CMFD_FONT_B)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT",  "ADHSI_GPS_HDG", "ADHSI_GPS_DIST", "ADHSI_GPS_MIN", "ADHSI_GPS_SEC", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, -0.05, 360.05}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 1, 1}, {"text_using_parameter", 2, 2}, {"text_using_parameter", 3, 3}, {"text_using_parameter", 4, 4}, {"parameter_compare_with_number", 5, AVIONICS_ANS_MODE_IDS.GPS}}
object = addStrokeText("HSI_GPS_NOATA_text", "GPS\nXXX`\nX.XX\nXX:XX", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.6, -0.086}, nil, nil, nil, CMFD_FONT_B)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT",  "ADHSI_GPS_HDG", "ADHSI_GPS_DIST", "ADHSI_GPS_MIN", "ADHSI_GPS_SEC", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, -1}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 1, 1}, {"text_using_parameter", 2, 2}, {"text_using_parameter", 3, 3}, {"text_using_parameter", 4, 4}, {"parameter_compare_with_number", 5, AVIONICS_ANS_MODE_IDS.GPS}}


-- COURSE Arrouw
stroke_thickness  = 1.5 --0.25
stroke_fuzziness  = 0.6
local HSI_COURSE_Origin = addPlaceholder("HSI_COURSE_Origin", {0,0}, HSI_Origin_Rot.name)
HSI_COURSE_Origin.element_params = {"ADHSI_COURSE"}
HSI_COURSE_Origin.controllers = {{"rotate_using_parameter", 0, -math.rad(1)}, {"parameter_in_range",0,-0.05, 360.05}}
object = addFillBox("HSI_COURSE_box", 0.02, 0.12, "CenterCenter", {0,-0.37}, HSI_COURSE_Origin.name, nil, "CMFD_IND_WHITE")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addFillBox("HSI_COURSE_box_1", 0.02, 0.12, "CenterCenter", {0,0.37}, HSI_COURSE_Origin.name, nil, "CMFD_IND_WHITE")
object.vertices = {{0,0.06}, {0.03, 0.01}, {0.01, 0.018}, {0.01,-0.06}, {-0.01, -0.06}, {-0.01, 0.018}, {-0.03, 0.01}}
object.indices = {0, 1, 2,  0, 2, 3,  0, 3, 4,  0,4,5, 0,5,6}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addFillBox("HSI_COURSE_TO_arrow", 0.02, 0.12, "CenterCenter", {0,0.2}, HSI_COURSE_Origin.name, nil, "CMFD_IND_WHITE")
object.vertices = {{0,0.06}, {0.03, -0.07}, {-0.03, -0.07}}
object.indices = {0, 1, 2}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_COURSE_TO"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}
object = addFillBox("HSI_COURSE_FROM_arrow", 0.02, 0.12, "CenterCenter", {0,-0.2}, HSI_COURSE_Origin.name, nil, "CMFD_IND_WHITE")
object.vertices = {{0,0.06}, {0.03, -0.07}, {-0.03, -0.07}}
object.indices = {0, 1, 2}
object.init_rot = {180}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_COURSE_TO"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, -1}}
-- CDI
object = addFillBox("HSI_CDI_box", 0.02, 0.6, "CenterCenter", {0,0}, HSI_COURSE_Origin.name, nil, "CMFD_IND_WHITE")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_CDI_SHOW", "ADHSI_CDI", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"move_left_right_using_parameter", 2, 1},
                        {"change_color_when_parameter_equal_to_number", 3, AVIONICS_ANS_MODE_IDS.EGI, 1,0,1},
                        {"change_color_when_parameter_equal_to_number", 3, AVIONICS_ANS_MODE_IDS.VOR, 0,1,0},
                        {"change_color_when_parameter_equal_to_number", 3, AVIONICS_ANS_MODE_IDS.GPS, 0,0,1},
                     }

stroke_thickness  = 0.5 --0.25
stroke_fuzziness  = 0.6

object = addStrokeText("HSI_CDI_text", "CDI", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.877,-0.95})
object = addStrokeBox("HSI_CDI_box1", 0.12, 0.07, "CenterCenter", {0,0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_CDI_SHOW"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}


-- FYT DTK Arrow
stroke_thickness  = 1.5 --0.25
stroke_fuzziness  = 0.6
local HSI_FYT_Origin = addPlaceholder(nil, {0,0}, HSI_Origin_Rot.name)
HSI_FYT_Origin.element_params = {"CMFD_NAV_FYT_VALID", "CMFD_NAV_FYT_DTK_BRG", "AVIONICS_ANS_MODE"}
HSI_FYT_Origin.controllers = {{"rotate_using_parameter", 1, -math.rad(1)}, {"parameter_compare_with_number", 0, 1}, {"parameter_in_range", 2, AVIONICS_ANS_MODE_IDS.EGI-0.05, AVIONICS_ANS_MODE_IDS.GPS + 0.05}}
object = addStrokeBox(nil, 0.03, 0.05, "CenterCenter", {0,-HSI_radius - 2.3* HSI_tick_lenght}, HSI_FYT_Origin.name, nil, "CMFD_IND_MAGENTA")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addStrokeBox(nil, 0.02, 0.12, "CenterCenter", {0,HSI_radius + 2.3* HSI_tick_lenght}, HSI_FYT_Origin.name, nil, "CMFD_IND_MAGENTA")
object.vertices = {{0,0.07}, {0.035, 0.02}, {0.015, 0.02}, {0.015,0}, {-0.015, 0}, {-0.015, 0.02}, {-0.035, 0.02}}
object.indices = {0,1, 1,2, 2,3, 3,4, 4,5, 5,6, 6,0}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- FYT Point

-- Outer purple circle outline
object = addStrokeCircle(nil, 0.03, {0,0}, HSI_FYT_Origin.name, nil, nil, 0.5, 0.5, false, "CMFD_IND_MAGENTA")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_FYT_DTK_DIST"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, -0.05, 1.299999}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}}
object.thickness = 0.01

-- Inner purple circle fill
object = addMesh(nil, nil, nil, {0,0}, "triangles", HSI_FYT_Origin.name, nil, "CMFD_IND_MAGENTA")
object = SetMeshCircle(object, 0.02, 10)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_FYT_DTK_DIST"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, -0.05, 1.299999}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}}

-- No DTK text
object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0,0}, HSI_FYT_Origin.name, nil, {" %02.0f"}, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT", "CMFD_NAV_FYT_DTK_BRG", "AVIONICS_HDG", "ADHSI_FYT_DTK_DIST", "ADHSI_DTK"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 5, 0}, {"text_using_parameter", 1, 0}, {"move_up_down_using_parameter", 4, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)}, }

-- DTK text
object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0,0}, HSI_FYT_Origin.name, nil, {" D"}, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT", "CMFD_NAV_FYT_DTK_BRG", "AVIONICS_HDG", "ADHSI_FYT_DTK_DIST", "ADHSI_DTK"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 5, 1}, {"text_using_parameter", 1, 0}, {"move_up_down_using_parameter", 4, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)}, }

object = addStrokeCircle(nil, 0.02, {0, 1.3 * HSI_radius}, HSI_FYT_Origin.name, nil, nil, 0.5, 0.5, true, "CMFD_IND_MAGENTA")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_FYT_DTK_DIST"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, 1.299999, 10}}
object.thickness = 0.05

-- FYT DATA
object = addStrokeText("HSI_FYT_DTK_text", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0.412,-0.086}, nil, nil, {"FT %02.0f\n", "%03.0f`\n", "%2.1f\n", "%02.0f:", "%02.0f"}, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_VALID", "CMFD_NAV_FYT", "CMFD_NAV_FYT_DTK_BRG_TEXT", "CMFD_NAV_FYT_DTK_DIST", "CMFD_NAV_FYT_DTK_MINS", "CMFD_NAV_FYT_DTK_SECS", "ADHSI_DTK"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 7, 0}, {"text_using_parameter", 2, 0}, {"text_using_parameter", 3, 1}, {"text_using_parameter", 4, 2}, {"text_using_parameter", 5, 3}, {"text_using_parameter", 6, 4}}
object = addStrokeText("HSI_NO_FYT_DTK_text", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0.412,-0.086}, nil, nil, {"FT %02.0f\nXXX`\nX.X\nXX:XX"}, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_VALID", "CMFD_NAV_FYT", "ADHSI_DTK"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, -0}, {"parameter_compare_with_number", 3, 0}, {"text_using_parameter", 2, 0}}

-- DTK DATA
object = addStrokeText("HSI_FYT_DTK_text1", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0.412,-0.086}, nil, nil, {"D- %02.0f\n","%03.0f`\n", "%2.1f\n", "%02.0f:", "%02.0f"}, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_VALID", "CMFD_NAV_FYT", "CMFD_NAV_FYT_DTK_BRG_TEXT", "CMFD_NAV_FYT_DTK_DIST", "CMFD_NAV_FYT_DTK_MINS", "CMFD_NAV_FYT_DTK_SECS", "ADHSI_DTK"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 7, 1}, {"text_using_parameter", 2, 0}, {"text_using_parameter", 3, 1}, {"text_using_parameter", 4, 2}, {"text_using_parameter", 5, 3}, {"text_using_parameter", 6, 4}}
object = addStrokeText("HSI_NO_FYT_DTK_text1", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0.412,-0.086}, nil, nil, {"D- %02.0f\nXXX`\nX.X\nXX:XX"}, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_VALID", "CMFD_NAV_FYT", "ADHSI_DTK"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}, {"parameter_compare_with_number", 3, 1}, {"text_using_parameter", 2, 0}}


-- ADF
stroke_thickness  = 1.5 --0.25
stroke_fuzziness  = 0.6
local HSI_ADF_Origin = addPlaceholder("HSI_ADF_Origin", {0,0}, HSI_Origin_Rot.name)
HSI_ADF_Origin.element_params = {"ADHSI_ADF_HDG"}
HSI_ADF_Origin.controllers = {{"rotate_using_parameter", 0, -math.rad(1)}, {"parameter_in_range",0 , -0.05, 360.05}}
object = addStrokeBox("HSI_ADF_box", 0.025, 0.045, "CenterCenter", {0,-HSI_radius - 2.3* HSI_tick_lenght}, HSI_ADF_Origin.name, nil, "CMFD_IND_YELLOW")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.VOR}}
object = addStrokeText("HSI_ADF_box_1", "A", CMFD_STRINGDEFS_DEF_X1 , "CenterCenter", {0,HSI_radius + 2.3* HSI_tick_lenght}, HSI_ADF_Origin.name, nil, nil, CMFD_FONT_Y)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.VOR}}
object = addStrokeBox("HSI_ADF_box1", 0.025, 0.045, "CenterCenter", {0,-HSI_radius - 2.3* HSI_tick_lenght}, HSI_ADF_Origin.name, nil, "CMFD_IND_YELLOW")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.ILS}}
object = addStrokeText("HSI_ADF_box1_1", "A", CMFD_STRINGDEFS_DEF_X1 , "CenterCenter", {0,HSI_radius + 2.3* HSI_tick_lenght}, HSI_ADF_Origin.name, nil, nil, CMFD_FONT_Y)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.ILS}}
-- object = addStrokeText("HSI_ADF_text", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.25, -0.086}, nil, nil, {"ADF\n%03.0f`\n\n"}, CMFD_FONT_Y)
-- object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "ADHSI_ADF_HDG", "AVIONICS_ANS_MODE"}
-- object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"parameter_in_range",1 , -0.05, 360.05}, {"change_color_when_parameter_equal_to_number", 2, AVIONICS_ANS_MODE_IDS.GPS, 0, 0, 0, 0}, {"parameter_in_range", 2, AVIONICS_ANS_MODE_IDS.VOR-0.05, AVIONICS_ANS_MODE_IDS.ILS+0.05}}

-- ADF No Signal
local HSI_ADF_RED_Origin = addPlaceholder("HSI_ADF_RED_Origin", {0,0}, HSI_Origin.name)
HSI_ADF_RED_Origin.element_params = {"ADHSI_ADF_HDG"}
HSI_ADF_RED_Origin.controllers = {{"parameter_compare_with_number",0, -1}}
HSI_ADF_RED_Origin.init_rot = {-90}
object = addStrokeBox("HSI_ADF_RED_box", 0.025, 0.045, "CenterCenter", {0,-HSI_radius - 2.3* HSI_tick_lenght}, HSI_ADF_RED_Origin.name, nil, "CMFD_IND_RED")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.VOR}}
object = addStrokeText("HSI_ADF_RED_box_1", "A", CMFD_STRINGDEFS_DEF_X1 , "CenterCenter", {0,HSI_radius + 2.3* HSI_tick_lenght}, HSI_ADF_RED_Origin.name, nil, nil, CMFD_FONT_R)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.VOR}}
object = addStrokeBox("HSI_ADF_RED_box1", 0.025, 0.045, "CenterCenter", {0,-HSI_radius - 2.3* HSI_tick_lenght}, HSI_ADF_RED_Origin.name, nil, "CMFD_IND_RED")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.ILS}}
object = addStrokeText("HSI_ADF_RED_box1_1", "A", CMFD_STRINGDEFS_DEF_X1 , "CenterCenter", {0,HSI_radius + 2.3* HSI_tick_lenght}, HSI_ADF_RED_Origin.name, nil, nil, CMFD_FONT_R)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.ILS}}


-- MODE
object = addStrokeText("ADHSI_MODE_EGI_HSI", "EGI", CMFD_STRINGDEFS_DEF_X07, "LeftCenter", {-0.965, -0.155}, nil, nil,{"EGI\n%02.0f"}, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE", "ADHSI_FYT_DTK_NUMBER"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.EGI}, {"text_using_parameter", 2,0}}
object = addStrokeText("ADHSI_MODE_VOR_HSI", "VOR", CMFD_STRINGDEFS_DEF_X07, "LeftCenter", {-0.965, -0.155}, nil, nil, {"VOR\n%06.2f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE", "ADHSI_VOR_FREQ"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.VOR}, {"text_using_parameter", 2,0}}
object = addStrokeText("ADHSI_MODE_GPS_HSI", "GPS", CMFD_STRINGDEFS_DEF_X07, "LeftCenter", {-0.965, -0.155}, nil, nil,{"GPS\n%s"}, CMFD_FONT_B)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE", "ADHSI_GPS_NAME"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.GPS}, {"text_using_parameter", 2,0}}
object = addStrokeText("ADHSI_MODE_ILS_HSI", "ILS", CMFD_STRINGDEFS_DEF_X07, "LeftCenter", {-0.965, -0.155}, nil, nil,{"ILS\n%06.2f"}, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_ANS_MODE", "ADHSI_ILS_FREQ"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.ILS}, {"text_using_parameter", 2,0}}

-- DME DATA Indicator
object = addStrokeText("HSI_DME_DATA_text", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.6, -0.086}, nil, nil, {"DME\n%2.1f\n", "%02.0f:", "%02.0f\n"}, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT",  "ADHSI_VOR_HDG", "ADHSI_VOR_DIST", "ADHSI_VOR_MIN", "ADHSI_VOR_SEC", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, -0.05, 360.05}, {"parameter_compare_with_number", 5, AVIONICS_ANS_MODE_IDS.ILS}, {"text_using_parameter", 2, 0}, {"text_using_parameter", 3, 1}, {"text_using_parameter", 4, 2}}
object = addStrokeText("HSI_DME_NODATA_text", "DME\nX.X\nXX:XX\n", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.6, -0.086}, nil, nil, nil, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT",  "ADHSI_VOR_HDG", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, -1},  {"parameter_compare_with_number", 2, AVIONICS_ANS_MODE_IDS.ILS}}


local mesh_poly
mesh_poly                   = CreateElement "ceTexPoly"
mesh_poly.name              = "adhsi_background" 
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = { 0, 0}
mesh_poly.material          = "cmfd_tex_eicas"
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-1, aspect}, {1,aspect}, {1,-aspect}, {-1, -aspect }}
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.tex_coords 		= {{600/2048,0}, {1200/2048,0},{1200/2048,800/2048},{600/2048,800/2048}}
mesh_poly.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers = {{"opacity_using_parameter", 0}}
AddElementObject2(mesh_poly)
mesh_poly = nil
