dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

local page_root = create_page_root()
page_root.element_params = {"CMFD"..CMFDNu.."Format"}
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.ADHSI}}


local aspect = GetAspect()


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
mesh_poly.tex_coords 		= {{600/2048,0}, {1200/2048,0},{1200/2048,800/2048},{600/2048,800/2048}}
AddElementObject2(mesh_poly)
mesh_poly = nil

local Poly_Text             = CreateElement "ceStringPoly"
Poly_Text.material          = CMFD_FONT_DEF
Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X1
Poly_Text.init_pos          = {0, 0, 0}
Poly_Text.alignment         = "CenterCenter"
Poly_Text.value             = "ADHSI\nAVAILABLE IN\nTWO WEEKS"
Poly_Text.parent_element    = page_root.name
AddToUpper(Poly_Text)
Poly_Text = nil
