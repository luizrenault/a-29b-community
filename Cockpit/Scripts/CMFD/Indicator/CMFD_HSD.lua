dofile(LockOn_Options.script_path .. "CMFD/CMFD_defs.lua")
dofile(LockOn_Options.script_path .. "CMFD/CMFD_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "Systems/avionics_api.lua")
dofile(LockOn_Options.script_path.."CMFD/CMFD_HSD_ID_defs.lua")

local CMFDNumber=get_param_handle("CMFDNumber")
local CMFDNu = CMFDNumber:get()

local AVD_AREA_VERTEX_COUNT = get_param_handle("HSD_AVD_AREA_VERTEX_COUNT")

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

-- HSI
for i = 0, 350, 10 do
    if i % 30 ~= 0 then
        object = addStrokeLine("HSI_tick_"..i, HSI_tick_lenght, {HSI_radius * math.sin(math.rad(i)), HSI_radius * math.cos(math.rad(i))}, -i, HSI_Origin_Rot.name, nil, nil, nil, nil, "CMFD_IND_WHITE")
        object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT"}
        object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}, {"parameter_in_range", 2, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}}
    else
        local text
        if i == 0 then text = "N"
        elseif i == 90 then text = "E"
        elseif i == 180 then text = "S"
        elseif i == 270 then text = "W"
        else text = string.format("%02.0f", i/10)
        end
        object = addStrokeText("HSI_text_"..i, text, CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {(HSI_radius+HSI_tick_lenght/2) * math.sin(math.rad(i)), (HSI_radius+HSI_tick_lenght/2) * math.cos(math.rad(i))}, HSI_Origin_Rot.name, nil, {"%s"},CMFD_FONT_W)
        object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "AVIONICS_HDG", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT"}
        object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 1, -math.rad(1)}, {"parameter_compare_with_number", 2, 0}, {"parameter_in_range", 3, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}}
    end
end

-- RAD SEL
object = addStrokeText("HSI_RAD_SEL_text", "20", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {-0.9, 0.850}, nil, nil, {"%3.0f"})
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "HSD_RAD_SEL", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

object = addOSSArrow(28, 1, CMFD_HSD_origin.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

object = addOSSArrow(27, 0, CMFD_HSD_origin.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

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
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}, {"parameter_in_range", 2, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}}
object = addStrokeBox(nil, 0.02, 0.12, "CenterCenter", {0,HSI_radius + 2.3* HSI_tick_lenght}, HSI_FYT_Origin.name, nil, "CMFD_IND_MAGENTA")
object.vertices = {{0,0.07}, {0.035, 0.02}, {0.015, 0.02}, {0.015,0}, {-0.015, 0}, {-0.015, 0.02}, {-0.035, 0.02}}
object.indices = {0,1, 1,2, 2,3, 3,4, 4,5, 5,6, 6,0}
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}, {"parameter_in_range", 2, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}}

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

    -- TODO don't hide waypoints when WP is checked if they are part of a selected route 

    -- Outer purple circle outline dashed
    object = addStrokeCircle(nil, 0.03, {0,0}, HSI_Origin_Rot.name, nil, nil, 0.5, 0.5, true, "CMFD_IND_MAGENTA")
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_DTK" .. k .. "_DIST", "CMFD_HSD_DTK" .. k .. "_BRG", "CMFD_HSD_DTK" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_WP_CHECKED"}
    object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"parameter_in_range",1,0.01,100}, {"parameter_compare_with_number", 3, 1}, {"parameter_compare_with_number", 4, 0}, {"parameter_in_range", 5, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 6, 0}}
    object.thickness = 0.05

    -- Outer purple circle outline
    object = addStrokeCircle(nil, 0.03, {0,0}, HSI_Origin_Rot.name, nil, nil, 0.5, 0.5, false, "CMFD_IND_MAGENTA")
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_WP" .. k .. "_DIST", "CMFD_HSD_WP" .. k .. "_BRG", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_WP_CHECKED"}
    object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"parameter_in_range",1,0.01,100}, {"parameter_compare_with_number", 3, 0}, {"parameter_in_range", 4, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 5, 0}}
    object.thickness = 0.01

    -- Inner purple circle fill
    object = addMesh(nil, nil, nil, {0,0}, "triangles", HSI_Origin_Rot.name, nil, "CMFD_IND_MAGENTA")
    object = SetMeshCircle(object, 0.02, 10)
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_WP" .. k .. "_DIST", "CMFD_HSD_WP" .. k .. "_BRG", "CMFD_NAV_FYT", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_WP_CHECKED"}
    object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 3, k-1}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"parameter_in_range",1,0.01,100}, {"parameter_compare_with_number", 4, 0}, {"parameter_in_range", 5, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 6, 0}}

    object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "LeftCenter", {0,0}, HSI_Origin_Rot.name, nil, {" %02.0f"}, CMFD_FONT_MAGENTA)
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_WP" .. k .. "_DIST", "CMFD_HSD_WP" .. k .. "_BRG", "CMFD_HSD_WP" .. k .. "_ID", "AVIONICS_HDG", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_WP_CHECKED"}
    object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 3, 0}, {"parameter_in_range",1,0.01,100}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 4, -math.rad(1)}, {"parameter_compare_with_number", 5, 0}, {"parameter_in_range", 6, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 7, 0}}
end

-- Contact line
for k=101,104 do
    -- ERROR the line should be dashed. I changed the addSimpleLine method, but apparently, it didn't work.
    object = addSimpleLine("CNT_LINE1", 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, 0.5, 0.5, true, "CMFD_IND_RED")
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_CNTLINE" .. k .. "_DIST", "CMFD_HSD_CNTLINE" .. k .. "_BRG", "CMFD_HSD_CNTLINE" .. k .. "_BRG2", "CMFD_HSD_CNTLINE" .. k .. "_X", "CMFD_HSD_CNTLINE" .. k .. "_Y", "CMFD_HSD_FORMAT", "CMFD_HSD_INT_CHECKED"}
    object.controllers = {{"opacity_using_parameter", 0},{"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_in_range", 6, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 7, 0}}
end

-- Flight area

-- Yellow areas

        -- Dotted
        for k=201,350 do
            -- ERROR the line should be dashed. I changed the addSimpleLine method, but apparently, it didn't work.
            object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, 0.5, 0.5, true, "CMFD_IND_YELLOW")
            object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA" .. k .. "_DIST", "CMFD_HSD_FLTAREA" .. k .. "_BRG", "CMFD_HSD_FLTAREA" .. k .. "_BRG2", "CMFD_HSD_FLTAREA" .. k .. "_X", "CMFD_HSD_FLTAREA" .. k .. "_Y", "CMFD_HSD_FLTAREA" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA" .. k .. "_TYPE"}
            object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_TYPES.A}}
        end

        -- Dashed
        for k=201,350 do
            -- ERROR the line should be dashed. I changed the addSimpleLine method, but apparently, it didn't work.
            object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, 0.5, 0.5, true, "CMFD_IND_YELLOW")
            object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA" .. k .. "_DIST", "CMFD_HSD_FLTAREA" .. k .. "_BRG", "CMFD_HSD_FLTAREA" .. k .. "_BRG2", "CMFD_HSD_FLTAREA" .. k .. "_X", "CMFD_HSD_FLTAREA" .. k .. "_Y", "CMFD_HSD_FLTAREA" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA" .. k .. "_TYPE"}
            object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_TYPES.D}}
        end

        -- Continuous
        for k=201,350 do
            object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, nil, nil, false, "CMFD_IND_YELLOW")
            object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA" .. k .. "_DIST", "CMFD_HSD_FLTAREA" .. k .. "_BRG", "CMFD_HSD_FLTAREA" .. k .. "_BRG2", "CMFD_HSD_FLTAREA" .. k .. "_X", "CMFD_HSD_FLTAREA" .. k .. "_Y", "CMFD_HSD_FLTAREA" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA" .. k .. "_TYPE"}
            object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_TYPES.G}}
        end

    -- Green areas

        -- Dotted
        for k=201,350 do
            -- ERROR the line should be dashed. I changed the addSimpleLine method, but apparently, it didn't work.
            object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, 0.5, 0.5, true, "CMFD_IND_GREEN")
            object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA" .. k .. "_DIST", "CMFD_HSD_FLTAREA" .. k .. "_BRG", "CMFD_HSD_FLTAREA" .. k .. "_BRG2", "CMFD_HSD_FLTAREA" .. k .. "_X", "CMFD_HSD_FLTAREA" .. k .. "_Y", "CMFD_HSD_FLTAREA" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA" .. k .. "_TYPE"}
            object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_TYPES.B}}
        end

        -- Dashed
        for k=201,350 do
            -- ERROR the line should be dashed. I changed the addSimpleLine method, but apparently, it didn't work.
            object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, 0.5, 0.5, true, "CMFD_IND_GREEN")
            object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA" .. k .. "_DIST", "CMFD_HSD_FLTAREA" .. k .. "_BRG", "CMFD_HSD_FLTAREA" .. k .. "_BRG2", "CMFD_HSD_FLTAREA" .. k .. "_X", "CMFD_HSD_FLTAREA" .. k .. "_Y", "CMFD_HSD_FLTAREA" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA" .. k .. "_TYPE"}
            object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_TYPES.E}}
        end

    -- Purple areas

        -- Dotted
        for k=201,350 do
            -- ERROR the line should be dashed. I changed the addSimpleLine method, but apparently, it didn't work.
            object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, 0.5, 0.5, true, "CMFD_IND_PINK")
            object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA" .. k .. "_DIST", "CMFD_HSD_FLTAREA" .. k .. "_BRG", "CMFD_HSD_FLTAREA" .. k .. "_BRG2", "CMFD_HSD_FLTAREA" .. k .. "_X", "CMFD_HSD_FLTAREA" .. k .. "_Y", "CMFD_HSD_FLTAREA" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA" .. k .. "_TYPE"}
            object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_TYPES.C}}
        end

        -- Dashed
        for k=201,350 do
            -- ERROR the line should be dashed. I changed the addSimpleLine method, but apparently, it didn't work.
            object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, 0.5, 0.5, true, "CMFD_IND_PINK")
            object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA" .. k .. "_DIST", "CMFD_HSD_FLTAREA" .. k .. "_BRG", "CMFD_HSD_FLTAREA" .. k .. "_BRG2", "CMFD_HSD_FLTAREA" .. k .. "_X", "CMFD_HSD_FLTAREA" .. k .. "_Y", "CMFD_HSD_FLTAREA" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA" .. k .. "_TYPE"}
            object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_TYPES.F}}
        end

        -- Continuous
        for k=201,350 do
            object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, nil, nil, false, "CMFD_IND_PINK")
            object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA" .. k .. "_DIST", "CMFD_HSD_FLTAREA" .. k .. "_BRG", "CMFD_HSD_FLTAREA" .. k .. "_BRG2", "CMFD_HSD_FLTAREA" .. k .. "_X", "CMFD_HSD_FLTAREA" .. k .. "_Y", "CMFD_HSD_FLTAREA" .. k, "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA" .. k .. "_TYPE"}
            object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_TYPES.H}}
        end

-- Flight area names

    -- Yellow
    for k=1,25 do
        object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0,0}, HSI_Origin_Rot.name, nil, {" %6s"}, CMFD_FONT_Y)
        object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_DIST", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_BRG", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_ID", "AVIONICS_HDG", "CMFD_HSD_FLTAREA_LABEL" .. k, "CMFD_HSD_ANM_CHECKED", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_COLOR"}
        object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 3, 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 4, -math.rad(1)}, {"parameter_compare_with_number", 5, 1}, {"parameter_compare_with_number", 6, 0}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_COLORS.YELLOW}}
    end

    -- Green
    for k=1,25 do
        object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0,0}, HSI_Origin_Rot.name, nil, {" %6s"}, CMFD_FONT_G)
        object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_DIST", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_BRG", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_ID", "AVIONICS_HDG", "CMFD_HSD_FLTAREA_LABEL" .. k, "CMFD_HSD_ANM_CHECKED", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_COLOR"}
        object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 3, 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 4, -math.rad(1)}, {"parameter_compare_with_number", 5, 1}, {"parameter_compare_with_number", 6, 0}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_COLORS.GREEN}}
    end

    -- Purple
    for k=1,25 do
        object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0,0}, HSI_Origin_Rot.name, nil, {" %6s"}, CMFD_FONT_MAGENTA)
        object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_DIST", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_BRG", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_ID", "AVIONICS_HDG", "CMFD_HSD_FLTAREA_LABEL" .. k, "CMFD_HSD_ANM_CHECKED", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED", "CMFD_HSD_FLTAREA_LABEL" .. k .. "_COLOR"}
        object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 3, 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 4, -math.rad(1)}, {"parameter_compare_with_number", 5, 1}, {"parameter_compare_with_number", 6, 0}, {"parameter_compare_with_number", 7, 0}, {"parameter_in_range", 8, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 9, 0}, {"parameter_compare_with_number", 10, CMFD_HSD_FLTAREA_COLORS.PURPLE}}
    end

-- Avoid areas
for k=110,130 do
    for point=1,AVD_AREA_VERTEX_COUNT:get() do
        -- ERROR the line should be dashed. I changed the addSimpleLine method, but apparently, it didn't work.
        object = addSimpleLine(nil, 0.2, {0, 0}, 0, HSI_Origin_Rot.name, nil, 0.005, 0.1, 0.1, true, "CMFD_IND_RED")
        object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point .. "_DIST", "CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point .. "_BRG", "CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point .. "_BRG2", "CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point .. "_X", "CMFD_HSD_AVDAREA" .. k .. "_POINT" .. point .. "_Y", "CMFD_HSD_AVDAREA" .. k, "CMFD_HSD_FORMAT", "CMFD_HSD_INT_CHECKED"}
        object.controllers = {{"opacity_using_parameter", 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 3, -math.rad(1)},{"line_object_set_point_using_parameters", 1, 4, 5, 0.075 * HSI_radius, 0.075 * HSI_radius}, {"parameter_compare_with_number", 6, 1}, {"parameter_in_range", 7, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 8, 0}}
    end

    object = addStrokeText(nil, "", CMFD_STRINGDEFS_DEF_X08, "CenterCenter", {0,0}, HSI_Origin_Rot.name, nil, {" %2.0f"}, CMFD_FONT_R)
    object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_AVDAREA" .. k .. "_DIST", "CMFD_HSD_AVDAREA" .. k .. "_BRG", "CMFD_HSD_AVDAREA" .. k .. "_ID", "AVIONICS_HDG", "CMFD_HSD_AVDAREA" .. k, "CMFD_HSD_FORMAT", "CMFD_HSD_INT_CHECKED"}
    object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 3, 0}, {"rotate_using_parameter", 2, -math.rad(1)}, {"move_up_down_using_parameter", 1, 0.075 * HSI_radius}, {"rotate_using_parameter", 2, math.rad(1)}, {"rotate_using_parameter", 4, -math.rad(1)}, {"parameter_compare_with_number", 5, 1}, {"parameter_in_range", 6, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}, {"parameter_compare_with_number", 7, 0}}
end

-- Ownship
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
mesh_poly.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
mesh_poly.controllers = {{"opacity_using_parameter", 0},{"parameter_in_range", 1, CMFD_HSD_FORMAT_IDS.HSD-1, CMFD_HSD_FORMAT_IDS.DCTL+1}}
AddElementObject2(mesh_poly)
mesh_poly = nil

-- OSS Menus

local HW = 0.15
local HH = 0.04 * H2W_SCALE

-- HSD format

-- MAN/AUTO
object = addOSSText(1, "MAN", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

-- DL
object = addOSSText(3, "DL", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

-- Route
object = addOSSText(5, "ROUTE\n00-00", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

-- DEP/CTR
object = addOSSText(7, "D\nE\nP", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_DEP_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

object = addOSSText(7, "C\nT\nR", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_DEP_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

-- SYM
object = addOSSText(9, "S\nY\nM", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

object = addOSSStrokeBox(9,3, nil, nil, nil, nil, 1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_SYM_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

-- ANM
object = addOSSText(10, "A\nN\nM", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

object = addOSSStrokeBox(10,3, nil, nil, nil, nil, 1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_ANM_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

-- ROUT
object = addOSSText(11, "R\nO\nU\nT", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

object = addOSSStrokeBox(11,4, nil, nil, nil, nil, 1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_ROUT_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

-- CLR STRM
object = addOSSText(12, "CLR\nSTRM", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

-- BFI
object = addOSSText(14, "BFI", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

object = addOSSStrokeBox(14,1, nil, nil, nil, nil, 3)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_BFI_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

-- ALL/OFF
object = addOSSText(24, "ALL", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_ALL_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 1}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

object = addOSSText(24, "OFF", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_ALL_CHECKED", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, 0}, {"parameter_compare_with_number", 2, CMFD_HSD_FORMAT_IDS.HSD}}

-- DEL
object = addOSSText(25, "D\nE\nL", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

-- ADHSI
object = addOSSText(26, "ADHSI", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.HSD}}

-- DL format

object = addOSSText(3, "DL", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DL}}

object = addOSSStrokeBox(3,1, nil, nil, nil, nil, 2)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DL}}

object = addOSSText(26, "SMTH", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DL}}

object = addOSSStrokeBox(26,1, nil, nil, nil, nil, 4)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT", "CMFD_HSD_SMTH_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DL}, {"parameter_compare_with_number", 2, 1}}

object = addOSSText(27, "MODE", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT", "CMFD_HSD_DL_MODE"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DL}, {"text_using_parameter", 2}}
object.formats = {"%s"}

object = addOSSText(28, "MSG", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DL}}

object = addOSSStrokeBox(28,1, nil, nil, nil, nil, 3)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT", "CMFD_HSD_MSG_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DL}, {"parameter_compare_with_number", 2, 1}}

-- Route format

object = addOSSText(1, "HSD", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(2, "CLR", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(3, "ENT", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(7, "6", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(8, "7", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(9, "8", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(10, "9", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(11, "0", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(24, "5", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(25, "4", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(26, "3", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(27, "2", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

object = addOSSText(28, "1", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.ROUTE}}

-- DCTL format

object = addOSSText(25, "D\nE\nL", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}}

object = addOSSStrokeBox(25,3, nil, nil, nil, nil, 1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}}

object = addOSSText(7, "A\nR\nE\nA", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}}

object = addOSSStrokeBox(7,4, nil, nil, nil, nil, 1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT", "CMFD_HSD_AREA_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}, {"parameter_compare_with_number", 2, 1}}

object = addOSSText(8, "W\nP", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}}

object = addOSSStrokeBox(8,2, nil, nil, nil, nil, 1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT", "CMFD_HSD_WP_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}, {"parameter_compare_with_number", 2, 1}}

object = addOSSText(9, "I\nN\nT", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}}

object = addOSSStrokeBox(9,3, nil, nil, nil, nil, 1)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT", "CMFD_HSD_INT_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}, {"parameter_compare_with_number", 2, 1}}

object = addOSSText(10, "STRM\n120`", page_root.name)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}}

object = addOSSStrokeBox(10,2, nil, nil, nil, nil, 4)
object.element_params = {"CMFD"..tostring(CMFDNu).."_BRIGHT", "CMFD_HSD_FORMAT", "CMFD_HSD_STRM120_CHECKED"}
object.controllers = {{"opacity_using_parameter", 0}, {"parameter_compare_with_number", 1, CMFD_HSD_FORMAT_IDS.DCTL}, {"parameter_compare_with_number", 2, 1}}