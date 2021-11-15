dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

local page_root = create_page_root()
page_root.element_params = {"CMFD"..CMFDNu.."Format"}
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.CHECKLIST}}

local Poly_Text        = CreateElement "ceStringPoly"
Poly_Text.material    = CMFD_FONT_DEF
Poly_Text.stringdefs= CMFD_STRINGDEFS_DEF_X08
Poly_Text.init_pos    = {0, 0, 0}
Poly_Text.alignment    = "CenterCenter"
Poly_Text.value        = "CL VERSION 0.0\n\n\nUPDATE 01.01.2006\n\n\n\n\n\n\n\n\n\n\n"
Poly_Text.parent_element    = page_root.name
Poly_Text.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}
Poly_Text.controllers = {{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}

AddToUpper(Poly_Text)
Poly_Text = nil

-- OSS Menus
local HW = 0.15
local HH = 0.04 * H2W_SCALE

local osb_txt = {
    {value="CHECK\nLIST ",   init_pos={CMFD_FONT_UD1_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}, material=CMFD_FONT_DEF},
    {value=" ",             init_pos={CMFD_FONT_UD2_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}, material=CMFD_FONT_DEF},
    {value="NORM\nPROC",     init_pos={CMFD_FONT_UD3_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}, material=CMFD_FONT_DEF},
    {value=" ",             init_pos={CMFD_FONT_UD4_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}, material=CMFD_FONT_DEF},
    {value=" ",             init_pos={CMFD_FONT_UD5_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}, material=CMFD_FONT_DEF},
    {value=" ",             init_pos={CMFD_FONT_UD6_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}, material=CMFD_FONT_DEF},

    {value=" ",             init_pos={CMFD_FONT_R_HORI_X, ( 5.85*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="FLT\nWARN",     init_pos={CMFD_FONT_R_HORI_X, ( 4.35*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_R},
    {value="FLT\nCAUT",     init_pos={CMFD_FONT_R_HORI_X, ( 2.55*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_Y},
    {value="FLT\nGNRL",     init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_W},
    {value="LAND\nWARN",    init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_R},
    {value="LAND\nCAUT",    init_pos={CMFD_FONT_R_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_Y},
    {value="LAND\nGNRL",    init_pos={CMFD_FONT_R_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_W},
    {value=" ",             init_pos={CMFD_FONT_R_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="TKOFF\nGNRL",   init_pos={CMFD_FONT_L_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_W},
    {value="TKOFF\nCAUT",   init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_Y},
    {value="TKOFF\nWARN",   init_pos={CMFD_FONT_L_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_R},
    {value="GND\nGNRL",     init_pos={CMFD_FONT_L_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_W},
    {value="GND\nCAUT",     init_pos={CMFD_FONT_L_HORI_X, ( 2.55*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_Y},
    {value="GND\nWARN",     init_pos={CMFD_FONT_L_HORI_X, ( 4.35*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_R},
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, ( 5.85*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},

    {value="MAIN",          init_pos={CMFD_FONT_UD5_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_in_range", 1, 0.5, 2.5}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="MORE",          init_pos={CMFD_FONT_UD6_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_in_range", 1, 0.5, 2.5}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},

    {value="9",             init_pos={CMFD_FONT_R_HORI_X, ( 5.85*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="10",            init_pos={CMFD_FONT_R_HORI_X, ( 4.35*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="11",            init_pos={CMFD_FONT_R_HORI_X, ( 2.55*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="12",            init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="13",            init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="14",            init_pos={CMFD_FONT_R_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="15",            init_pos={CMFD_FONT_R_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="16",            init_pos={CMFD_FONT_R_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    
    {value="8",             init_pos={CMFD_FONT_L_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="7",             init_pos={CMFD_FONT_L_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="6",             init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="5",             init_pos={CMFD_FONT_L_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="4",             init_pos={CMFD_FONT_L_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="3",             init_pos={CMFD_FONT_L_HORI_X, ( 2.55*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="2",             init_pos={CMFD_FONT_L_HORI_X, ( 4.35*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="1",             init_pos={CMFD_FONT_L_HORI_X, ( 5.85*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},

    {value="25",             init_pos={CMFD_FONT_R_HORI_X, ( 5.85*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="26",            init_pos={CMFD_FONT_R_HORI_X, ( 4.35*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="27",            init_pos={CMFD_FONT_R_HORI_X, ( 2.55*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="28",            init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="29",            init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="30",            init_pos={CMFD_FONT_R_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="31",            init_pos={CMFD_FONT_R_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="32",            init_pos={CMFD_FONT_R_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    
    {value="24",             init_pos={CMFD_FONT_L_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="23",             init_pos={CMFD_FONT_L_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="22",             init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="21",             init_pos={CMFD_FONT_L_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="20",             init_pos={CMFD_FONT_L_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="19",             init_pos={CMFD_FONT_L_HORI_X, ( 2.55*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="18",             init_pos={CMFD_FONT_L_HORI_X, ( 4.35*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
    {value="17",             init_pos={CMFD_FONT_L_HORI_X, ( 5.85*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, 2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_CHECKLIST_LEVEL"}, material=CMFD_FONT_DEF},
}

local text_strpoly
local mesh_poly

for i=1, #(osb_txt) do
    text_strpoly                = CreateElement "ceStringPoly"
    text_strpoly.material       = osb_txt[i].material
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