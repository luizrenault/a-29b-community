dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")

local page_root = create_page_root()
page_root.element_params = {"CMFD2Format"}
page_root.controllers = {{"parameter_in_range",0,SUB_PAGE_ID.EICAS - 0.05, SUB_PAGE_ID.EICAS + 0.05}}

local aspect = GetAspect()


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
AddElementObject2(mesh_poly)
mesh_poly = nil
