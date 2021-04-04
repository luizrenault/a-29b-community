dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."functions.lua")

startup_print("autopilot: load")

local dev = GetSelf()

local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step)

local sensor_data = get_base_data()


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
local AP_NAV = get_param_handle("AP_NAV")
local AP_APR = get_param_handle("AP_APR")
local AP_GS = get_param_handle("AP_GS")
local AP_ON = get_param_handle("AP_ON")


function update()
    AP_RP:set(ap_rp and 1 or 0)
    AP_HDG:set(ap_hdg and 1 or 0)
    AP_ALT:set(ap_alt and 1 or 0)
    AP_NAV:set(ap_nav and 1 or 0)
    AP_APR:set(ap_apr and 1 or 0)
    AP_GS:set(ap_gs and 1 or 0)
    AP_ON:set(ap_on and 1 or 0)
end

local iCommandPlaneStabTangBank = 386
local iCommandPlaneStabHbar = 389
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


function SetCommand(command,value)
    debug_message_to_user("autopilot: command "..tostring(command).." = "..tostring(value))
    
    if command == device_commands.AP_RP and value == 1 then
        if ap_rp then 
            ap_rp = false
        else
            ap_rp = true
            ap_hdg = false
            ap_alt = false
            ap_nav = false
            ap_apr = false
            ap_gs = false
        end
    elseif command == device_commands.AP_HDG and value == 1 then
        if ap_hdg then
            ap_hdg = false
        else
            ap_rp = false
            ap_hdg = true
            ap_nav = false
            ap_apr = false
        end
    elseif command == device_commands.AP_ALT and value == 1 then
        if ap_alt then
            ap_alt = false
        else
            ap_rp = false
            ap_alt = true
            ap_gs = false
        end
    elseif command == device_commands.AP_NAV and value == 1 then
        if ap_nav then
            ap_nav = false
        else
            ap_rp = false
            ap_hdg = false
            ap_nav = true
            ap_apr = false
        end
    elseif command == device_commands.AP_APR and value == 1 then
        if ap_apr then
            ap_apr = false
        else
            ap_rp = false
            ap_hdg = false
            ap_nav = false
            ap_apr = true
        end
    elseif command == device_commands.AP_GS and value == 1 then
        if ap_gs then
            ap_gs = false
        else
            ap_rp = false
            ap_alt = false
            ap_gs = true
        end
    elseif command == device_commands.AP_ON and value == 1 then
        if ap_on then
            ap_on = false
        else
            ap_on = true
        end
        -- dev:performClickableAction(device_commands.EngineStart, 0, true)
    elseif command == Keys.APDisengage and value == 1 then
        ap_on = false
    elseif command == Keys.APOvrd and value == 1 then
        dispatch_action(nil, iCommandPlaneAutopilotOverrideOn)
    elseif command == Keys.APOvrd and value == 0 then
        dispatch_action(nil, iCommandPlaneAutopilotOverrideOff)
    end

    if ap_on then
        if ap_rp then dispatch_action(nil, iCommandPlaneStabTangBank)
        elseif ap_alt then dispatch_action(nil, iCommandPlaneStabHbar)
        else dispatch_action(nil, iCommandPlaneStabCancel)
        end
    else
        dispatch_action(nil, iCommandPlaneStabCancel)
    end
    
end


startup_print("autopilot: load end")
need_to_be_closed = false -- close lua state after initialization


