
dofile(LockOn_Options.script_path.."CMFD/CMFD_SMS_ID_defs.lua")

local SMS_MODE = get_param_handle("SMS_MODE")
local SMS_CARGOTYPE = get_param_handle("SMS_CARGOTYPE")
local SMS_INV = get_param_handle("SMS_INV")
local SMS_GUNS_L_SEL = get_param_handle("SMS_GUNS_L_SEL")
local SMS_GUNS_R_SEL = get_param_handle("SMS_GUNS_R_SEL")

local weapons
local sms_mode = SMS_MODE_IDS.SAFE
local sms_cargotype = SMS_CARGO_TYPE_IDS.WPN
local sms_inv = 0
local sms_sj_sel = {}

local master_mode = -1
local master_mode_last = -1

local function update_master_mode_changed()
    master_mode = get_avionics_master_mode()
    if master_mode == master_mode_last then return 0 end
    if get_avionics_master_mode_aa(master_mode) then
        sms_mode = SMS_MODE_IDS.AA
    elseif get_avionics_master_mode_ag(master_mode) then
        sms_mode = SMS_MODE_IDS.AG
    elseif master_mode == AVIONICS_MASTER_MODE_ID.EJ then
        sms_mode = SMS_MODE_IDS.EJ
    elseif master_mode == AVIONICS_MASTER_MODE_ID.SJ then
        sms_mode = SMS_MODE_IDS.SJ
    else 
        sms_mode = SMS_MODE_IDS.SAFE
    end
    master_mode_last = master_mode
end

local function update_aa()
    local sms_aa_sel = get_wpn_aa_sel()
    for i=1, 5 do
        param = get_param_handle("SMS_POS_"..tostring(i).."_SEL")
        if sms_aa_sel == i then
            if get_wpn_aa_msl_ready() then
                param:set(1)
            else 
                param:set(2)
            end
        else
            param:set(0)
        end
    end
    if master_mode == AVIONICS_MASTER_MODE_ID.DGFT_B or master_mode == AVIONICS_MASTER_MODE_ID.DGFT_L then
        if get_wpn_guns_ready() then
            SMS_GUNS_L_SEL:set(1)
            SMS_GUNS_R_SEL:set(1)
        else
            SMS_GUNS_L_SEL:set(2)
            SMS_GUNS_R_SEL:set(2)
        end
    else
        SMS_GUNS_L_SEL:set(0)
        SMS_GUNS_R_SEL:set(0)
    end
end

local function update_ag()
    local sms_ag_sel = get_wpn_ag_sel()
    for i=1, 5 do
        param = get_param_handle("SMS_POS_"..tostring(i).."_SEL")
        if sms_ag_sel == i then
            if get_wpn_ag_ready() then
                param:set(1)
            else 
                param:set(2)
            end
        else
            param:set(0)
        end
    end
    if master_mode == AVIONICS_MASTER_MODE_ID.CCIP or master_mode == AVIONICS_MASTER_MODE_ID.GUN  or master_mode == AVIONICS_MASTER_MODE_ID.GUN_R then
        if get_wpn_guns_ready() then
            SMS_GUNS_L_SEL:set(1)
            SMS_GUNS_R_SEL:set(1)
        else
            SMS_GUNS_L_SEL:set(2)
            SMS_GUNS_R_SEL:set(2)
        end
    else
        SMS_GUNS_L_SEL:set(0)
        SMS_GUNS_R_SEL:set(0)
    end
end

local function update_sj()
    for i=1,5 do
        -- if sms_sto_count[i] == 0 then sms_sj_sel[i] = 0 end
        param = get_param_handle("SMS_POS_"..tostring(i).."_SEL")
        sms_sj_sel = get_param_handle("WPN_SJ_STO"..tostring(i).."_SEL")
        if sms_sj_sel:get() == 1 then
            if get_wpn_mass() ~= WPN_MASS_IDS.LIVE or get_wpn_latearm() ~= WPN_LATEARM_IDS.ON or get_avionics_onground() then
                param:set(2)
            else 
                param:set(1)
            end
        else
            param:set(0)
        end
    end
    SMS_GUNS_L_SEL:set(0)
    SMS_GUNS_R_SEL:set(0)
end


function update_sms()
    update_master_mode_changed()

    if sms_mode == SMS_MODE_IDS.SJ then update_sj() end
    if sms_mode == SMS_MODE_IDS.AA then update_aa() end
    if sms_mode == SMS_MODE_IDS.AG then update_ag() end

    if sms_mode == SMS_MODE_IDS.SAFE then
        for i=1,5 do
            local param = get_param_handle("SMS_POS_"..tostring(i).."_SEL")
            param:set(0)
        end
        SMS_GUNS_L_SEL:set(0)
        SMS_GUNS_R_SEL:set(0)
    end

    SMS_MODE:set(sms_mode)
    SMS_CARGOTYPE:set(sms_cargotype)
    SMS_INV:set(sms_inv)
    
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

local function SetCommandSmsAg(command,value, CMFD)
    if value == 0 then return 0 end
    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
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
    elseif sms_mode == SMS_MODE_IDS.AG then SetCommandSmsAg(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.EJ then set_avionics_master_mode(get_avionics_master_mode_last())
    end

    if value == 1 then 
        if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
            sms_inv = 0
        elseif command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3 then 
            if sms_mode == SMS_MODE_IDS.SAFE or sms_mode == SMS_MODE_IDS.SJ or sms_mode == SMS_MODE_IDS.AA then
                sms_cargotype = (sms_cargotype + 1 ) % 2
            end
        elseif command==device_commands.CMFD1OSS4 or command==device_commands.CMFD2OSS4 then 
            if sms_mode == SMS_MODE_IDS.SAFE or sms_mode == SMS_MODE_IDS.AA then
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
