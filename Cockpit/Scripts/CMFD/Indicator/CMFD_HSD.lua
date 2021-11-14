dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "Systems/avionics_api.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

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
page_root.controllers = {{"parameter_compare_with_number",0,SUB_PAGE_ID.HSD}}
default_parent      = page_root.name


local aspect = GetAspect()

local object

local CMFD_HSD_origin = addPlaceholder(nil, {0,0}, page_root.name)

------------------- HSI
stroke_thickness  = 0.25 --0.25
stroke_fuzziness  = 0.3
local HSI_radius = 0.3
local HSI_tick_lenght = 0.035

local HSI_Origin = addPlaceholder("HSI_Origin", {0, -0.33})
local HSI_Origin_Rot = addPlaceholder("HSI_Origin_Rot", {0,0}, HSI_Origin.name)
HSI_Origin_Rot.element_params = {"AVIONICS_HDG"}
HSI_Origin_Rot.controllers = {{"rotate_using_parameter", 0, math.rad(1)}}

for i = 0, 350, 10 do
    if i % 30 ~= 0 then
        object = addStrokeLine("HSI_tick_"..i, HSI_tick_lenght, {HSI_radius * math.sin(math.rad(i)), HSI_radius * math.cos(math.rad(i))}, -i, HSI_Origin_Rot.name, nil, nil, nil, nil, "CMFD_IND_WHITE")
    else
        local text
        if i == 0 then text = "N"
        elseif i == 90 then text = "E"
        elseif i == 180 then text = "S"
        elseif i == 270 then text = "W"
        else text = string.format("%02.0f", i/10)
        end
        object = addStrokeText("HSI_text_"..i, text, CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {(HSI_radius+HSI_tick_lenght/2) * math.sin(math.rad(i)), (HSI_radius+HSI_tick_lenght/2) * math.cos(math.rad(i))}, HSI_Origin_Rot.name, nil, {"%s"},CMFD_FONT_W)
        object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_HDG"}
        object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 1, -math.rad(1)}}
    end
end

-- RAD SEL
object = addStrokeText("HSI_RAD_SEL_text", "20", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.9, 0.850}, nil, nil, {"%3.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "HSD_RAD_SEL"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}

object = addOSSArrow(28, 1, CMFD_HSD_origin.name)
object = addOSSArrow(27, 0, CMFD_HSD_origin.name)

-- GPS Arrow
stroke_thickness  = 1.5 --0.25
stroke_fuzziness  = 0.6
local HSI_GPS_Origin = addPlaceholder("HSI_GPS_Origin", {0,0}, HSI_Origin_Rot.name)
HSI_GPS_Origin.element_params = {"ADHSI_GPS_HDG", "AVIONICS_ANS_MODE"}
HSI_GPS_Origin.controllers = {{"rotate_using_parameter", 0, -math.rad(1)}, {"parameter_in_range",0 , -0.05, 360.05}, {"parameter_compare_with_number", 1, AVIONICS_ANS_MODE_IDS.GPS}}
object = addStrokeBox("HSI_GPS_box", 0.02, 0.04, "CenterCenter", {0,-HSI_radius + 2* HSI_tick_lenght}, HSI_GPS_Origin.name, nil, "CMFD_IND_BLUE")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addStrokeBox("HSI_GPS_box1", 0.03, 0.03, "CenterCenter", {0,HSI_radius - 2* HSI_tick_lenght}, HSI_GPS_Origin.name, nil, "CMFD_IND_BLUE")
object.init_rot = {45}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- GPS DATA Indicator
object = addStrokeText("HSI_GPS_DATA_text", "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.6, -0.086}, nil, nil, {"GPS\n", "%03.0f`\n", "%2.1f\n", "%02.0f:", "%02.0f"}, CMFD_FONT_B)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT",  "ADHSI_GPS_HDG", "ADHSI_GPS_DIST", "ADHSI_GPS_MIN", "ADHSI_GPS_SEC", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_in_range", 1, -0.05, 360.05}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 1, 1}, {"text_using_parameter", 2, 2}, {"text_using_parameter", 3, 3}, {"text_using_parameter", 4, 4}, {"parameter_compare_with_number", 5, AVIONICS_ANS_MODE_IDS.GPS}}
object = addStrokeText("HSI_GPS_NOATA_text", "GPS\nXXX`\nX.XX\nXX:XX", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {-0.6, -0.086}, nil, nil, nil, CMFD_FONT_B)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT",  "ADHSI_GPS_HDG", "ADHSI_GPS_DIST", "ADHSI_GPS_MIN", "ADHSI_GPS_SEC", "AVIONICS_ANS_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, -1}, {"text_using_parameter", 1, 0}, {"text_using_parameter", 1, 1}, {"text_using_parameter", 2, 2}, {"text_using_parameter", 3, 3}, {"text_using_parameter", 4, 4}, {"parameter_compare_with_number", 5, AVIONICS_ANS_MODE_IDS.GPS}}

stroke_thickness  = 0.5 --0.25
stroke_fuzziness  = 0.6

-- FYT DTK Arrow
stroke_thickness  = 1.5 --0.25
stroke_fuzziness  = 0.6
local HSI_FYT_Origin = addPlaceholder(nil, {0,0}, HSI_Origin_Rot.name)
HSI_FYT_Origin.element_params = {"CMFD_NAV_FYT_VALID", "CMFD_NAV_FYT_DTK_BRG", "AVIONICS_ANS_MODE"}
HSI_FYT_Origin.controllers = {{"rotate_using_parameter", 1, -math.rad(1)}, {"parameter_compare_with_number", 0, 1}, {"parameter_in_range", 2, AVIONICS_ANS_MODE_IDS.EGI-0.05, AVIONICS_ANS_MODE_IDS.GPS + 0.05}}
object = addStrokeBox(nil, 0.03, 0.05, "CenterCenter", {0,-HSI_radius - 2.3* HSI_tick_lenght}, HSI_FYT_Origin.name, nil, "CMFD_IND_MAGENTA")
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}
object = addStrokeBox(nil, 0.02, 0.12, "CenterCenter", {0,HSI_radius + 2.3* HSI_tick_lenght}, HSI_FYT_Origin.name, nil, "CMFD_IND_MAGENTA")
object.vertices = {{0,0.07}, {0.035, 0.02}, {0.015, 0.02}, {0.015,0}, {-0.015, 0}, {-0.015, 0.02}, {-0.035, 0.02}}
object.indices = {0,1, 1,2, 2,3, 3,4, 4,5, 5,6, 6,0}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
object.controllers = {{"opacity_using_parameter", 0}}

-- FYT Point

--[[-- This is the FYT circle
object = addMesh(nil, nil, nil, {0,0}, "triangles", HSI_FYT_Origin.name, nil, "CMFD_IND_MAGENTA")
object = SetMeshCircle(object, 0.02, 10)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FYT_DTK_DIST"}
object.controllers = {{"opacity_using_parameter", 0}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}}

-- This is the FYT text
object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0,0}, HSI_FYT_Origin.name, nil, {" %02.0f"}, CMFD_FONT_MAGENTA)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_NAV_FYT", "CMFD_NAV_FYT_DTK_BRG", "AVIONICS_HDG", "CMFD_HSD_FYT_DTK_DIST"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"move_up_down_using_parameter", 4, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)}, }]]

-- Waypoints
for k=1,100 do
    -- Outer purple circle outline dashed
    object = addStrokeCircle(nil, 0.03, {0,0}, HSI_Origin_Rot.name, nil, nil, 0.5, 0.5, true, "CMFD_IND_MAGENTA")
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_DTK" .. k .. "_DIST", "CMFD_HSD_DTK" .. k .. "_BRG", "CMFD_HSD_DTK" .. k}
    object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"parameter_in_range",1,0.01,100}, {"parameter_compare_with_number", 3, 1}}
    object.thickness = 0.05

    -- Outer purple circle outline
    object = addStrokeCircle(nil, 0.03, {0,0}, HSI_Origin_Rot.name, nil, nil, 0.5, 0.5, false, "CMFD_IND_MAGENTA")
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_WP" .. k .. "_DIST", "CMFD_HSD_WP" .. k .. "_BRG"}
    object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"parameter_in_range",1,0.01,100}}
    object.thickness = 0.01

    -- Inner purple circle fill
    object = addMesh(nil, nil, nil, {0,0}, "triangles", HSI_Origin_Rot.name, nil, "CMFD_IND_MAGENTA")
    object = SetMeshCircle(object, 0.02, 10)
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_WP" .. k .. "_DIST", "CMFD_HSD_WP" .. k .. "_BRG", "CMFD_NAV_FYT"}
    object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 3, k-1}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"parameter_in_range",1,0.01,100}}

    object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0,0}, HSI_Origin_Rot.name, nil, {" %02.0f"}, CMFD_FONT_MAGENTA)
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_WP" .. k .. "_DIST", "CMFD_HSD_WP" .. k .. "_BRG", "CMFD_HSD_WP" .. k .. "_ID", "AVIONICS_HDG"}
    object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 3, 0}, {"parameter_in_range",1,0.01,100}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 4, -math.rad(1)}}
end

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
mesh_poly.tex_coords 		= {{600/2048,800/2048}, {1200/2048,800/2048},{1200/2048,1600/2048},{600/2048,1600/2048}}
mesh_poly.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT"}
mesh_poly.controllers = {{"opacity_using_parameter", 0}}
AddElementObject2(mesh_poly)
mesh_poly = nil

-- OSS Menus

local HW = 0.15
local HH = 0.04 * H2W_SCALE

local osb_txt = {
    {value="MAN",           init_pos={CMFD_FONT_UD1_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0},{"text_using_parameter", 1, 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT","CMFD_DTE_DVR_STATE"}},
    {value=" ",             init_pos={CMFD_FONT_UD2_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="DL",           init_pos={CMFD_FONT_UD3_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",          init_pos={CMFD_FONT_UD4_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="ROUTE\n00-00",           init_pos={CMFD_FONT_UD5_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",             init_pos={CMFD_FONT_UD6_X, H2W_SCALE},                      align="CenterTop",      formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},

    {value="D\nE\nP",      init_pos={CMFD_FONT_R_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",             init_pos={CMFD_FONT_R_HORI_X, ( 4.4*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="S\nY\nM",             init_pos={CMFD_FONT_R_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="A\nN\nM",             init_pos={CMFD_FONT_R_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="R\nO\nU\nT",          init_pos={CMFD_FONT_R_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="CLR\nSTRM",             init_pos={CMFD_FONT_R_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",             init_pos={CMFD_FONT_R_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="BFI",             init_pos={CMFD_FONT_R_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="RightCenter",    formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-6.1*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-4.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",             init_pos={CMFD_FONT_L_HORI_X, (-2.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="ALL",           init_pos={CMFD_FONT_L_HORI_X, (-1.2*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="D\nE\nL",           init_pos={CMFD_FONT_L_HORI_X, ( 0.9*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value="ADHSI",          init_pos={CMFD_FONT_L_HORI_X, ( 2.5*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",            init_pos={CMFD_FONT_L_HORI_X, ( 4.4*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
    {value=" ",           init_pos={CMFD_FONT_L_HORI_X, ( 5.8*1.0/8) * H2W_SCALE},    align="LeftCenter",     formats={"%s"}, controller={{"opacity_using_parameter", 0}}, params={"CMFD"..tostring(CMFDNu).."_BRIGHT"}},
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