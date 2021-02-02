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


-- -- TODO: add controller
-- split_white_line                 = CreateElement "ceMeshPoly"
-- split_white_line.name            = "split_white_line"
-- split_white_line.material        = CMFD_MATERIAL_WHITE_Y
-- split_white_line.primitivetype   = "triangles"
-- split_white_line.vertices        = {{ 1.0,  0.006},
--                                     { 1.0, -0.006},
--                                     {-1.0, -0.006},
--                                     {-1.0,  0.006},}
-- split_white_line.indices         = DEF_BOX_INDICES
-- split_white_line.init_pos        = {0, -0.4, 0}
-- --split_white_line.h_clip_relation = h_clip_relations.COMPARE
-- split_white_line.level           = PAGE_LEVEL_BASE
-- split_white_line.isdraw          = true
-- split_white_line.isvisible       = true
-- split_white_line.use_mipfilter   = true
-- split_white_line.additive_alpha  = true
-- split_white_line.collimated      = false
-- split_white_line.parent_element  = page_root.name
-- --split_white_line.controllers     = {{"apply_contrast"}}
-- Add(split_white_line)
-- split_white_line = nil


-- -- OSB

local osb_txt = {
    {value="DCLT",          init_pos={CMFD_FONT_UD6_X, -H2W_SCALE+HH},                      align="CenterBottom",   formats={"%s"}, controller={}},
    {value="SWAP",          init_pos={CMFD_FONT_UD3_X, -H2W_SCALE+HH},                      align="CenterBottom",   formats={"%s"}, controller={}},
    {value="IND",           init_pos={CMFD_FONT_UD1_X, -H2W_SCALE+HH},                      align="CenterBottom",   formats={"%s"}, controller={}},
}

-- local text_strpoly
-- for i=1, #(osb_txt) do
--     text_strpoly                 = CreateElement "ceStringPoly"
--     text_strpoly.material        = CMFD_FONT_DEF
--     text_strpoly.stringdefs      = CMFD_STRINGDEFS_DEF_X08
--     text_strpoly.init_pos        = osb_txt[i].init_pos
--     text_strpoly.alignment       = osb_txt[i].align
--     text_strpoly.controllers     = osb_txt[i].controller
--     --text_strpoly.parent_element  = page_root.name
--     if osb_txt[i].level then
--         text_strpoly.level       = osb_txt[i].level
--     end
--     text_strpoly.isdraw          = true
--     text_strpoly.isvisible       = true
--     text_strpoly.h_clip_relation = h_clip_relations.REWRITE_LEVEL
--     text_strpoly.parent_element  = page_root.name
--     AddElementObject(text_strpoly)
--     text_strpoly = nil
-- end


local HW = 0.15
local HH = 0.04 * H2W_SCALE

local text_strpoly
local mesh_poly
-- Draw SOI
text_strpoly                = CreateElement "ceStringPoly"
text_strpoly.material       = CMFD_FONT_DEF
text_strpoly.stringdefs     = CMFD_STRINGDEFS_DEF_X08
text_strpoly.init_pos       = {CMFD_FONT_UD4_X, -H2W_SCALE+HH}
text_strpoly.alignment      = "CenterBottom"
text_strpoly.formats        = "%s"
text_strpoly.element_params = {"CMFD2Soi"}
text_strpoly.controllers    = {{"parameter_in_range",0,0.95, 1.05}}
text_strpoly.name           = "osb_txt_soi"
text_strpoly.value          = "^"
text_strpoly.parent_element    = page_root.name
AddElementObject(text_strpoly)
text_strpoly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = "osb_txt_sel_left"
mesh_poly.init_pos          = {0, HH/2}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {HW, HH}, {HW,-HH}, {-HW,-HH}, {-HW, HH }}
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"CMFD2Primary"}
mesh_poly.controllers       = {{"parameter_in_range", 0, -0.05, 0.05}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = "osb_txt_sel_right"
mesh_poly.init_pos          = {0, HH/2}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {HW, HH}, {HW,-HH}, {-HW,-HH}, {-HW, HH }}
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"CMFD2Primary"}
mesh_poly.controllers       = {{"parameter_in_range", 0 ,0.95, 1.05}}
AddElementObject(mesh_poly)
mesh_poly = nil


text_strpoly                = CreateElement "ceStringPoly"
text_strpoly.material       = CMFD_FONT_DEF
text_strpoly.stringdefs     = CMFD_STRINGDEFS_DEF_X08
text_strpoly.init_pos       = {CMFD_FONT_UD2_X, -H2W_SCALE+HH}
text_strpoly.alignment      = "CenterBottom"
text_strpoly.formats        = {"%s"}
text_strpoly.element_params = {"CMFD2SelLeftName", "CMFD2Primary"}
text_strpoly.controllers    = {{"text_using_parameter",0,0}, {"change_color_when_parameter_equal_to_number", 1, 0, -1, -1, -1}}
text_strpoly.name           = "osb_txt_sel_left"
text_strpoly.value          = "AAA"
text_strpoly.parent_element    = page_root.name
AddElementObject(text_strpoly)
text_strpoly = nil

text_strpoly                = CreateElement "ceStringPoly"
text_strpoly.material       = CMFD_FONT_DEF
text_strpoly.stringdefs     = CMFD_STRINGDEFS_DEF_X08
text_strpoly.init_pos       = {CMFD_FONT_UD5_X, -H2W_SCALE+HH}
text_strpoly.alignment      = "CenterBottom"
text_strpoly.formats        = {"%s"}
text_strpoly.element_params = {"CMFD2SelRightName", "CMFD2Primary"}
text_strpoly.controllers    = {{"text_using_parameter",0,0}, {"change_color_when_parameter_equal_to_number", 1, 1, -1, -1, -1}}
text_strpoly.name           = "osb_txt_sel_right"
text_strpoly.value          = "BBB"
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
