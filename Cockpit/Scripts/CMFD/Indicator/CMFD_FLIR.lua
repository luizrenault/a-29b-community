dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")

dofile(LockOn_Options.script_path.."utils.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

local aspect = GetAspect()

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
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.FLIR}}
default_parent      = page_root.name

local CMFD_FLIR_origin = addPlaceholder(nil, {0,0}, page_root.name)

local object

local CMFD_BRIGHT = "CMFD"..tostring(CMFDNu).."_BRIGHT"

-- FLIR Video

local FLIR_Video = addTextureBox(nil, 2, 1.5, "CenterCenter", {0, aspect / 4}, nil, nil, "render_target_1");

-- Elevation
for i = 30, -120, -30 do
    if i==0 then
        addStrokeText(nil, string.format("%i-", i), CMFD_STRINGDEFS_DEF_X07, "RightCenter", {-0.79, 0.5 - (30-i) / 150 }, FLIR_Video.name, nil, nil, CMFD_FONT_W)
    else
        addStrokeText(nil, string.format("%+i-", i), CMFD_STRINGDEFS_DEF_X07, "RightCenter", {-0.79, 0.5 - (30-i) / 150 }, FLIR_Video.name, nil, nil, CMFD_FONT_W)
    end
end
object = addFillArrow(nil, 0.05, 0.05, "LeftCenter", {-0.78, 0.3}, FLIR_Video.name, nil, CMFD_MATERIAL_WHITE)
object.element_params = {CMFD_BRIGHT, "FLIR_EL"}
object.controllers = {{"opacity_using_parameter", 0}, {"move_up_down_using_parameter", 1, GetScale() * 1/math.rad(150)}}

-- Azimuth
for i = -180, 180, 90 do
    if i==0 then
        addStrokeText(nil, string.format("|\n%i", i), CMFD_STRINGDEFS_DEF_X07, "CenterBottom", {0.6 * i/180, -0.75 }, FLIR_Video.name, nil, nil, CMFD_FONT_W)
    else
        addStrokeText(nil, string.format("|\n%+i", i), CMFD_STRINGDEFS_DEF_X07, "CenterBottom", {0.6 * i/180, -0.75 }, FLIR_Video.name, nil, nil, CMFD_FONT_W)
    end
end
object = addFillArrow(nil, 0.05, 0.05, "LeftCenter", {0, -0.62}, FLIR_Video.name, nil, CMFD_MATERIAL_WHITE)
object.init_rot = {90}
object.element_params = {CMFD_BRIGHT, "FLIR_AZ"}
object.controllers = {{"opacity_using_parameter", 0}, {"move_up_down_using_parameter", 1, -GetScale() * 0.6/math.pi}}

function flir_status_pos (i)
    return {-1 + 2 * i / 12, 0.005}
end

-- Top Bar
local FLIR_top_bar = addFillBox(nil, 2, 0.06, "CenterBottom", {0, 0.75}, FLIR_Video.name, nil, CMFD_MATERIAL_WHITE)
object = addStrokeText(nil, "HI/HI/EN", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(1), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object.element_params = {CMFD_BRIGHT, "FLIR_FILTER_NOISE", "FLIR_FILTER_MATCH", "FLIR_FILTER_ENH"}
-- object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 0, 1}, {"text_using_parameter", 1, 2}, {"text_using_parameter", 2, 3}}
object = addStrokeText(nil, "DAY/DCLT", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(2.7), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "AGN", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(4), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "MOD", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(5), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "TRK", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(6), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "INRPT", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(7), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "NRW", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(8), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "FRZ", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(9), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "WHT", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(10), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "RDY", CMFD_STRINGDEFS_DEF_X06, "CenterBottom", flir_status_pos(11), FLIR_top_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
    
-- Bottom Bar
FLIR_bottom_bar = addFillBox(nil, 2, 0.06, "CenterBottom", {0, -0.81}, FLIR_Video.name, nil, CMFD_MATERIAL_WHITE)
object = addStrokeText(nil, "LAT N DD^MM.MM\' LON W DDD^MM.MM\'o", CMFD_STRINGDEFS_DEF_X05, "CenterBottom", flir_status_pos(2.75), FLIR_bottom_bar.name, nil, {"%s/", "%s/", "%s"}, CMFD_FONT_K)
object = addStrokeText(nil, "-93.4oAZ", CMFD_STRINGDEFS_DEF_X05, "RightBottom", flir_status_pos(6.75), FLIR_bottom_bar.name, nil, {"%2.1foAZ"}, CMFD_FONT_K)
object.element_params = {CMFD_BRIGHT, "FLIR_AZ_DEG"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeText(nil, "-93.4oAZ", CMFD_STRINGDEFS_DEF_X05, "RightBottom", flir_status_pos(8.25), FLIR_bottom_bar.name, nil, {"%2.1foEL"}, CMFD_FONT_K)
object.element_params = {CMFD_BRIGHT, "FLIR_EL_DEG"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeText(nil, "DD-MM-YY HH:MM:SSL", CMFD_STRINGDEFS_DEF_X05, "RightBottom", flir_status_pos(11.5), FLIR_bottom_bar.name, nil, {"%s"}, CMFD_FONT_K)
object.element_params = {CMFD_BRIGHT, "FLIR_TIME"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}


FLIR_STATUS_PARAMS = {"FLIR_FILTER", "FLIR_SYMB", "FLIR_GAIN", "FLIR_SCENE", "FLIR_TRACKER", "FLIR_MODE", "FLIR_FOV", "FLIR_FREEZE", "FLIR_POLARITY", "FLIR_STATUS"}





-- Tracking INFO

-- FLIR format text

object = addStrokeText(nil, "FLIR DEGRADED\nOR NOT AVAILABLE", CMFD_STRINGDEFS_DEF_X15, "CenterCenter", {0, -0.9}, CMFD_FLIR_origin.name, nil, {"%s"})
object.element_params = {CMFD_BRIGHT, "FLIR_STATUS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 3, -1}}
object.material    = CMFD_FONT_R

-- OSS Menus

local HW = 0.15
local HH = 0.04 * H2W_SCALE

-- COMP
object = addOSSText(21, "COMP", page_root.name)
object.element_params = {CMFD_BRIGHT}
object.controllers = {{"opacity_using_parameter", 0}}

-- BRT/C
object = addOSSText(22, "BRT/C", page_root.name)
object.element_params = {CMFD_BRIGHT}
object.controllers = {{"opacity_using_parameter", 0}}

