
dofile(LockOn_Options.script_path .. "Indicator/Indicator_defs.lua")
dofile(LockOn_Options.script_path .. "UFCP/UFCP_pageID_defs.lua")
dofile(LockOn_Options.script_path .. "UFCP/UFCP_Defs.lua")

local page_root = create_page_root()

local aspect = GetAspect()

local object
object = addStrokeText(nil, "A2345678901234567890123A\n123456789012345678901234\n123456789012345678901234\n123456789012345678901234\n123456789012345678901234", STROKE_FNT_UFCP, "CenterCenter", {-GetHalfWidth()}, nil, nil, {"%s"})
object.element_params = {"UFCP_BRIGHT", "UFCP_TEXT"}
object.controllers = {{"opacity_using_parameter", 0}, {"text_using_parameter", 1, 0}}


-- Fields bellow are needed for SRS integration.
object = addStrokeText("com1_freq", "127.00", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%f"})
object.element_params = {"UFCP_COM1_FREQ"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com1_mod", "0", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%1.0f"})
object.element_params = {"UFCP_COM1_MOD"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com1_sql", "0", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%1.0f"})
object.element_params = {"UFCP_COM1_SQL"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com1_pwr", "0", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%f"})
object.element_params = {"UFCP_COM1_PWR"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com1_mode", "1", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%1.0f"})
object.element_params = {"UFCP_COM1_MODE"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com2_freq", "127.00", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%f"})
object.element_params = {"UFCP_COM2_FREQ"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com2_mod", "0", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%1.0f"})
object.element_params = {"UFCP_COM2_MOD"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com2_sql", "0", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%1.0f"})
object.element_params = {"UFCP_COM2_SQL"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com2_pwr", "0", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%f"})
object.element_params = {"UFCP_COM2_PWR"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false

object = addStrokeText("com2_mode", "1", STROKE_FNT_UFCP, "CenterCenter", {0,0}, nil, nil, {"%1.0f"})
object.element_params = {"UFCP_COM2_MODE"}
object.controllers = {{"text_using_parameter", 0,0}}
object.isvisible = false
