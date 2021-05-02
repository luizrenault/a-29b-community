dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path.."CMFD/CMFD_UFCP_ID_defs.lua")

dofile(LockOn_Options.script_path.."utils.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

local aspect = GetAspect()

-- Content

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
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.UFCP}}
default_parent      = page_root.name


local object

local CMFD_UFCP_DED_origin = addPlaceholder(nil, {0,0}, page_root.name)

object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0, 0.5}, CMFD_UFCP_DED_origin.name, nil, {"%s"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "UFCP_TEXT"}
object.controllers = {
                        {"opacity_using_parameter", 0},
                        {"text_using_parameter", 1, 0},
                    }

-- OSS Menus
local HW = 0.15
local HH = 0.04 * H2W_SCALE

local osb_txt = {
    -- UFC1
    {value="UFC1",          init_pos={CMFD_FONT_UD1_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="MAIN",          init_pos={CMFD_FONT_UD2_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="MENU",          init_pos={CMFD_FONT_UD3_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="UP",            init_pos={CMFD_FONT_UD4_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="DOWN",          init_pos={CMFD_FONT_UD5_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="ENT",           init_pos={CMFD_FONT_UD6_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},

    {value="TIME\n6 E ",    init_pos={CMFD_FONT_R_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="MARK\n7   ",    init_pos={CMFD_FONT_R_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="FIX\n8 S",      init_pos={CMFD_FONT_R_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="TIP\n9  ",      init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="M SEL\n0-   ",  init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="A/A",           init_pos={CMFD_FONT_R_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="A/G",           init_pos={CMFD_FONT_R_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="NAV",           init_pos={CMFD_FONT_R_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    
    {value="CLR",           init_pos={CMFD_FONT_L_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="XPDR\n5   ",    init_pos={CMFD_FONT_L_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="WPT\n4 W",      init_pos={CMFD_FONT_L_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="FACK\n3   ",    init_pos={CMFD_FONT_L_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="DA/H\n2 N",     init_pos={CMFD_FONT_L_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="VV\n1 ",        init_pos={CMFD_FONT_L_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC1}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},

    -- UFC2
    {value="UFC2",          init_pos={CMFD_FONT_UD1_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="MAIN",          init_pos={CMFD_FONT_UD2_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="MENU",          init_pos={CMFD_FONT_UD3_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="UP",            init_pos={CMFD_FONT_UD4_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="DOWN",          init_pos={CMFD_FONT_UD5_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="ENT",           init_pos={CMFD_FONT_UD6_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},

    {value="COM 1",         init_pos={CMFD_FONT_R_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="COM 2",         init_pos={CMFD_FONT_R_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="NAV \nAIDS",    init_pos={CMFD_FONT_R_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="IDNT",          init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="BARO\nRALT",    init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="A/A",           init_pos={CMFD_FONT_R_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="A/G",           init_pos={CMFD_FONT_R_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="NAV",           init_pos={CMFD_FONT_R_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    
    {value="CLR",           init_pos={CMFD_FONT_L_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="CFG \nCOM2",    init_pos={CMFD_FONT_L_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="CFG \nCOM1",    init_pos={CMFD_FONT_L_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="WARN\nRST ",    init_pos={CMFD_FONT_L_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="AIR\nSPD",      init_pos={CMFD_FONT_L_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="CZ",            init_pos={CMFD_FONT_L_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC2}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},

    -- UFC3
    {value="UFC3",          init_pos={CMFD_FONT_UD1_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC3}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},

    {value="INS\nOFF",         init_pos={CMFD_FONT_R_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC3}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="INS\nSH ",         init_pos={CMFD_FONT_R_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC3}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="INS\nGC",    init_pos={CMFD_FONT_R_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC3}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="INS\nNAV",          init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC3}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="INS\nTST",    init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC3}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    
    {value="RAL\nXMT",      init_pos={CMFD_FONT_L_HORI_X, ( 4.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC3}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
    {value="RAL\nOFF",            init_pos={CMFD_FONT_L_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0},{"parameter_compare_with_number", 1, CMFD_UFCP_FORMAT_IDS.UFC3}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_UFCP_FORMAT"}},
}

object = addOSSArrow(23, 1, CMFD_UFCP_DED_origin.name)
object = addOSSArrow(22, 0, CMFD_UFCP_DED_origin.name)
object = addOSSArrow(4, 1, CMFD_UFCP_DED_origin.name)
object = addOSSArrow(5, 0, CMFD_UFCP_DED_origin.name)

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