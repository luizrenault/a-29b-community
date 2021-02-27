--[[

mesh_poly.controllers       = {{"parameter_compare_with_number", 0, 1}}
mesh_poly.controllers       = {{"compare_parameters", 0, 1}}
mesh_poly.controllers       = {{"change_color_when_parameter_equal_to_number",0,1, -1,-1,-1}}
mesh_poly.controllers       = {{"parameter_in_range", 0, -0.05, 0.05}}

{"change_color_when_parameter_equal_to_number", param_nr, number, red, green, blue}
{"text_using_parameter", param_nr, format_nr}
{"move_left_right_using_parameter", param_nr, gain}
{"move_up_down_using_parameter", param_nr, gain}
{"opacity_using_parameter", param_nr}
{"rotate_using_parameter", param_nr, gain}
{"compare_parameters", param1_nr, param2_nr} -- if param1 == param2 then visible
{"parameter_in_range", param_nr, greaterthanvalue, lessthanvalue} -- if greaterthanvalue < param < lessthanvalue then visible
{"parameter_compare_with_number", param_nr, number} -- if param == number then visible
{"line_object_set_point_using_parameters", point_nr, param_x, param_y, gain_x, gain_y}

{"change_texture_state_using_parameter",???} -- exists but crashed DCS when used with one argument.
{"line_object_set_point_using_parameters", ???}
{"change_color_using_parameter", ???} -- exists but crashed DCS when used with one to five arguments.
{"fov_control", ???}
{"increase_render_target_counter", ???}

draw_argument_in_range

]]

local CMFDNumber=get_param_handle("CMFDNumber")
CMFDNumber:set(CMFDNumber:get()+1)
local CMFDNu = CMFDNumber:get()


dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")

local page_root = create_page_root()

local aspect = GetAspect()
local HW = 0.15
local HH = 0.04 * H2W_SCALE


local CMFD_base             = CreateElement "ceMeshPoly" -- untextured shape
CMFD_base.name              = create_guid_string()
CMFD_base.primitivetype     = "triangles"
CMFD_base.material          = CMFD_MATERIAL_DARK
CMFD_base.h_clip_relation   = h_clip_relations.REWRITE_LEVEL
CMFD_base.level             = PAGE_LEVEL_BASE
CMFD_base.collimated        = false
CMFD_base.isdraw            = true
CMFD_base.isvisible         = true
CMFD_base.vertices          = { {1, aspect}, { 1,-aspect}, { -1,-aspect}, {-1,aspect}, }
CMFD_base.indices           = {0,1,2,0,2,3 }
Add(CMFD_base)

-- -- OSB

local osb_txt = {
    {value="SWAP",          init_pos={CMFD_FONT_UD3_X, -H2W_SCALE+HH},                      align="CenterBottom",   formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="IND",           init_pos={CMFD_FONT_UD1_X, -H2W_SCALE+HH},                      align="CenterBottom",   formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
}

local HW = 0.15
local HH = 0.04 * H2W_SCALE

local text_strpoly
local mesh_poly

-- DCLT
text_strpoly                = CreateElement "ceStringPoly"
text_strpoly.material       = CMFD_FONT_DEF
text_strpoly.stringdefs     = CMFD_STRINGDEFS_DEF_X08
text_strpoly.init_pos       = {CMFD_FONT_UD6_X, -H2W_SCALE+HH}
text_strpoly.alignment      = "CenterBottom"
text_strpoly.formats        = "%s"
text_strpoly.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."DCLT"}
text_strpoly.controllers    = {{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number",1,1, -1,-1,-1}}
text_strpoly.name           = "osb_txt_dclt"
text_strpoly.value          = "DCLT"
text_strpoly.parent_element    = page_root.name
AddElementObject(text_strpoly)
text_strpoly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = "osb_txt_dclt"
mesh_poly.init_pos          = {0, HH/2}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {HW, HH}, {HW,-HH}, {-HW,-HH}, {-HW, HH }}
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."DCLT"}
mesh_poly.controllers       = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, 0.95, 1.05}}
AddElementObject(mesh_poly)
mesh_poly = nil

-- Draw DOI
mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {CMFD_FONT_UD4_X, -H2W_SCALE+HH}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "lines"
mesh_poly.vertices          = { {-HH/6, 0}, {HH/6,0}, {HH/6,HH}, {HH/3, HH }, {0, 1.75*HH}, {-HH/3, HH }, {-HH/6, HH}}
mesh_poly.indices           = {0,1, 1,2, 2,3, 3,4,  4,5, 5,6, 6,0}
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFDDoi"}
-- mesh_poly.controllers       = {{"parameter_compare_with_number", 0, 1}}
mesh_poly.controllers       = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFDNu}}

AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = "osb_txt_sel_left"
mesh_poly.init_pos          = {0, HH/2}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {HW, HH}, {HW,-HH}, {-HW,-HH}, {-HW, HH }}
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Primary"}
mesh_poly.controllers       = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}}
AddElementObject(mesh_poly)
mesh_poly = nil

text_strpoly                = CreateElement "ceStringPoly"
text_strpoly.material       = CMFD_FONT_DEF
text_strpoly.stringdefs     = CMFD_STRINGDEFS_DEF_X08
text_strpoly.init_pos       = {CMFD_FONT_UD2_X, -H2W_SCALE+HH}
text_strpoly.alignment      = "CenterBottom"
text_strpoly.formats        = {"%s"}
text_strpoly.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."SelLeftName", "CMFD"..CMFDNu.."Primary"}
text_strpoly.controllers    = {{"opacity_using_parameter", 0}, {"text_using_parameter",1,0}, {"change_color_when_parameter_equal_to_number", 2, 0, -1, -1, -1}}
text_strpoly.name           = "osb_txt_sel_left"
text_strpoly.value          = ""
text_strpoly.parent_element    = page_root.name
AddElementObject(text_strpoly)
text_strpoly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = "osb_txt_sel_right"
mesh_poly.init_pos          = {0, HH/2}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {HW, HH}, {HW,-HH}, {-HW,-HH}, {-HW, HH }}
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Primary"}
mesh_poly.controllers       = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1 ,1}}
AddElementObject(mesh_poly)
mesh_poly = nil

text_strpoly                = CreateElement "ceStringPoly"
text_strpoly.material       = CMFD_FONT_DEF
text_strpoly.stringdefs     = CMFD_STRINGDEFS_DEF_X08
text_strpoly.init_pos       = {CMFD_FONT_UD5_X, -H2W_SCALE+HH}
text_strpoly.alignment      = "CenterBottom"
text_strpoly.formats        = {"%s"}
text_strpoly.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."SelRightName", "CMFD"..CMFDNu.."Primary"}
text_strpoly.controllers    = {{"opacity_using_parameter", 0}, {"text_using_parameter",1,0}, {"change_color_when_parameter_equal_to_number", 2, 1, -1, -1, -1}}
text_strpoly.name           = "osb_txt_sel_right"
text_strpoly.value          = ""
text_strpoly.parent_element    = page_root.name
AddElementObject(text_strpoly)
text_strpoly = nil

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
