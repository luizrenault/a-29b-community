dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

startup_print("autopilot: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)


function post_initialize()
    startup_print("autopilot: postinit start")
    local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" then
        -- dev:performClickableAction(device_commands.EnvTemp, 0.5, true)
    elseif birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end
    startup_print("autopilot: postinit end")
end

local ap_on = false
local ap_rp = false
local ap_hdg = false
local ap_alt = false
local ap_nav = false
local ap_apr = false
local ap_gs = false

local AP_RP = get_param_handle("AP_RP")
local AP_HDG = get_param_handle("AP_HDG")
local AP_ALT = get_param_handle("AP_ALT")
local AP_TEST = get_param_handle("AP_TEST")
local AP_TEST_ERROR = get_param_handle("AP_TEST_ERROR")
local AP_NAV = get_param_handle("AP_NAV")
local AP_NAV_ERROR = get_param_handle("AP_NAV_ERROR")
local AP_APR = get_param_handle("AP_APR")
local AP_APR_ERROR = get_param_handle("AP_APR_ERROR")
local AP_GS = get_param_handle("AP_GS")
local AP_GS_ERROR = get_param_handle("AP_GS_ERROR")
local AP_ON = get_param_handle("AP_ON")
local AP_ERROR = get_param_handle("AP_ERROR")

local AVIONICS_ANS_MODE = get_param_handle("AVIONICS_ANS_MODE")
local AVIONICS_ANS_MODE_ILS = 3

local ap_test_duration = 2.0
local ap_test_remaining = 0
local was_ap_test_active = false

local override_active = false

local dispatch_ap_mode


function update()
    if ap_test_remaining > 0 then
        ap_test_remaining = math.max(0, ap_test_remaining - update_time_step)
    end

    local ap_test_active = ap_test_remaining > 0
    if ap_test_active then
        was_ap_test_active = true

        -- Lamp-test: force all AP annunciators on for visual verification.
        AP_RP:set(1)
        AP_HDG:set(1)
        AP_ALT:set(1)
        AP_TEST:set(1)
        AP_TEST_ERROR:set(1)
        AP_NAV:set(1)
        AP_NAV_ERROR:set(1)
        AP_APR:set(1)
        AP_APR_ERROR:set(1)
        AP_GS:set(1)
        AP_GS_ERROR:set(1)
        AP_ON:set(1)
        AP_ERROR:set(1)
        return
    end

    AP_RP:set(ap_on and ap_rp and 1 or 0)
    AP_HDG:set(ap_on and ap_hdg and 1 or 0)
    AP_ALT:set(ap_on and ap_alt and 1 or 0)
    AP_TEST:set(0)
    AP_NAV:set(ap_on and ap_nav and 1 or 0)
    AP_APR:set(ap_on and ap_apr and 1 or 0)
    AP_GS:set(ap_on and ap_gs and 1 or 0)
    AP_ON:set(ap_on and 1 or 0)

    local ans_mode = AVIONICS_ANS_MODE:get()
    local nav_error = ap_on and ap_nav and ans_mode == AVIONICS_ANS_MODE_ILS and 1 or 0
    local apr_error = ap_on and ap_apr and ans_mode ~= AVIONICS_ANS_MODE_ILS and 1 or 0
    local gs_error = ap_on and ap_gs and ans_mode ~= AVIONICS_ANS_MODE_ILS and 1 or 0

    AP_TEST_ERROR:set(0)
    AP_NAV_ERROR:set(nav_error)
    AP_APR_ERROR:set(apr_error)
    AP_GS_ERROR:set(gs_error)
    AP_ERROR:set((nav_error == 1 or apr_error == 1 or gs_error == 1) and 1 or 0)

    if was_ap_test_active and not ap_test_active then
        -- Re-issue current AP mode once after lamp-test ends.
        dispatch_ap_mode()
    end
    was_ap_test_active = ap_test_active
end

local iCommandPlaneStabTangBank = 386
local iCommandPlaneStabHbarBank = 387
local iCommandPlaneStabHbar = 389
local iCommandPlaneStabHbarHeading = 636
local iCommandPlaneRouteAutopilot = 429
local iCommandPlaneStabPathHold = 637
local iCommandPlaneStabCancel = 408
local iCommandPlaneAutopilotOverrideOn = 427
local iCommandPlaneAutopilotOverrideOff = 428


dev:listen_command(device_commands.AP_RP)
dev:listen_command(device_commands.AP_HDG)
dev:listen_command(device_commands.AP_ALT)
dev:listen_command(device_commands.AP_TEST)
dev:listen_command(device_commands.AP_NAV)
dev:listen_command(device_commands.AP_APR)
dev:listen_command(device_commands.AP_GS)
dev:listen_command(device_commands.AP_ON)
dev:listen_command(Keys.APOvrd)
dev:listen_command(Keys.APDisengage)


local function clear_ap_modes()
    ap_rp = false
    ap_hdg = false
    ap_alt = false
    ap_nav = false
    ap_apr = false
    ap_gs = false
end

local function resolve_mode_conflicts()
    local active = 0
    if ap_rp then active = active + 1 end
    if ap_hdg then active = active + 1 end
    if ap_alt then active = active + 1 end
    if ap_nav then active = active + 1 end
    if ap_apr then active = active + 1 end
    if ap_gs then active = active + 1 end

    if active <= 1 then
        return
    end

    -- Safety net: if an inconsistent state appears, keep only one mode by deterministic priority.
    local keep_mode
    if ap_rp then
        keep_mode = "rp"
    elseif ap_hdg then
        keep_mode = "hdg"
    elseif ap_alt then
        keep_mode = "alt"
    elseif ap_nav then
        keep_mode = "nav"
    elseif ap_apr then
        keep_mode = "apr"
    elseif ap_gs then
        keep_mode = "gs"
    end

    clear_ap_modes()
    if keep_mode == "rp" then
        ap_rp = true
    elseif keep_mode == "hdg" then
        ap_hdg = true
    elseif keep_mode == "alt" then
        ap_alt = true
    elseif keep_mode == "nav" then
        ap_nav = true
    elseif keep_mode == "apr" then
        ap_apr = true
    elseif keep_mode == "gs" then
        ap_gs = true
    end
end

local function toggle_ap_mode(mode)
    local mode_was_active =
        (mode == "rp" and ap_rp) or
        (mode == "hdg" and ap_hdg) or
        (mode == "alt" and ap_alt) or
        (mode == "nav" and ap_nav) or
        (mode == "apr" and ap_apr) or
        (mode == "gs" and ap_gs)

    clear_ap_modes()
    if mode_was_active then
        return
    end

    if mode == "rp" then
        ap_rp = true
    elseif mode == "hdg" then
        ap_hdg = true
    elseif mode == "alt" then
        ap_alt = true
    elseif mode == "nav" then
        ap_nav = true
    elseif mode == "apr" then
        ap_apr = true
    elseif mode == "gs" then
        ap_gs = true
    end
end


dispatch_ap_mode = function()
    if not ap_on then
        dispatch_action(nil, iCommandPlaneStabCancel)
        return
    end

    resolve_mode_conflicts()

    -- Keep panel mode lights coupled to actual FM-facing AP commands.
    if ap_rp then
        dispatch_action(nil, iCommandPlaneStabTangBank)
    elseif ap_hdg then
        dispatch_action(nil, iCommandPlaneStabHbarHeading)
    elseif ap_alt then
        dispatch_action(nil, iCommandPlaneStabHbarBank)
    elseif ap_nav then
        dispatch_action(nil, iCommandPlaneRouteAutopilot)
    elseif ap_apr then
        dispatch_action(nil, iCommandPlaneStabPathHold)
    elseif ap_gs then
        -- GS remains on stock AP command because it depends on ILS capture.
        dispatch_action(nil, iCommandPlaneStabHbar)
    else
        dispatch_action(nil, iCommandPlaneStabCancel)
    end
end


function SetCommand(command,value)
    debug_message_to_user("autopilot: command "..tostring(command).." = "..tostring(value))
    local should_dispatch = true
    local ap_test_active = ap_test_remaining > 0
    
    if command == device_commands.AP_RP and value == 1 then
        if ap_test_active then
            should_dispatch = false
        else
            toggle_ap_mode("rp")
        end
    elseif command == device_commands.AP_HDG and value == 1 then
        if ap_test_active then
            should_dispatch = false
        else
            toggle_ap_mode("hdg")
        end
    elseif command == device_commands.AP_ALT and value == 1 then
        if ap_test_active then
            should_dispatch = false
        else
            toggle_ap_mode("alt")
        end
    elseif command == device_commands.AP_NAV and value == 1 then
        if ap_test_active then
            should_dispatch = false
        else
            toggle_ap_mode("nav")
        end
    elseif command == device_commands.AP_APR and value == 1 then
        if ap_test_active then
            should_dispatch = false
        else
            toggle_ap_mode("apr")
        end
    elseif command == device_commands.AP_GS and value == 1 then
        if ap_test_active then
            should_dispatch = false
        else
            toggle_ap_mode("gs")
        end
    elseif command == device_commands.AP_TEST and value == 1 then
        ap_test_remaining = ap_test_duration
        should_dispatch = false
    elseif command == device_commands.AP_ON and value == 1 then
        if ap_test_active then
            should_dispatch = false
        else
            if ap_on then
                ap_on = false
                clear_ap_modes()
                if override_active then
                    dispatch_action(nil, iCommandPlaneAutopilotOverrideOff)
                end
                override_active = false
            else
                ap_on = true
            end
        end
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    elseif command == Keys.APDisengage and value == 1 then
        ap_on = false
        clear_ap_modes()
        if override_active then
            dispatch_action(nil, iCommandPlaneAutopilotOverrideOff)
        end
        override_active = false
    elseif command == Keys.APOvrd and value == 1 then
        override_active = true
        dispatch_action(nil, iCommandPlaneAutopilotOverrideOn)
        should_dispatch = false
    elseif command == Keys.APOvrd and value == 0 then
        override_active = false
        dispatch_action(nil, iCommandPlaneAutopilotOverrideOff)
        should_dispatch = false
    end

    if should_dispatch then
        dispatch_ap_mode()
    end
    
end


startup_print("autopilot: load end")
need_to_be_closed = false -- close lua state after initialization


