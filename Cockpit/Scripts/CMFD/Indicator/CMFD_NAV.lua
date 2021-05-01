dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."CMFD/CMFD_NAV_ID_defs.lua")

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
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.NAV}}
default_parent      = page_root.name


local object

object = addOSSText(1, "ROUT")
object = addOSSStrokeBox(1,1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_NAV_FORMAT_IDS.ROUT}}

object = addOSSText(4, "FYT")
object = addOSSStrokeBox(4,1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_NAV_FORMAT_IDS.FYT}}

object = addOSSText(5, "MARK")
object = addOSSStrokeBox(5,1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_NAV_FORMAT_IDS.MARK}}

object = addOSSText(7, "A/C")
object = addOSSStrokeBox(7,1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_NAV_FORMAT_IDS.AC}}

object = addOSSText(28, "AFLD")
object = addOSSStrokeBox(28,1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_NAV_FORMAT_IDS.AFLD}}

local CMFD_NAV_FYT_origin = addPlaceholder(nil, {0,0}, page_root.name)
CMFD_NAV_FYT_origin.element_params = {"CMFD_NAV_FORMAT"}
CMFD_NAV_FYT_origin.controllers = {{"parameter_compare_with_number", 0, CMFD_NAV_FORMAT_IDS.FYT}}

object = addStrokeText(nil, "FT   5", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, 0.66}, CMFD_NAV_FYT_origin.name, nil, {"FT   %1.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addStrokeText(nil, "TOFT 00:00:00", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, 0.391}, CMFD_NAV_FYT_origin.name, nil, {"TOFT %02.0f:", "%02.0f:", "%02.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_HOURS", "CMFD_NAV_FYT_MINS", "CMFD_NAV_FYT_SECS"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 2, 1}, {"text_using_parameter", 3, 2}}

object = addStrokeText(nil, "N   41`52.20'", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, 0.305}, CMFD_NAV_FYT_origin.name, nil, {"%s", "   %02.0f`", "%05.2f'"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_LAT_HEMIS", "CMFD_NAV_FYT_LAT_DEG", "CMFD_NAV_FYT_LAT_MIN"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 2, 1}, {"text_using_parameter", 3, 2}}

object = addStrokeText(nil, "N  047`39.51'", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, 0.206}, CMFD_NAV_FYT_origin.name, nil, {"%s", "  %03.0f`", "%05.2f'"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_LON_HEMIS", "CMFD_NAV_FYT_LON_DEG", "CMFD_NAV_FYT_LON_MIN"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 2, 1}, {"text_using_parameter", 3, 2}}

object = addStrokeText(nil, "ELV    120 FT", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, 0.02}, CMFD_NAV_FYT_origin.name, nil, {"ELV %5.0f FT"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_ELV"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addStrokeText(nil, "OAP", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, -0.349}, CMFD_NAV_FYT_origin.name)

object = addStrokeText(nil, "BRG  350`", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, -0.448}, CMFD_NAV_FYT_origin.name, nil, {"BRG  %03.0f`"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_OAP_BRG"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addStrokeText(nil, "DIS  1300 FT", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, -0.543}, CMFD_NAV_FYT_origin.name, nil, {"DIS %5.1f NM"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_OAP_DIST"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addStrokeText(nil, "ELV   733 FT", CMFD_STRINGDEFS_DEF_X1, "LeftCenter", {-0.41, -0.627}, CMFD_NAV_FYT_origin.name, nil, {"ELV %5.0f FT"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT_OAP_ELV"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addStrokeText(nil, "FYT\n5", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.89, 0.56}, CMFD_NAV_FYT_origin.name, nil, {"FT\n%1.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addOSSArrow(27, 1, CMFD_NAV_FYT_origin.name)
object = addOSSArrow(26, 0, CMFD_NAV_FYT_origin.name)

object = addOSSArrow(2, 0, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_PG_NEXT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

object = addOSSArrow(3, 1, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_PG_PREV"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}


local CMFD_NAV_ROUT_origin = addPlaceholder(nil, {0,0}, page_root.name)
CMFD_NAV_ROUT_origin.element_params = {"CMFD_NAV_FORMAT"}
CMFD_NAV_ROUT_origin.controllers = {{"parameter_compare_with_number", 0, CMFD_NAV_FORMAT_IDS.ROUT}}

object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, -0.1}, CMFD_NAV_ROUT_origin.name, nil, {"%s", "%s", "%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_ROUT_TEXT", "CMFD_NAV_ROUT_TEXT1", "CMFD_NAV_ROUT_TEXT2"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 2, 1}, {"text_using_parameter", 3, 2}}

local CMFD_NAV_AC_origin = addPlaceholder(nil, {0,0}, page_root.name)
CMFD_NAV_AC_origin.element_params = {"CMFD_NAV_FORMAT"}
CMFD_NAV_AC_origin.controllers = {{"parameter_compare_with_number", 0, CMFD_NAV_FORMAT_IDS.AC}}

object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, -0.1}, CMFD_NAV_AC_origin.name, nil, {"%s", "%s", "%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_AC_TEXT", "CMFD_NAV_AC_TEXT1", "CMFD_NAV_AC_TEXT2"}
object.controllers = {
                        {"opacity_using_parameter", 0},
                        {"text_using_parameter", 1, 0},
                    }

local CMFD_NAV_AFLD_origin = addPlaceholder(nil, {0,0}, page_root.name)
CMFD_NAV_AFLD_origin.element_params = {"CMFD_NAV_FORMAT"}
CMFD_NAV_AFLD_origin.controllers = {{"parameter_compare_with_number", 0, CMFD_NAV_FORMAT_IDS.AFLD}}

object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, -0.1}, CMFD_NAV_AFLD_origin.name, nil, {"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_AFLD_TEXT"}
object.controllers = {
                        {"opacity_using_parameter", 0},
                        {"text_using_parameter", 1, 0},
                    }

local CMFD_NAV_MARK_origin = addPlaceholder(nil, {0,0}, page_root.name)
CMFD_NAV_MARK_origin.element_params = {"CMFD_NAV_FORMAT"}
CMFD_NAV_MARK_origin.controllers = {{"parameter_compare_with_number", 0, CMFD_NAV_FORMAT_IDS.MARK}}

object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, -0.1}, CMFD_NAV_MARK_origin.name, nil, {"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_MARK_TEXT"}
object.controllers = {
                        {"opacity_using_parameter", 0},
                        {"text_using_parameter", 1, 0},
                    }

