dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_DVR_ID_defs.lua")

dofile(LockOn_Options.script_path.."utils.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

local aspect = GetAspect()

-- Content

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
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.DVR}}
default_parent      = page_root.name

local object

local CMFD_DVR_origin = addPlaceholder(nil, {0,0}, page_root.name)

-- DVR format text
object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, 0.0}, CMFD_DVR_origin.name, nil, {"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_TEXT", "CMFD_DVR_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0},{"text_using_parameter", 1, 0},{"parameter_compare_with_number", 2, CMFD_DVR_FORMAT_IDS.DVR}}

-- OSS Menus
local HW = 0.15
local HH = 0.04 * H2W_SCALE

-- DVR
object = addOSSText(1, "DVR", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- State
object = addOSSText(2, "", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_STATE"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1}}
object.formats = {"%s"}

-- Mode
object = addOSSText(3, "MODE", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1}}
object.formats = {"%s"}

-- CYCLE REC
object = addOSSText(4, "CYCLE\nREC", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

object = addOSSStrokeBox(4,2, nil, nil, nil, nil, 5)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_CYCLE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- RESET DVR
object = addOSSText(6, "RESET\nDVR", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT","CMFD_DVR_RESET_BLINK"}
object.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}

-- FLIR
object = addOSSText(8, "FLIR", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

object = addOSSStrokeBox(8,1, nil, nil, nil, nil, 4)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_FLIR_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AFT RCMFD
object = addOSSText(9, "AFT\nRCMFD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

object = addOSSStrokeBox(9,2, nil, nil, nil, nil, 5)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_AFT_RCMFD_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- AFT LCMFD
object = addOSSText(10, "AFT\nLCMFD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

object = addOSSStrokeBox(10,2, nil, nil, nil, nil, 5)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_AFT_LCMFD_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- FWD LCMFD
object = addOSSText(25, "FWD\nLCMFD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

object = addOSSStrokeBox(25,2, nil, nil, nil, nil, 5)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_FWD_LCMFD_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- FWD RCMFD
object = addOSSText(26, "FWD\nRCMFD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

object = addOSSStrokeBox(26,2, nil, nil, nil, nil, 5)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_FWD_RCMFD_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- HUD
object = addOSSText(27, "HUD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

object = addOSSStrokeBox(27,1, nil, nil, nil, nil, 3)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DVR_HUD_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}


local osb_txt = {
    {value="PLBCK",         init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
}

local text_strpoly
local mesh_poly

for i=1, #(osb_txt) do
    text_strpoly                = CreateElement "ceStringPoly"
    text_strpoly.material       = CMFD_FONT_DEF
    text_strpoly.stringdefs     = CMFD_STRINGDEFS_DEF_X08
    text_strpoly.init_pos       = osb_txt[i].init_pos
    text_strpoly.alignment      = osb_txt[i].align
    text_strpoly.formats        = osb_txt[i].formats
    if osb_txt[i].params then
        text_strpoly.element_params = osb_txt[i].params
    end
    if osb_txt[i].controller then
        text_strpoly.controllers    = osb_txt[i].controller
    end
    text_strpoly.name = "osb_txt_" .. i
    if osb_txt[i].value ~= nil then
        text_strpoly.value = osb_txt[i].value
    else
        text_strpoly.value = "OSB" .. i
    end
    text_strpoly.parent_element    = page_root.name
    AddElementObject(text_strpoly)
    text_strpoly = nil
end
