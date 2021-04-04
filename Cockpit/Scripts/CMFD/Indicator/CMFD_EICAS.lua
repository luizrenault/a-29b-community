dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

local page_root = create_page_root()
page_root.element_params = {"CMFD"..CMFDNu.."Format"}
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.EICAS}}

local aspect = GetAspect()


local Poly_Text
-- local Poly_Text             = CreateElement "ceStringPoly"
-- Poly_Text.material          = CMFD_FONT_DEF
-- Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X2
-- Poly_Text.init_pos          = {0, 0, 0}
-- Poly_Text.alignment         = "CenterCenter"
-- Poly_Text.value             = "EICAS"
-- Poly_Text.parent_element    = page_root.name
-- AddToUpper(Poly_Text)
-- Poly_Text = nil

local mesh_poly
mesh_poly                   = CreateElement "ceTexPoly"
mesh_poly.name              = "eicas_background" 
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = { 0, 0}
mesh_poly.material          = "cmfd_tex_eicas"
mesh_poly.primitivetype    = "triangles"
mesh_poly.vertices        = { {-1, aspect}, {1,aspect}, {1,-aspect}, {-1, -aspect }}
mesh_poly.indices        = default_box_indices
mesh_poly.isvisible        = true
mesh_poly.tex_coords 		= {{0,0},{600/2048,0},{600/2048,800/2048},{0,800/2048}}
-- mesh_poly.blend_mode 		= blend_mode.IBM_REGULAR_RGB_ONLY
-- mesh_poly.h_clip_relation  = h_clip_relations.REWRITE_LEVEL
mesh_poly.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers = {{"opacity_using_parameter", 0}}
AddElementObject2(mesh_poly)
mesh_poly = nil


mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.4, 0.615, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.08, 0.035}, {0.08,0.035}, {0.08,-0.035}, {-0.08, -0.035} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_TQ_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X1
Poly_Text.init_pos          = {-0.4, 0.615, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%3.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_TQ", "EICAS_TQ_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0}, 
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1}, 
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.565, 0.615}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.1, 0.005}, {0.03,0.005}, {0.03,-0.005}, {-0.1, -0.005 }}
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_TQ_ROT", "EICAS_TQ_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"rotate_using_parameter",0, 1.0 },
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,1,0,0}, 
                                {"opacity_using_parameter", 2}
                              }
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.565, 0.615}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          =  { {-0.265, 0.02}, {-0.22,0.0}, {-0.265,-0.02}} --{ {-0.2, 0.0}, {-0.205,0.005}, {-0.205,-0.005}, {-0.2, 0.0}}
mesh_poly.indices           = { 0 , 1, 2 } --default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_TQ_REQ_ROT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"rotate_using_parameter",0, 1.0 }, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.565, 0.615}
mesh_poly.material          = CMFD_MATERIAL_CYAN
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          =  { {-0.2425, 0.02}, {-0.22,0.0}, {-0.2425,-0.02}, {-0.265, 0.0 }} 
mesh_poly.indices           = { 0 , 1, 2, 3, 0, 2 } --default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_TQ_OPT_ROT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"rotate_using_parameter",0, 1.1 }, {"parameter_in_range",0, -math.pi, math.pi * 50 / 60 - 0.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.233, 0.615, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.08, 0.035}, {0.1,0.035}, {0.1,-0.035}, {-0.08, -0.035} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_T5_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X1
Poly_Text.init_pos          = {0.233, 0.615, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%3.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_T5", "EICAS_T5_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.0363, 0.617}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.1, 0.005}, {0.03,0.005}, {0.03,-0.005}, {-0.1, -0.005 }}
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_T5_ROT", "EICAS_T5_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"rotate_using_parameter",0, 1.0 },
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,1,0,0},
                                {"opacity_using_parameter", 2}
                              }
AddElementObject(mesh_poly)
mesh_poly = nil


mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.605, 0.41, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.06, 0.03}, {0.06,0.03}, {0.06,-0.03}, {-0.06, -0.03} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_OIL_PRESS_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.605, 0.41, 0}
mesh_poly.material          = CMFD_MATERIAL_YELLOW
mesh_poly.primitivetype     = "lines"
mesh_poly.vertices          = { {-0.06, 0.03}, {0.06,0.03}, {0.06,-0.03}, {-0.06, -0.03} }
mesh_poly.indices           = {0,1, 1,2, 2,3, 3,0}
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_OIL_PRESS_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 0.95, 1.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X08
Poly_Text.init_pos          = {0.605, 0.41, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%3.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_OIL_PRESS", "EICAS_OIL_PRESS_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,-1},
                                {"change_color_when_parameter_equal_to_number",1 , 2, -1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.627, 0.49}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          =  { {-0.045, 0.02}, {0,0.0}, {-0.045,-0.02}} --{ {-0.2, 0.0}, {-0.205,0.005}, {-0.205,-0.005}, {-0.2, 0.0}}
mesh_poly.indices           = { 0 , 1, 2 } --default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_OIL_PRESS", "EICAS_OIL_PRESS_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"move_up_down_using_parameter",0, 0.000095 },
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,-1},
                                {"change_color_when_parameter_equal_to_number",1 , 2, 1, 0, 0},
                                {"opacity_using_parameter", 2}
                              }
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.77, 0.41, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.06, 0.03}, {0.06,0.03}, {0.06,-0.03}, {-0.06, -0.03} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_OIL_TEMP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.77, 0.41, 0}
mesh_poly.material          = CMFD_MATERIAL_YELLOW
mesh_poly.primitivetype     = "lines"
mesh_poly.vertices          = { {-0.06, 0.03}, {0.06,0.03}, {0.06,-0.03}, {-0.06, -0.03} }
mesh_poly.indices           = {0,1, 1,2, 2,3, 3,0}
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_OIL_TEMP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 0.95, 1.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X08
Poly_Text.init_pos          = {0.77, 0.41, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%3.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_OIL_TEMP","EICAS_OIL_TEMP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.786, 0.555}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          =  { {0,0.0}, {0.045, 0.02}, {0.045,-0.02}} --{ {-0.2, 0.0}, {-0.205,0.005}, {-0.205,-0.005}, {-0.2, 0.0}}
mesh_poly.indices           = { 0 , 1, 2 } --default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_OIL_TEMP","EICAS_OIL_TEMP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"move_up_down_using_parameter",0, 0.000095 },
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2, 1, 0, 0},
                                {"opacity_using_parameter", 2}
                              }
AddElementObject(mesh_poly)
mesh_poly = nil




mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.445, 0.133, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.06, 0.03}, {0.06,0.03}, {0.06,-0.03}, {-0.06, -0.03} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_NP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X07
Poly_Text.init_pos          = {-0.445, 0.133, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%3.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_NP", "EICAS_NP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2, -1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil


mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.157, 0.30, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.12, 0.035}, {0.12,0.035}, {0.12,-0.035}, {-0.12, -0.035} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_NG_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X1
Poly_Text.init_pos          = {-0.157, 0.30, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%3.1f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_NG", "EICAS_NG_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X08
Poly_Text.init_pos          = {-0.905, 0.25, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%03.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_OAT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}
AddToUpper(Poly_Text)
Poly_Text = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {-0.926, 0.85, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.value             = "IGN"
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_IGN", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"parameter_in_range",0 , 0.95, 1.05}, {"opacity_using_parameter", 1}}
AddToUpper(Poly_Text)
Poly_Text = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_CYAN
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {-0.926, 0.91, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%s"}
Poly_Text.value             = "T/O"
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_ENG_MODE", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0 , 0}, {"opacity_using_parameter", 1}}
AddToUpper(Poly_Text)
Poly_Text = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {-0.562, -0.88, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%0.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_HYD", "EICAS_HYD_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.562, -0.88, 0}
mesh_poly.material          = CMFD_MATERIAL_YELLOW
mesh_poly.primitivetype     = "lines"
mesh_poly.vertices          = { {-0.08, 0.03}, {0.08,0.03}, {0.08,-0.03}, {-0.08, -0.03} }
mesh_poly.indices           = {0,1, 1,2, 2,3, 3,0}
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_HYD_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 0.95, 1.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.271, -0.88, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.08, 0.03}, {0.08,0.03}, {0.08,-0.03}, {-0.08, -0.03} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_CAB_PRESS_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {-0.271, -0.88, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%0.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_CAB_PRESS", "EICAS_CAB_PRESS_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X08
Poly_Text.init_pos          = {0.23, 0.148, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%03.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_BAT_AMP", "EICAS_BAT_AMP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 1, 1,1,0},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.23, 0.148, 0}
mesh_poly.material          = CMFD_MATERIAL_YELLOW
mesh_poly.primitivetype     = "lines"
mesh_poly.vertices          = { {-0.06, 0.03}, {0.06,0.03}, {0.06,-0.03}, {-0.06, -0.03} }
mesh_poly.indices           = {0,1, 1,2, 2,3, 3,0}
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_BAT_AMP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 0.95, 1.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.493, 0.148, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.09, 0.03}, {0.09,0.03}, {0.09,-0.03}, {-0.09, -0.03} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_BAT_VOLT_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X08
Poly_Text.init_pos          = {0.493, 0.148, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%02.1f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_BAT_VOLT", "EICAS_BAT_VOLT_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.756, 0.148, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.09, 0.03}, {0.09,0.03}, {0.09,-0.03}, {-0.09, -0.03} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_BAT_TEMP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X08
Poly_Text.init_pos          = {0.756, 0.148, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%0.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_BAT_TEMP", "EICAS_BAT_TEMP_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.812, -0.29}
mesh_poly.material          = CMFD_MATERIAL_WHITE
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          =  { {0.02, 0.08}, {0.0, 0.12}, {-0.02, 0.08}} --{ {-0.2, 0.0}, {-0.205,0.005}, {-0.205,-0.005}, {-0.2, 0.0}}
mesh_poly.indices           = { 0 , 1, 2 } --default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"AVIONICS_TRIM_WINGLEFTRIGHT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"rotate_using_parameter",0, math.rad(1) }, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {-0.45, -0.222, 0}
Poly_Text.alignment         = "RightCenter"
Poly_Text.formats           = {"%+3.1f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"AVIONICS_TRIM_UPDOWN", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.60, -0.223}
mesh_poly.material          = CMFD_MATERIAL_WHITE
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          =  { {0,0.0}, {0.045, 0.02}, {0.045,-0.02}} --{ {-0.2, 0.0}, {-0.205,0.005}, {-0.205,-0.005}, {-0.2, 0.0}}
mesh_poly.indices           = { 0 , 1, 2 } --default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"AVIONICS_TRIM_UPDOWN", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"move_up_down_using_parameter",0, 0.000875 }, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.26, -0.17}
mesh_poly.material          = CMFD_MATERIAL_WHITE
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          =  { {0.02, 0.045}, {0,0.0}, {-0.02, 0.045}} --{ {-0.2, 0.0}, {-0.205,0.005}, {-0.205,-0.005}, {-0.2, 0.0}}
mesh_poly.indices           = { 0 , 1, 2 } --default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"AVIONICS_TRIM_RUDDERLEFTRIGHT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"move_left_right_using_parameter",0, 0.000775 }, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.333, -0.566, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.09, 0.035}, {0.09,0.035}, {0.09,-0.035}, {-0.09, -0.035} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_FUEL_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_CYAN
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X1
Poly_Text.init_pos          = {0.333, -0.566, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%3.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_FUEL", "EICAS_FUEL_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.1, -0.92, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.06, 0.03}, {0.06,0.03}, {0.06,-0.03}, {-0.06, -0.03} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_FUEL_LEFT_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_CYAN
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {0.1, -0.92, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%0.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_FUEL_LEFT", "EICAS_FUEL_LEFT_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.566, -0.92, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { {-0.06, 0.03}, {0.06,0.03}, {0.06,-0.03}, {-0.06, -0.03} }
mesh_poly.indices           = default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_FUEL_RIGHT_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0 , 1.95, 2.05}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_CYAN
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {0.566, -0.92, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%0.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_FUEL_RIGHT", "EICAS_FUEL_RIGHT_COR", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0},
                                {"change_color_when_parameter_equal_to_number",1 , 2,-1,-1,-1},
                                {"opacity_using_parameter", 2}
                              }
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          =  {0.337, -0.481, 0}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
SetCircleMeshStartEnd(mesh_poly, 0.274, 0.228, 209, -238)
mesh_poly.isvisible         = false -- mask only
mesh_poly.h_clip_relation = h_clip_relations.INCREASE_IF_LEVEL
mesh_poly.element_params    = {"EICAS_FUEL_TOT_ROT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"rotate_using_parameter",0, 1.0 }, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          =  {0.337, -0.481, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
SetCircleMeshStartEnd(mesh_poly, 0.274, 0.228, 209, -22)
mesh_poly.isvisible         = true
mesh_poly.level             = page_root.level + 1
mesh_poly.h_clip_relation = h_clip_relations.COMPARE
mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"opacity_using_parameter", 0}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          =  {0.337, -0.481, 0}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
SetCircleMeshStartEnd(mesh_poly, 0.274, 0.228, 187, -97)
mesh_poly.isvisible         = true
mesh_poly.level             = page_root.level + 1
mesh_poly.h_clip_relation = h_clip_relations.COMPARE
mesh_poly.element_params    = {"EICAS_FUEL_TOT_ROT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0, math.rad(-1), math.rad(230)}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          =  {0.337, -0.481, 0}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
SetCircleMeshStartEnd(mesh_poly, 0.274, 0.228, 90, -119)
mesh_poly.isvisible         = true
mesh_poly.level             = page_root.level + 1
mesh_poly.h_clip_relation = h_clip_relations.COMPARE
mesh_poly.element_params    = {"EICAS_FUEL_TOT_ROT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_in_range",0, math.rad(-1), math.rad(119) }, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          =  {0.337, -0.481, 0}
mesh_poly.material          = CMFD_MATERIAL_BLUE
mesh_poly.primitivetype     = "triangles"
SetCircleMeshStartEnd(mesh_poly, 0.225, 0.18, 209, -79.5)
mesh_poly.isvisible         = false -- mask only
mesh_poly.h_clip_relation = h_clip_relations.INCREASE_IF_LEVEL
mesh_poly.element_params    = {"EICAS_FUEL_INT_ROT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"rotate_using_parameter",0, 1.0 }, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          =  {0.337, -0.481, 0}
mesh_poly.material          = CMFD_MATERIAL_RED
mesh_poly.primitivetype     = "triangles"
SetCircleMeshStartEnd(mesh_poly, 0.225, 0.18, 209, -22)
mesh_poly.isvisible         = true
mesh_poly.level             = page_root.level + 1
mesh_poly.h_clip_relation = h_clip_relations.COMPARE
mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"opacity_using_parameter", 0}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          =  {0.337, -0.481, 0}
mesh_poly.material          = CMFD_MATERIAL_CYAN
mesh_poly.primitivetype     = "triangles"
SetCircleMeshStartEnd(mesh_poly, 0.225, 0.18, 187, -57.5)
mesh_poly.isvisible         = true
mesh_poly.level             = page_root.level + 1
mesh_poly.h_clip_relation = h_clip_relations.COMPARE
mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"opacity_using_parameter", 0}}
AddElementObject(mesh_poly)
mesh_poly = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {0.316, -0.05, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%3.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_FUEL_FLOW", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}
AddToUpper(Poly_Text)
Poly_Text = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {0.925, -0.873, 0}
Poly_Text.alignment         = "RightCenter"
Poly_Text.formats           = {"%3.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_FUEL_JOKER", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.338, -0.5}
mesh_poly.material          = CMFD_MATERIAL_WHITE
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          =  { {0.02, 0.33}, {0.0, 0.29}, {-0.02, 0.33}} --{ {-0.2, 0.0}, {-0.205,0.005}, {-0.205,-0.005}, {-0.2, 0.0}}
mesh_poly.indices           = { 0 , 1, 2 } --default_box_indices
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_FUEL_JOKER_ROT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"rotate_using_parameter",0, 1.0 }, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_W
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {0.888, -0.259, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%s"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_INIT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"parameter_compare_with_number",0,1}, {"opacity_using_parameter", 1}}
Poly_Text.value             = "INIT"
AddToUpper(Poly_Text)
Poly_Text = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_W
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {0.888, -0.259, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%s"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_INIT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"parameter_compare_with_number",0,0}, {"opacity_using_parameter", 1}}
Poly_Text.value             = "DETOT"
AddToUpper(Poly_Text)
Poly_Text = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.888, -0.17, 0}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { 
                                {-0.05, 0}, {-0.045, 0}, {0.0,0.04},  {0.0, 0.045}, 
                                {0.045, 0}, {0.05, 0}, {-0.045, 0.005}, {0.045, 0.005}
                              }
mesh_poly.indices           = {0,1,2, 2,3,0, 4,5,2, 2,5,3, 1,4,6, 6,4,7 }
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_INIT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_compare_with_number",0 , 1}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil

mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {0.888, -0.403, 0}
mesh_poly.material          = CMFD_MATERIAL_DEF
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { 
                                {-0.05, 0}, {-0.045, 0}, {0.0,-0.04},  {0.0, -0.045}, 
                                {0.045, 0}, {0.05, 0}, {-0.045, -0.005}, {0.045, -0.005}
                              }
mesh_poly.indices           = {0,1,2, 2,3,0, 4,5,2, 2,5,3, 1,4,6, 6,4,7 }
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_INIT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"parameter_compare_with_number",0 , 1}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
Poly_Text.init_pos          = {0.925, -0.324, 0}
Poly_Text.alignment         = "RightCenter"
Poly_Text.formats           = {"%4.0f"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_FUEL_INIT", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0}, {"opacity_using_parameter", 1}}
AddToUpper(Poly_Text)
Poly_Text = nil

Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.name              = "EICAS_Flaps"
Poly_Text.material          = CMFD_FONT_W
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X1
Poly_Text.init_pos          = {-0.753, -0.575, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%s"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_FLAP_TXT", "EICAS_FLAP", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0}, {"change_color_when_parameter_equal_to_number",1 , 1, 0,1,0}, {"opacity_using_parameter", 2}}
Poly_Text.value             = "DOWN"
AddToUpper(Poly_Text)
Poly_Text = nil

local HW = 0.10
local HH = 0.04 * H2W_SCALE
local w=0.01
mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = "EICAS_Flaps"
mesh_poly.init_pos          = {0.0, 0.0}
mesh_poly.material          = CMFD_MATERIAL_WHITE
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { 
                                {-HW-w, HH+w}, {HW+w,HH+w}, {HW+w,HH}, {-HW-w, HH },
                                {-HW-w, HH+w}, {-HW,HH+w}, {-HW,-HH-w}, {-HW-w, -HH-w },
                                {-HW-w, -HH}, {HW+w,-HH}, {HW+w,-HH-w}, {-HW-w, -HH-w },
                                {HW, HH+w}, {HW+w,HH+w}, {HW+w,-HH-w}, {HW, -HH-w },
                              }
mesh_poly.indices           = {0,1,2, 0,2,3,  4,5,6,  4,6,7,  8,9,10, 8,10,11,  12,13,14, 12,14,15 }
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_FLAP", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"change_color_when_parameter_equal_to_number",0 , 1, 0,1,0}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


Poly_Text                   = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_W
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X1
Poly_Text.init_pos          = {-0.3474, -0.575, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.formats           = {"%s"}
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params    = {"EICAS_SPD_BRK_TXT", "EICAS_SPD_BRK", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
Poly_Text.controllers       = {{"text_using_parameter",0,0}, {"change_color_when_parameter_equal_to_number",1 , 1, 0,1,0}, {"opacity_using_parameter", 2}}
Poly_Text.value             = "CLOSE"
AddToUpper(Poly_Text)
Poly_Text = nil


HW = 0.14
HH = 0.04 * H2W_SCALE
w=0.01
mesh_poly                   = CreateElement "ceMeshPoly"
mesh_poly.parent_element    = page_root.name
mesh_poly.init_pos          = {-0.3474, -0.575, 0}
mesh_poly.material          = CMFD_MATERIAL_WHITE
mesh_poly.primitivetype     = "triangles"
mesh_poly.vertices          = { 
                                {-HW-w, HH+w}, {HW+w,HH+w}, {HW+w,HH}, {-HW-w, HH },
                                {-HW-w, HH+w}, {-HW,HH+w}, {-HW,-HH-w}, {-HW-w, -HH-w },
                                {-HW-w, -HH}, {HW+w,-HH}, {HW+w,-HH-w}, {-HW-w, -HH-w },
                                {HW, HH+w}, {HW+w,HH+w}, {HW+w,-HH-w}, {HW, -HH-w },
                              }
mesh_poly.indices           = {0,1,2, 0,2,3,  4,5,6,  4,6,7,  8,9,10, 8,10,11,  12,13,14, 12,14,15 }
mesh_poly.isvisible         = true
mesh_poly.element_params    = {"EICAS_SPD_BRK", "CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers       = {{"change_color_when_parameter_equal_to_number",0 , 1, 0,1,0}, {"opacity_using_parameter", 1}}
AddElementObject(mesh_poly)
mesh_poly = nil


EICAS_ERROR_POS = {
  {-0.727, 1.2, 0},
  {-0.364, 1.2, 0},
  {0, 1.2, 0},
  {0.364, 1.2, 0},
  {0.727, 1.2, 0},
  {-0.727, 1.07, 0},
  {-0.364, 1.07, 0},
  {0, 1.07, 0},
  {0.364, 1.07, 0},
  {0.727, 1.07, 0},
}

for i=1,10 do
  Poly_Text                   = CreateElement "ceStringPoly"
  Poly_Text.material          = CMFD_FONT_W
  Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X06
  Poly_Text.init_pos          = EICAS_ERROR_POS[i]
  Poly_Text.alignment         = "CenterCenter"
  Poly_Text.formats           = {"%s"}
  Poly_Text.parent_element    = page_root.name
  Poly_Text.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "EICAS_ERROR"..i.."_TEXT", "EICAS_ERROR"..i.."_COLOR"}
  Poly_Text.controllers       = { {"opacity_using_parameter", 0},
                                  {"text_using_parameter",1,0}, 
                                  {"parameter_in_range", 2, 0.95, 5.05},
                                  {"change_color_when_parameter_equal_to_number",2 , 0, 0,0,0},
                                  {"change_color_when_parameter_equal_to_number",2 , 1, 1,0,0},
                                  {"change_color_when_parameter_equal_to_number",2 , 2, 1,1,0},
                                  {"change_color_when_parameter_equal_to_number",2 , 3, 0,1,1},
                                  {"change_color_when_parameter_equal_to_number",2 , 4, -1,0,0},
                                  {"change_color_when_parameter_equal_to_number",2 , 5, -1,-1,-1},
                                }
  Poly_Text.value             = "OIL PRESS"
  AddToUpper(Poly_Text)
  Poly_Text = nil
  
  
  HW = 0.155
  HH = 0.025 * H2W_SCALE
  w=0.01
  
  mesh_poly                   = CreateElement "ceMeshPoly"
  mesh_poly.parent_element    = page_root.name
  mesh_poly.init_pos          =  EICAS_ERROR_POS[i]
  mesh_poly.material          = CMFD_MATERIAL_DEF
  mesh_poly.primitivetype     = "triangles"
  mesh_poly.vertices          = { {-HW-w, HH+w}, {HW+w, HH+w}, {HW+w,-HH-w}, {-HW-w, -HH-w },}
  mesh_poly.indices           = default_box_indices
  mesh_poly.isvisible         = true
  mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "EICAS_ERROR"..i.."_COLOR"}
  mesh_poly.controllers       = {{"opacity_using_parameter", 0},
                                  {"parameter_in_range",1 , 3.95, 5.05},
                                  {"change_color_when_parameter_equal_to_number",1 , 4, 1,0,0},
                                  {"change_color_when_parameter_equal_to_number",1 , 5, 1,1,0},
                                }
  AddElementObject(mesh_poly)
  mesh_poly = nil
  
  mesh_poly                   = CreateElement "ceMeshPoly"
  mesh_poly.parent_element    = page_root.name
  mesh_poly.init_pos          = EICAS_ERROR_POS[i]
  mesh_poly.material          = CMFD_MATERIAL_WHITE
  mesh_poly.primitivetype     = "triangles"
  mesh_poly.vertices          = { 
                                  {-HW-w, HH+w}, {HW+w,HH+w}, {HW+w,HH}, {-HW-w, HH },
                                  {-HW-w, HH+w}, {-HW,HH+w}, {-HW,-HH-w}, {-HW-w, -HH-w },
                                  {-HW-w, -HH}, {HW+w,-HH}, {HW+w,-HH-w}, {-HW-w, -HH-w },
                                  {HW, HH+w}, {HW+w,HH+w}, {HW+w,-HH-w}, {HW, -HH-w },
                                }
  mesh_poly.indices           = {0,1,2, 0,2,3,  4,5,6,  4,6,7,  8,9,10, 8,10,11,  12,13,14, 12,14,15 }
  mesh_poly.isvisible         = true
  mesh_poly.element_params    = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "EICAS_ERROR"..i.."_COLOR"}
  mesh_poly.controllers       = {{"opacity_using_parameter", 0},
                                  {"parameter_in_range",1 , 0.95, 3.05},
                                  {"change_color_when_parameter_equal_to_number",1 , 1, 1,0,0},
                                  {"change_color_when_parameter_equal_to_number",1 , 2, 1,1,0},
                                  {"change_color_when_parameter_equal_to_number",1 , 3, 0,1,1},
                                }
  AddElementObject(mesh_poly)
  mesh_poly = nil
  
end

