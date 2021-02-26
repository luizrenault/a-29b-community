dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "Systems/avionics_api.lua")
dofile(LockOn_Options.script_path .. "Systems/weapon_system_api.lua")
dofile(LockOn_Options.script_path.."CMFD/CMFD_SMS_ID_defs.lua")

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
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.SMS}}
default_parent      = page_root.name


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
mesh_poly.tex_coords 		= {{1200/2048,0}, {1800/2048,0},{1800/2048,800/2048},{1200/2048,800/2048}}
AddElementObject2(mesh_poly)
mesh_poly = nil


local object

object = addStrokeText("SMS_GUNS_L", "100", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.134, 0.85}, nil, nil,{"%03.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_GUNS_L"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox(nil, 0.15, 0.062, "CenterCenter", {0,0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_GUNS_L_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}
object = addStrokeBoxDashed(nil, 0.15, 0.062, 0.02, 0.02, {0,0}, object.parent_element)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_GUNS_L_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 2}}


object = addStrokeText("SMS_GUNS_R", "100", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.134, 0.85}, nil, nil,{"%03.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_GUNS_R"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox(nil, 0.15, 0.062, "CenterCenter", {0,0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_GUNS_R_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}
object = addStrokeBoxDashed(nil, 0.15, 0.062, 0.02, 0.02, {0,0}, object.parent_element)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_GUNS_R_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 2}}

object = addStrokeText("SMS_POS_5_TEXT", "TANK", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.53, -0.518}, nil, nil,{"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_5_TEXT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox(nil, 0.3, 0.062, "CenterCenter", {0,0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_5_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}
object = addStrokeBoxDashed(nil, 0.3, 0.062, 0.02, 0.02, {0,0}, object.parent_element)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_5_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 2}}

object = addStrokeText("SMS_POS_4_TEXT", "TANK", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.277, -0.229}, nil, nil,{"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_4_TEXT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox(nil, 0.3, 0.062, "CenterCenter", {0,0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_4_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}
object = addStrokeBoxDashed(nil, 0.3, 0.062, 0.02, 0.02, {0,0}, object.parent_element)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_4_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 2}}

object = addStrokeText("SMS_POS_3_TEXT", "TANK", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, 0.1}, nil, nil,{"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_3_TEXT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox(nil, 0.3, 0.062, "CenterCenter", {0,0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_3_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}
object = addStrokeBoxDashed(nil, 0.3, 0.062, 0.02, 0.02, {0,0}, object.parent_element)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_3_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 2}}

object = addStrokeText("SMS_POS_2_TEXT", "TANK", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.277, -0.229}, nil, nil,{"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_2_TEXT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox(nil, 0.3, 0.062, "CenterCenter", {0,0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_2_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}
object = addStrokeBoxDashed(nil, 0.3, 0.062, 0.02, 0.02, {0,0}, object.parent_element)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_2_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 2}}

object = addStrokeText("SMS_POS_1_TEXT", "TANK", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.53, -0.518}, nil, nil,{"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_1_TEXT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
object = addStrokeBox(nil, 0.3, 0.062, "CenterCenter", {0,0}, object.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_1_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}
object = addStrokeBoxDashed(nil, 0.3, 0.062, 0.02, 0.02, {0,0}, object.parent_element)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_POS_1_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 2}}

-- RELEASE
object = addStrokeText(nil, "RELEASE", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_RELEASE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}}

-- RDY
object = addStrokeText(nil, "RDY", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_READY", "WPN_RELEASE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 2, 0}}

-- SAFE
local SMS_mode_safe = addPlaceholder("SMS_mode_safe", {0,0})
SMS_mode_safe.element_params = {"SMS_MODE"}
SMS_mode_safe.controllers = {{"parameter_compare_with_number", 0, SMS_MODE_IDS.SAFE}}

object = addOSSText(1, "SAFE", SMS_mode_safe.name)

object = addOSSText(3, "WPN", SMS_mode_safe.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.WPN}}

object = addOSSText(3, "RACK", SMS_mode_safe.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.RACK}}

object = addOSSText(4, "INV", SMS_mode_safe.name)

object = addOSSText(5, "SJ", SMS_mode_safe.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_INV"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}}

object = addStrokeText(nil, "SIM", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_mode_safe.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_MASS", "SMS_INV"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_MASS_IDS.SIM}, {"parameter_compare_with_number", 2, 0}}

-- INV
local SMS_submode_inv = addPlaceholder("SMS_submode_inv", {0,0})
SMS_submode_inv.element_params = {"SMS_INV"}
SMS_submode_inv.controllers = {{"parameter_compare_with_number", 0, 1}}

object = addStrokeText(nil, "INV", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_submode_inv.name, nil, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_INV", "WPN_MASS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_in_range", 2, WPN_MASS_IDS.SAFE -0.05, WPN_MASS_IDS.LIVE + 0.05}}

object = addStrokeText(nil, "SIM-INV", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_submode_inv.name, nil, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_INV", "WPN_MASS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 2, WPN_MASS_IDS.SIM}}


object = addOSSStrokeBox(4, 1, SMS_submode_inv.name)

object = addOSSText(2, "CLR\nWPN", SMS_submode_inv.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.WPN}}

object = addOSSText(2, "CLR\nRACK", SMS_submode_inv.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.RACK}}

object = addOSSText(6, "SIML", SMS_submode_inv.name)
object = addOSSText(7, "LOAD", SMS_submode_inv.name)
object = addOSSText(8, "NO\nARMR", SMS_submode_inv.name)
object = addOSSText(9, "FLIR", SMS_submode_inv.name)
object = addOSSText(11, "ST4", SMS_submode_inv.name)
object = addOSSText(12, "ST5", SMS_submode_inv.name)
object = addOSSText(23, "ST1", SMS_submode_inv.name)
object = addOSSText(24, "ST2", SMS_submode_inv.name)
object = addOSSText(25, "ST3", SMS_submode_inv.name)
object = addOSSText(28, "GUN", SMS_submode_inv.name)


-- SJ
local SMS_mode_sj = addPlaceholder("SMS_mode_sj", {0,0})
SMS_mode_sj.element_params = {"SMS_MODE"}
SMS_mode_sj.controllers = {{"parameter_compare_with_number", 0, SMS_MODE_IDS.SJ}}

object = addOSSText(1, "SJ", SMS_mode_sj.name)

object = addOSSText(3, "WPN", SMS_mode_sj.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.WPN}}

object = addOSSText(3, "RACK", SMS_mode_sj.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.RACK}}

object = addOSSText(11, "ST4", SMS_mode_sj.name)
object = addOSSText(12, "ST5", SMS_mode_sj.name)
object = addOSSText(23, "ST1", SMS_mode_sj.name)
object = addOSSText(24, "ST2", SMS_mode_sj.name)
object = addOSSText(25, "ST3", SMS_mode_sj.name)

object = addStrokeText(nil, "SIM-NO SJ", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_mode_sj.name, nil, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_MASS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_MASS_IDS.SIM}}

object = addStrokeText(nil, "SAFE-NO SJ", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_mode_sj.name, nil, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_MASS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_MASS_IDS.SAFE}}

object = addStrokeText(nil, "SAFE-NO SJ", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_mode_sj.name, nil, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_LATEARM", "WPN_MASS"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, WPN_LATEARM_IDS.GUARD-0.05, WPN_LATEARM_IDS.SAFE + 0.05}, {"parameter_compare_with_number", 2, WPN_MASS_IDS.LIVE}}

object = addStrokeText(nil, "JET", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_mode_sj.name, nil, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_MASS", "WPN_LATEARM"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_MASS_IDS.LIVE}, {"parameter_compare_with_number", 2, WPN_LATEARM_IDS.ON}}

-- EJ
local SMS_mode_ej = addPlaceholder("SMS_mode_ej", {0,0})
SMS_mode_ej.element_params = {"SMS_MODE"}
SMS_mode_ej.controllers = {{"parameter_compare_with_number", 0, SMS_MODE_IDS.EJ}}

object = addOSSText(1, "E-J", SMS_mode_ej.name)

object = addOSSText(3, "WPN", SMS_mode_ej.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.WPN}}

object = addOSSText(3, "RACK", SMS_mode_ej.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.RACK}}

-- AA
local SMS_mode_aa = addPlaceholder("SMS_mode_aa", {0,0})
SMS_mode_aa.element_params = {"SMS_MODE"}
SMS_mode_aa.controllers = {{"parameter_compare_with_number", 0, SMS_MODE_IDS.AA}}

object = addOSSText(1, "A/A", SMS_mode_aa.name)

object = addOSSText(3, "WPN", SMS_mode_aa.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.WPN}}

object = addOSSText(3, "RACK", SMS_mode_aa.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.RACK}}

object = addOSSText(4, "INV", SMS_mode_aa.name)

object = addOSSText(5, "SJ", SMS_mode_aa.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_INV"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}}

local SMS_mode_aa_oss = addPlaceholder("SMS_mode_aa_oss", {0,0}, SMS_mode_aa.name)
SMS_mode_aa_oss.element_params = {"SMS_INV"}
SMS_mode_aa_oss.controllers = {{"parameter_compare_with_number", 0, 0}}


object = addOSSText(2, "SNAP", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_SIGHT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_SIGHT_IDS.SNAP}}
object = addOSSText(2, "LCOS", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_SIGHT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_SIGHT_IDS.LCOS}}
object = addOSSText(2, "SSLC", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_SIGHT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_SIGHT_IDS.SSLC}}

object = addOSSText(7, "QTY TYPE", SMS_mode_aa_oss.name, nil, nil, {"%01.0f ", "%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_QTY", "WPN_AA_NAME"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, -0.05, 999}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 2, 1}}

object = addOSSText(8, "AMN\nQTY", SMS_mode_aa_oss.name, nil, nil, {"INTRG\n%01.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_INTRG_QTY"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addOSSText(9, "RR\nRATE", SMS_mode_aa_oss.name, nil, nil, {"RR\n%01.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_RR"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addOSSText(10, "DL", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_RR_SRC"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_RR_SRC_IDS.DL}}
object = addOSSText(10, "MAN", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_RR_SRC"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_RR_SRC_IDS.MAN}}

object = addOSSText(11, "DL", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_SLV_SRC"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_SLV_SRC_IDS.DL}}
object = addOSSText(11, "BST", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_SLV_SRC"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_SLV_SRC_IDS.BST}}

object = addOSSText(25, "COOL", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_COOL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_COOL_IDS.COOL}}
object = addOSSText(25, "WARM", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_COOL"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_COOL_IDS.WARM}}

object = addOSSText(26, "SPOT", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_SCAN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_SCAN_IDS.SPOT}}
object = addOSSText(26, "SCAN", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_SCAN"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_SCAN_IDS.SCAN}}

object = addOSSText(27, "TD", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_LIMIT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_LIMIT_IDS.TD}}
object = addOSSText(27, "BP", SMS_mode_aa_oss.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AA_LIMIT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_AA_LIMIT_IDS.BP}}

object = addOSSText(28, "STEP", SMS_mode_aa_oss.name)

object = addStrokeText(nil, "SIM", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_mode_aa.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_MASS", "SMS_INV", "WPN_LATEARM"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, WPN_MASS_IDS.SIM}, {"parameter_compare_with_number", 2, 0}, {"parameter_in_range", 3, WPN_LATEARM_IDS.GUARD-0.05, WPN_LATEARM_IDS.SAFE+0.05}}

object = addStrokeText(nil, "SIM-RDY", CMFD_STRINGDEFS_DEF_X2, "CenterCenter", {0, -0.65}, SMS_mode_aa.name, nil, nil)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_INV", "WPN_SIM_READY"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}, {"parameter_compare_with_number", 2, 1}}


-- AA
local SMS_mode_ag = addPlaceholder("SMS_mode_ag", {0,0})
SMS_mode_ag.element_params = {"SMS_MODE"}
SMS_mode_ag.controllers = {{"parameter_compare_with_number", 0, SMS_MODE_IDS.AG}}

object = addOSSText(1, "A/G", SMS_mode_ag.name)

object = addOSSText(3, "WPN", SMS_mode_ag.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.WPN}}

object = addOSSText(3, "RACK", SMS_mode_ag.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_CARGOTYPE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, SMS_CARGO_TYPE_IDS.RACK}}

object = addOSSText(4, "INV", SMS_mode_ag.name)

object = addOSSText(5, "SJ", SMS_mode_ag.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "SMS_INV"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}}

local SMS_mode_ag_oss = addPlaceholder("SMS_mode_ag_oss", {0,0}, SMS_mode_ag.name)
SMS_mode_ag_oss.element_params = {"SMS_INV"}
SMS_mode_ag_oss.controllers = {{"parameter_compare_with_number", 0, 0}}

object = addOSSText(28, "QTY TYPE", SMS_mode_ag_oss.name, nil, nil, {"%01.0f ", "%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_AG_QTY", "WPN_AG_NAME"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, -0.05, 999}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 2, 1}}




