
dofile(LockOn_Options.script_path.."CMFD/CMFD_SMS_ID_defs.lua")

local SMS_MODE = get_param_handle("SMS_MODE")
local SMS_CARGOTYPE = get_param_handle("SMS_CARGOTYPE")
local SMS_INV = get_param_handle("SMS_INV")

local SMS_FUSE_SEL = get_param_handle("SMS_FUSE_SEL")
local SMS_FUSE_TYPE = get_param_handle("SMS_FUSE_TYPE")
local SMS_TIME_ALT_SEL = get_param_handle("SMS_TIME_ALT_SEL")
local SMS_IS_UNIT = get_param_handle("SMS_IS_UNIT")
local SMS_BR_RR_SEL = get_param_handle("SMS_BR_RR_SEL")
local SMS_PROF_SEL = get_param_handle("SMS_PROF_SEL")

local CMFD_EDIT_NR_DESC = get_param_handle("CMFD_EDIT_NR_DESC")
local CMFD_EDIT_NR_TITLE = get_param_handle("CMFD_EDIT_NR_TITLE")
local CMFD_EDIT_NR_VALUE = get_param_handle("CMFD_EDIT_NR_VALUE")
local CMFD_EDIT_NR_BLINK = get_param_handle("CMFD_EDIT_NR_BLINK")

local weapons
local sms_mode = SMS_MODE_IDS.SAFE
local sms_cargotype = SMS_CARGO_TYPE_IDS.WPN
local sms_inv = 0
local sms_sj_sel = {}

local master_mode = -1
local master_mode_last = -1

local current_edit_data


local sms_rp_data = {mode=SMS_MODE_IDS.RP, title="RELEASE PULSES\nNUM       ", desc="SELECT PULSES NUMBER", param="WPN_RP",
    validate = function(value)
        local val = tonumber(value) or 0
        if val > 0 and val <=76 then return true else return false end
    end
}

local sms_is_dist_data = {mode=SMS_MODE_IDS.RP, title="IMPACT SEPARATION\nDIS:      M", desc="SELECT METERS ON GROUND", param="WPN_IS_M", 
    validate = function(value)
        local val = tonumber(value) or 0
        if val >= 12 and val <=999 then return true else return false end
    end
}

local sms_is_time_data = {mode=SMS_MODE_IDS.RP, title="IMPACT SEPARATION\nINT:      MS", desc="SELECT INTERVAL TIME", param="WPN_IS_TIME", maxsize=4,
    validate = function(value)
        local val = tonumber(value) or 0
        if val >= 0 and val <=9999 then return true else return false end
    end
}

local sms_sd_data = {mode=SMS_MODE_IDS.RP, title="SIGHT\nMR:       ", desc="SELECT DEP", param="WPN_SD",
    validate = function(value)
        local val = tonumber(value) or 0
        if val >= 0 and val <=190 then return true else return false end
    end
}

local cmfd_page_last
local function update_master_mode_changed()
    master_mode = get_avionics_master_mode()
    if master_mode == master_mode_last then return 0 end
    if get_avionics_master_mode_aa(master_mode) then
        sms_mode = SMS_MODE_IDS.AA
    elseif get_avionics_master_mode_ag(master_mode) then
        sms_mode = SMS_MODE_IDS.AG
    elseif master_mode == AVIONICS_MASTER_MODE_ID.EJ then
        sms_mode = SMS_MODE_IDS.EJ
        local CMFD1Format=get_param_handle("CMFD1Format")
        cmfd_page_last = CMFD1Format:get()
        CMFD1Format:set(SUB_PAGE_ID.SMS)
    elseif master_mode_last == AVIONICS_MASTER_MODE_ID.EJ then
        local CMFD1Format=get_param_handle("CMFD1Format")
        CMFD1Format:set(cmfd_page_last)
    elseif master_mode == AVIONICS_MASTER_MODE_ID.SJ then
        sms_mode = SMS_MODE_IDS.SJ
    else 
        sms_mode = SMS_MODE_IDS.SAFE
    end
    master_mode_last = master_mode
end

local function update_aa()
end

local function update_ag()
end

local function update_sj()
end


function update_sms()
    update_master_mode_changed()

    if sms_mode == SMS_MODE_IDS.SJ then update_sj() end
    if sms_mode == SMS_MODE_IDS.AA then update_aa() end
    if sms_mode == SMS_MODE_IDS.AG then update_ag() end

    SMS_MODE:set(sms_mode)
    SMS_CARGOTYPE:set(sms_cargotype)
    SMS_INV:set(sms_inv)

    if current_edit_data and current_edit_data.update then current_edit_data.update() end
end

local function SetCommandSmsSj(command,value, CMFD)
    if value == 0 then return 0 end
    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
        set_avionics_master_mode(get_avionics_master_mode_last())
    elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then 
        sms_sj_sel = get_param_handle("WPN_SJ_STO4_SEL")
        sms_sj_sel:set((sms_sj_sel:get() + 1) % 2)
    elseif command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12 then 
        sms_sj_sel = get_param_handle("WPN_SJ_STO5_SEL")
        sms_sj_sel:set((sms_sj_sel:get() + 1) % 2)
    elseif command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23 then 
        sms_sj_sel = get_param_handle("WPN_SJ_STO1_SEL")
        sms_sj_sel:set((sms_sj_sel:get() + 1) % 2)
    elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then 
        sms_sj_sel = get_param_handle("WPN_SJ_STO2_SEL")
        sms_sj_sel:set((sms_sj_sel:get() + 1) % 2)
    elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then 
        sms_sj_sel = get_param_handle("WPN_SJ_STO3_SEL")
        sms_sj_sel:set((sms_sj_sel:get() + 1) % 2)
    end
end

local function CallEditFormat(data)
    current_edit_data = data
    current_edit_data.sms_mode_last = sms_mode
    current_edit_data.blink_period = 0
    current_edit_data.clr_count = 0
    current_edit_data.edit_value = nil

    if current_edit_data.param then
        current_edit_data.param_handle = get_param_handle(current_edit_data.param)
    end

    if current_edit_data.param_handle then 
        current_edit_data.value = current_edit_data.param_handle:get()
    else
        current_edit_data.value = ""
    end

    sms_mode = data.mode

    CMFD_EDIT_NR_DESC:set(data.desc)
    CMFD_EDIT_NR_TITLE:set(data.title)
    CMFD_EDIT_NR_VALUE:set(data.value)
    
    current_edit_data.enter_data = function (newdata)
        current_edit_data.clr_count = 0
        local max_size = current_edit_data.maxsize or 3
        if current_edit_data.edit_value == nil or (current_edit_data.edit_value and current_edit_data.edit_value:len() < max_size) then
            current_edit_data.edit_value = (current_edit_data.edit_value or "") .. newdata
        else
            current_edit_data.blink_period = 0.3
        end
    end

    current_edit_data.clear = function ()
        if current_edit_data.clr_count == 0 and current_edit_data.edit_value then
            current_edit_data.edit_value = string.sub(current_edit_data.edit_value, 1, -2)
        elseif current_edit_data.clr_count == 1 then
            current_edit_data.edit_value = nil
        elseif current_edit_data.clr_count == 2 or current_edit_data.edit_value == nil then
            current_edit_data.exit()
        end
        current_edit_data.clr_count = current_edit_data.clr_count + 1
    end
    current_edit_data.exit = function (save)
        current_edit_data.clr_count = 0
        if save then
            if current_edit_data.validate and current_edit_data.validate(current_edit_data.edit_value or current_edit_data.value) then
                current_edit_data.value = current_edit_data.edit_value or current_edit_data.value
                if current_edit_data.param_handle then current_edit_data.param_handle:set(current_edit_data.value) end
                sms_mode = current_edit_data.sms_mode_last
            else 
                current_edit_data.blink_period = 0.3
            end
        else 
            sms_mode = current_edit_data.sms_mode_last
        end
    end
    
    current_edit_data.update = function()
        CMFD_EDIT_NR_VALUE:set(current_edit_data.edit_value or  current_edit_data.value)
        if current_edit_data.blink_period == -1 then
        elseif current_edit_data.blink_period <= 0 then
            CMFD_EDIT_NR_BLINK:set(0)
            current_edit_data.blink_period = -1
        elseif current_edit_data.blink_period > 0 then
            CMFD_EDIT_NR_BLINK:set(1)
            current_edit_data.blink_period = current_edit_data.blink_period - update_time_step

        end
    end

end

local function SetCommandEdit(command, value)
    if value ~=1 then return 0 end
    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
        current_edit_data.exit(false)
    elseif command==device_commands.CMFD1OSS2 or command==device_commands.CMFD2OSS2 then 
        current_edit_data.clear()
    elseif command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3 then 
        current_edit_data.exit(true)
    elseif command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(6) end
    elseif command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(7) end
    elseif command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(8) end
    elseif command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(9) end
    elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(0) end
    elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(1) end
    elseif command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(2) end
    elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(3) end
    elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(4) end
    elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then 
        if current_edit_data.enter_data then current_edit_data.enter_data(5) end
    end
end

local function SetCommandSmsAg(command,value, CMFD)
    local master_mode = get_avionics_master_mode()
    if value == 0 or sms_inv == 1 then return 0 end

    if sms_mode == SMS_MODE_IDS.CD then
        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then
            sms_mode = SMS_MODE_IDS.AG
        elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
            sms_mode = SMS_MODE_IDS.AG
        elseif command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.MAN)
            sms_mode = SMS_MODE_IDS.AG
        elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 and WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCRP)
            sms_mode = SMS_MODE_IDS.AG
        elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 and WPN_SELECTED_WEAPON_TYPE:get() == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DTOS)
            sms_mode = SMS_MODE_IDS.AG
        end
    elseif sms_mode == SMS_MODE_IDS.AG then

        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then
            -- implement last option to return
            if get_avionics_master_mode_ag_gun() then
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
            else
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.GUN)
            end
        elseif command==device_commands.CMFD1OSS2 or command==device_commands.CMFD2OSS2 then
            if not get_avionics_master_mode_ag_gun() then
                sms_mode = SMS_MODE_IDS.CD
            else

            end
        elseif command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7 then 
            CallEditFormat(sms_sd_data)
        elseif command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9 then 
            SMS_FUSE_SEL:set((SMS_FUSE_SEL:get() + 1)% 4)
        elseif command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10 then 
        elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then 
            -- SMS_TIME_ALT_SEL:set((SMS_TIME_ALT_SEL:get() + 1)% 3)
        elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then 
            if not get_avionics_master_mode_ag_gun() then 
                    local weapon_type = WPN_SELECTED_WEAPON_TYPE:get()
                if weapon_type == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_ROCKET then 
                    CallEditFormat(sms_is_time_data)
                elseif weapon_type == WPN_WEAPON_TYPE_IDS.AG_UNGUIDED_BOMB then 
                    CallEditFormat(sms_is_dist_data)
                end
            end
        elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then 
            if not get_avionics_master_mode_ag_gun() then 
                CallEditFormat(sms_rp_data)
            end
        elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then 
            if not get_avionics_master_mode_ag_gun() then 
                weapons:performClickableAction(device_commands.WPN_AG_LAUNCH_OP_STEP, 1, true)
            end
        elseif command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then 
            -- SMS_PROF_SEL:set((SMS_PROF_SEL:get() + 1)% 2)
            if not get_avionics_master_mode_ag_gun() then 
                -- weapons:performClickableAction(device_commands.WPN_AG_STEP, 1, true)
            end
        elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then 
            if not get_avionics_master_mode_ag_gun() then 
                weapons:performClickableAction(device_commands.WPN_AG_STEP, 1, true)
            end
        end
    end
end

local function SetCommandSmsAa(command,value, CMFD)
    if value == 0 then return 0 end
    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
    elseif command==device_commands.CMFD1OSS2 or command==device_commands.CMFD2OSS2 then 
        weapons:performClickableAction(device_commands.WPN_AA_SIGHT_STEP, 0, true)
    elseif command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9 then 
        -- subformato rr sms_aa_rr
    elseif command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10 then 
        weapons:performClickableAction(device_commands.WPN_AA_RR_SRC_STEP, 0, true)
    elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then 
        weapons:performClickableAction(device_commands.WPN_AA_SLV_SRC_STEP, 0, true)
    elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then 
        weapons:performClickableAction(device_commands.WPN_AA_COOL_STEP, 0, true)
    elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then 
        weapons:performClickableAction(device_commands.WPN_AA_SCAN_STEP, 0, true)
    elseif command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then 
        weapons:performClickableAction(device_commands.WPN_AA_LIMIT_STEP, 0, true)
    elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then  -- step
        weapons:performClickableAction(device_commands.WPN_AA_STEP, 1, true)
    end
end

local function SetCommandSmsSafe(command,value, CMFD)
    if value == 0 then return 0 end
    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
    end
end


function SetCommandSms(command,value, CMFD)
    if sms_mode == SMS_MODE_IDS.SAFE then SetCommandSmsSafe(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.SJ then SetCommandSmsSj(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.AA then SetCommandSmsAa(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.AG or sms_mode == SMS_MODE_IDS.CD then SetCommandSmsAg(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.EJ then set_avionics_master_mode(get_avionics_master_mode_last())
    elseif sms_mode == SMS_MODE_IDS.RP then SetCommandEdit(command, value)
    end

    if value == 1 then 
        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
            sms_inv = 0
        elseif command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3 then 
            if sms_mode == SMS_MODE_IDS.SAFE or sms_mode == SMS_MODE_IDS.SJ or sms_mode == SMS_MODE_IDS.AA then
                sms_cargotype = (sms_cargotype + 1 ) % 2
            end
        elseif command==device_commands.CMFD1OSS4 or command==device_commands.CMFD2OSS4 then 
            if sms_mode == SMS_MODE_IDS.SAFE or sms_mode == SMS_MODE_IDS.AA or sms_mode == SMS_MODE_IDS.AG then
                sms_inv = (sms_inv + 1 ) % 2
            end
        elseif command==device_commands.CMFD1OSS5 or command==device_commands.CMFD2OSS5 then 
            if sms_mode == SMS_MODE_IDS.SAFE or sms_mode == SMS_MODE_IDS.AA or sms_mode == SMS_MODE_IDS.AG then
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.SJ)
                sms_inv = 0
            end
        elseif command==device_commands.CMFD1OSS7 or command==device_commands.CMFD2OSS7 then 
            if sms_inv == 1 then dispatch_action(nil, iCommandMissionResourcesManagement)  end-- Rearm and Refuel
        elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then 
        elseif command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12 then 
        elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then 
        elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then 
        elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then 
        end
    end

end

function post_initialize_sms()
    weapons = GetDevice(devices.WEAPON_SYSTEM)
    for i=1,5 do
        sms_sj_sel = get_param_handle("WPN_SJ_STO"..tostring(i).."_SEL")
        sms_sj_sel:set(1)
    end
end
