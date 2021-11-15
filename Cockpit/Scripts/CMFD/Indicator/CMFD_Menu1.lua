dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

local page_root = create_page_root()
page_root.element_params = {"CMFD"..CMFDNu.."Format"}
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.MENU1}}

local HW = 0.15
local HH = 0.04 * H2W_SCALE

local osb_txt = {
    {value="MENU\n1",       init_pos={CMFD_FONT_UD1_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="MSMD\nRST",     init_pos={CMFD_FONT_UD2_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",             init_pos={CMFD_FONT_UD3_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="SG\nRST",       init_pos={CMFD_FONT_UD4_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",             init_pos={CMFD_FONT_UD5_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",             init_pos={CMFD_FONT_UD6_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},

    {value="DTE",           init_pos={CMFD_FONT_R_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.DTE, -1,-1,-1}}},
    {value="FLIR",          init_pos={CMFD_FONT_R_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.FLIR, -1,-1,-1}}},
    {value="DVR",           init_pos={CMFD_FONT_R_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.DVR, -1,-1,-1}}},
    {value="CHECK\nLIST",   init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.CHECKLIST, -1,-1,-1}}},
    {value="PFL",           init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.PFL, -1,-1,-1}}},
    {value="BIT",           init_pos={CMFD_FONT_R_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.BIT, -1,-1,-1}}},
    {value="NAV",           init_pos={CMFD_FONT_R_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.NAV, -1,-1,-1}}},
    {value=" ",             init_pos={CMFD_FONT_R_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},

    -- {value="DCLT",          init_pos={CMFD_FONT_UD6_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value="HSD",           init_pos={CMFD_FONT_UD5_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value=" ",             init_pos={CMFD_FONT_UD4_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value="SWAP",          init_pos={CMFD_FONT_UD3_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value="SMS",           init_pos={CMFD_FONT_UD2_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    -- {value="IND",           init_pos={CMFD_FONT_UD1_X, -H2W_SCALE},                      align="CenterBottom",   formats={"%s"}, controller={}},
    
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="EICAS",         init_pos={CMFD_FONT_L_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.EICAS, -1,-1,-1}}},
    {value="UFCP",          init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.UFCP, -1,-1,-1}}},
    {value="ADHSI",         init_pos={CMFD_FONT_L_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.ADHSI, -1,-1,-1}}},
    {value="EW",            init_pos={CMFD_FONT_L_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.EW, -1,-1,-1}}},
    {value="SMS",           init_pos={CMFD_FONT_L_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.SMS, -1,-1,-1}}},
    {value="HUD",           init_pos={CMFD_FONT_L_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.HUD, -1,-1,-1}}},
    {value="HSD",           init_pos={CMFD_FONT_L_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD"..CMFDNu.."Sel"}, controller={{"opacity_using_parameter", 0}, {"change_color_when_parameter_equal_to_number", 1, SUB_PAGE_ID.HSD, -1,-1,-1}}},
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
    if osb_txt[i].align == "LeftCenter" or osb_txt[i].align == "RightCenter" then
        mesh_poly                       = CreateElement "ceMeshPoly"
        mesh_poly.name                  = "OSBTITLE" .. i
        mesh_poly.parent_element        = "osb_txt_" .. i
        if osb_txt[i].align == "LeftCenter" then
            mesh_poly.init_pos          = { HW, 0}
        elseif osb_txt[i].align == "RightCenter" then
            mesh_poly.init_pos          = {-HW, 0}
        elseif osb_txt[i].align == "CenterTop" then
            mesh_poly.init_pos          = {0, -HW}
        else
            mesh_poly.init_pos          = {0, 0}
        end
        mesh_poly.material              = CMFD_MATERIAL_DEF
        mesh_poly.primitivetype         = "triangles"
        mesh_poly.vertices              = { {HW, HH}, {HW,-HH}, {-HW,-HH}, {-HW, HH }}
        mesh_poly.indices               = default_box_indices
        mesh_poly.isvisible             = true
        mesh_poly.element_params        = osb_txt[i].params
        if osb_txt[i].controller and osb_txt[i].controller[2] then
            mesh_poly.controllers       = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, osb_txt[i].controller[2][3] - 0.05, osb_txt[i].controller[2][3] + 0.05}}
        else 
            mesh_poly.isvisible         = false
        end

        AddElementObject(mesh_poly)
        mesh_poly = nil
    end
end

-- -- Sublinhado
-- for i=1, #(osb_txt) do
--         mesh_poly                = CreateElement "ceMeshPoly"
--         mesh_poly.name             = "OSBUNDER" .. i
--         mesh_poly.parent_element= "osb_txt_" .. i
--         if osb_txt[i].align == "LeftCenter" then
--             mesh_poly.init_pos = { HW, 0}
--         else
--             if osb_txt[i].align == "RightCenter" then
--                 mesh_poly.init_pos = {-HW, 0}
--             end
--         end
--         mesh_poly.material        = CMFD_MATERIAL_DEF
--         mesh_poly.primitivetype    = "lines"
--         mesh_poly.vertices        = { { HW, -1.2*HH},    {-HW, -1.2*HH},}
--         mesh_poly.indices        = {0,1}
--         mesh_poly.isvisible        = false
--         AddElementObject(mesh_poly)
--         mesh_poly = nil
-- end

-- -- Indisponível
-- for i=1, #(osb_txt) do
--     mesh_poly                = CreateElement "ceMeshPoly"
--     mesh_poly.name             = "OSBNA" .. i
--     mesh_poly.parent_element= "osb_txt_" .. i
--     if osb_txt[i].align == "LeftCenter" then
--         mesh_poly.init_pos = { HW, 0, 0}
--     elseif osb_txt[i].align == "RightCenter" then
--         mesh_poly.init_pos = {-HW, 0, 0}
--     elseif osb_txt[i].align == "CenterTop" then
--         mesh_poly.init_pos = {0, -HW, 0}
--     else
--         mesh_poly.init_pos = {0, 0, 0}
--     end
--     mesh_poly.material        =  CMFD_IND_MATERIAL
--     mesh_poly.primitivetype    = "lines"
--     mesh_poly.vertices        = { { HW, HH},{-HW, -HH}, }
--     mesh_poly.indices        = {0,1}
--     mesh_poly.isvisible        = false
--     AddElementObject(mesh_poly)
--     mesh_poly = nil
-- end
