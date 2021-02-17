dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "Systems/avionics_api.lua")

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

object = addStrokeText("SMS_GUNS_L", "100", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.134, 0.85}, nil, nil,{"%03.0f"}, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_GUNS_L"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addStrokeText("SMS_GUNS_R", "100", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0.134, 0.85}, nil, nil,{"%03.0f"}, CMFD_FONT_W)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "WPN_GUNS_R"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}
