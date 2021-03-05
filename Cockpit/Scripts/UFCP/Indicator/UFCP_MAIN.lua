
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "UFCP/UFCP_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "UFCP/UFCP_Defs.lua")

local page_root = create_page_root()

local aspect = GetAspect()

local object
object = addStrokeText(nil, "1234567890123456789012345\n1234567890123456789012345\n1234567890123456789012345\n1234567890123456789012345\n1234567890123456789012345", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%s"})
object.element_params = {"UFCP_BRIGHT", "UFCP_TEXT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}


