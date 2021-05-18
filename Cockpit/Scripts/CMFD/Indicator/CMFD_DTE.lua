dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_DTE_ID_defs.lua")

dofile(LockOn_Options.script_path.."utils.lua")

local CMFDNumber = get_param_handle("CMFDNumber")
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
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.DTE}}
default_parent      = page_root.name

local object

local CMFD_DTE_origin = addPlaceholder(nil, {0,0}, page_root.name)

-- DTE format text
object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, 0.5}, CMFD_DTE_origin.name, nil, {"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_TEXT", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0},{"text_using_parameter", 1, 0},{"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.DTE}}

-- QCHK format text
object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, 0}, CMFD_DTE_origin.name, nil, {"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_TEXT", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0},{"text_using_parameter", 1, 0},{"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.QCHK}}

-- OSS Menus

local HW = 0.15
local HH = 0.04 * H2W_SCALE

-- DTE
object = addOSSText(1, "", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_DVR_STATE"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1}}
object.formats = {"%s"}

-- CLR
object = addOSSText(3, "CLR", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_FORMAT_IDS.DTE}}

-- QCHK
object = addOSSText(4, "QCHK", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

object = addOSSStrokeBox(4,1, nil, nil, nil, nil, 4)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 1, CMFD_DTE_FORMAT_IDS.QCHK}}

-- ALL
object = addOSSText(5, "ALL", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_FORMAT_IDS.DTE}}

-- SIM INV
object = addOSSText(7, "SIM\nINV", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT", "CMFD_DTE_SIM_INV_BLINK"}
object.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0},{"parameter_compare_with_number", 2, 0}}

object = addOSSStrokeBox(7,2, nil, nil, nil, nil, 3)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_SIM_INV_STATE", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_STATE_IDS.LOADED}, {"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.DTE}}

-- MSMD
object = addOSSText(11, "MSMD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT", "CMFD_DTE_MSMD_BLINK"}
object.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0},{"parameter_compare_with_number", 2, 0}}

object = addOSSStrokeBox(11,1, nil, nil, nil, nil, 4)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_MSMD_STATE", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_STATE_IDS.LOADED}, {"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.DTE}}

-- HSD
object = addOSSText(24, "HSD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT", "CMFD_DTE_HSD_BLINK"}
object.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0},{"parameter_compare_with_number", 2, 0}}

object = addOSSStrokeBox(24,1, nil, nil, nil, nil, 3)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_HSD_STATE", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_STATE_IDS.LOADED}, {"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.DTE}}

-- INV
object = addOSSText(25, "INV", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT", "CMFD_DTE_INV_BLINK"}
object.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0},{"parameter_compare_with_number", 2, 0}}

object = addOSSStrokeBox(25,1, nil, nil, nil, nil, 3)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_INV_STATE", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_STATE_IDS.LOADED}, {"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.DTE}}

-- PROG
object = addOSSText(26, "PROG", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT", "CMFD_DTE_PROG_BLINK"}
object.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0},{"parameter_compare_with_number", 2, 0}}

object = addOSSStrokeBox(26,1, nil, nil, nil, nil, 4)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_PROG_STATE", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_STATE_IDS.LOADED}, {"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.DTE}}

-- DB
object = addOSSText(27, "DB", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT", "CMFD_DTE_DB_BLINK"}
object.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0},{"parameter_compare_with_number", 2, 0}}

object = addOSSStrokeBox(27,1, nil, nil, nil, nil, 2)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_DB_STATE", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_STATE_IDS.LOADED}, {"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.DTE}}

-- MPD
object = addOSSText(28, "MPD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_FORMAT", "CMFD_DTE_MPD_BLINK"}
object.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0},{"parameter_compare_with_number", 2, 0}}

object = addOSSStrokeBox(28,1, nil, nil, nil, nil, 3)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_DTE_MPD_STATE", "CMFD_DTE_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_DTE_STATE_IDS.LOADED}, {"parameter_compare_with_number", 2, CMFD_DTE_FORMAT_IDS.DTE}}