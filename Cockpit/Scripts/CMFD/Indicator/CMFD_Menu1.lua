dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")

local page_root = create_page_root()
page_root.element_params = {"CMFD2Format"}
page_root.controllers = {{"parameter_in_range",0,SUB_PAGE_ID.MENU1 - 0.05, SUB_PAGE_ID.MENU1 + 0.05}}


-- local Poly_Text             = CreateElement "ceStringPoly"
-- Poly_Text.material          = CMFD_FONT_DEF
-- Poly_Text.stringdefs        = CMFD_STRINGDEFS_DEF_X2
-- Poly_Text.init_pos          = {0, 0, 0}
-- Poly_Text.alignment         = "CenterCenter"
-- Poly_Text.value             = "MENU1\nAVAILABLE IN\nTWO WEEKS"
-- Poly_Text.parent_element    = page_root.name
-- AddToUpper(Poly_Text)
-- Poly_Text = nil

local HW = 0.15
local HH = 0.04 * H2W_SCALE

local osb_txt = {
    {value="MENU\n1",       init_pos={CMFD_FONT_UD1_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={}},
    {value="MSMD\nRST",     init_pos={CMFD_FONT_UD2_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={}},
    {value=" ",             init_pos={CMFD_FONT_UD3_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={}},
    {value="SG\nRST",       init_pos={CMFD_FONT_UD4_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={}},
    {value=" ",             init_pos={CMFD_FONT_UD5_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={}},
    {value=" ",             init_pos={CMFD_FONT_UD6_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={}},

    {value="DTE",           init_pos={CMFD_FONT_R_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={}},
    {value="FLIR",          init_pos={CMFD_FONT_R_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={}},
    {value="DVR",           init_pos={CMFD_FONT_R_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={}},
    {value="EMER",          init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={}},
    {value="PFL",           init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={}},
    {value="BIT",           init_pos={CMFD_FONT_R_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={}},
    {value="NAV",           init_pos={CMFD_FONT_R_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={}},
    {value=" ",             init_pos={CMFD_FONT_R_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={}},

    -- {value="DCLT",          init_pos={CMFD_FONT_UD6_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value="HSD",           init_pos={CMFD_FONT_UD5_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value=" ",             init_pos={CMFD_FONT_UD4_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value="SWAP",          init_pos={CMFD_FONT_UD3_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value="SMS",           init_pos={CMFD_FONT_UD2_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value="IND",           init_pos={CMFD_FONT_UD1_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={}},
    {value="EICAS",         init_pos={CMFD_FONT_L_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={}},
    {value="UFCP",          init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={}},
    {value="ADHSI",         init_pos={CMFD_FONT_L_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={}},
    {value="EW",            init_pos={CMFD_FONT_L_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={}},
    {value="SMS",           init_pos={CMFD_FONT_L_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={}},
    {value="HUD",           init_pos={CMFD_FONT_L_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={}},
    {value="HSD",           init_pos={CMFD_FONT_L_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={}},
}

local text_strpoly
local mesh_poly

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

-- Selecionado
for i=1, #(osb_txt) do
    mesh_poly                = CreateElement "ceMeshPoly"
    mesh_poly.name             = "OSBTITLE" .. i
    mesh_poly.parent_element= "osb_txt_" .. i
    if osb_txt[i].align == "LeftCenter" then
        mesh_poly.init_pos = { HW, 0}
    elseif osb_txt[i].align == "RightCenter" then
        mesh_poly.init_pos = {-HW, 0}
    elseif osb_txt[i].align == "CenterTop" then
        mesh_poly.init_pos = {0, -HW}
    else
        mesh_poly.init_pos = {0, 0}
    end
    mesh_poly.material        = CMFD_MATERIAL_DEF
    mesh_poly.primitivetype    = "lines"
    mesh_poly.vertices        = { {HW, HH}, {HW,-HH}, {-HW,-HH}, {-HW, HH }}
    mesh_poly.indices        = {0,1,1,2,2,3,3,0}
    mesh_poly.isvisible        = false
    mesh_poly.element_params    = {""}
    AddElementObject(mesh_poly)
    mesh_poly = nil
end

-- Sublinhado
for i=1, #(osb_txt) do
    mesh_poly                = CreateElement "ceMeshPoly"
    mesh_poly.name             = "OSBUNDER" .. i
    mesh_poly.parent_element= "osb_txt_" .. i
    if osb_txt[i].align == "LeftCenter" then
        mesh_poly.init_pos = { HW, 0}
    else
        if osb_txt[i].align == "RightCenter" then
            mesh_poly.init_pos = {-HW, 0}
        end
    end
    mesh_poly.material        = CMFD_MATERIAL_DEF
    mesh_poly.primitivetype    = "lines"
    mesh_poly.vertices        = { { HW, -1.2*HH},    {-HW, -1.2*HH},}
    mesh_poly.indices        = {0,1}
    mesh_poly.isvisible        = false
    AddElementObject(mesh_poly)
    mesh_poly = nil
end

-- Indisponível
for i=1, #(osb_txt) do
    mesh_poly                = CreateElement "ceMeshPoly"
    mesh_poly.name             = "OSBNA" .. i
    mesh_poly.parent_element= "osb_txt_" .. i
    if osb_txt[i].align == "LeftCenter" then
        mesh_poly.init_pos = { HW, 0, 0}
    elseif osb_txt[i].align == "RightCenter" then
        mesh_poly.init_pos = {-HW, 0, 0}
    elseif osb_txt[i].align == "CenterTop" then
        mesh_poly.init_pos = {0, -HW, 0}
    else
        mesh_poly.init_pos = {0, 0, 0}
    end
    mesh_poly.material        =  CMFD_IND_MATERIAL
    mesh_poly.primitivetype    = "lines"
    mesh_poly.vertices        = { { HW, HH},{-HW, -HH}, }
    mesh_poly.indices        = {0,1}
    mesh_poly.isvisible        = false
    AddElementObject(mesh_poly)
    mesh_poly = nil
end
