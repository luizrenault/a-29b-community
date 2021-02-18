
dofile(LockOn_Options.script_path.."CMFD/CMFD_SMS_ID_defs.lua")


local SMS_MODE = get_param_handle("SMS_MODE")
local SMS_CARGOTYPE = get_param_handle("SMS_CARGOTYPE")
local SMS_INV = get_param_handle("SMS_INV")

local SMS_AA_SIGHT = get_param_handle("SMS_AA_SIGHT")
local SMS_AA_QTY = get_param_handle("SMS_AA_QTY")
local SMS_AA_NAME = get_param_handle("SMS_AA_NAME")
local SMS_AA_INTRG_QTY = get_param_handle("SMS_AA_INTRG_QTY")
local SMS_AA_RR = get_param_handle("SMS_AA_RR")
local SMS_AA_RR_SRC = get_param_handle("SMS_AA_RR_SRC")
local SMS_AA_SLV_SRC = get_param_handle("SMS_AA_SLV_SRC")
local SMS_AA_COOL = get_param_handle("SMS_AA_COOL")
local SMS_AA_SCAN = get_param_handle("SMS_AA_SCAN")
local SMS_AA_LIMIT = get_param_handle("SMS_AA_LIMIT")

local weapons
local station_count = 6
local sms_mode = SMS_MODE_IDS.SAFE
local sms_mode_last = SMS_MODE_IDS.SAFE
local sms_cargotype = SMS_CARGO_TYPE_IDS.WPN
local sms_inv = 0
local sms_sj_sel = {}
local sms_sto_name = {}
local sms_sto_count = {}
local sms_sto_type = {}

local sms_aa_sight = SMS_AA_SIGHT_IDS.LCOS
local sms_aa_qty = 0
local sms_aa_name = ""
local sms_aa_intgr_qty = 0
local sms_aa_rr = 100
local sms_aa_rr_src = SMS_AA_RR_SRC_IDS.MAN
local sms_aa_slv_src = SMS_AA_SLV_SRC_IDS.BST
local sms_aa_cool = SMS_AA_COOL_IDS.WARM
local sms_aa_scan = SMS_AA_SCAN_IDS.SCAN
local sms_aa_limit = 0

local function update_storages()
    for i = 0, station_count-1 do
        local station_info = weapons:get_station_info(i)
        local wname = WEAPONS_NAMES[station_info["CLSID"]]
        if station_info["count"] > 1 then
            wname = tostring(station_info["count"]) .. wname
        elseif station_info["count"] > 0 then
        else
            wname = ""
        end
        if wname == "" and station_info.weapon.level3 == wsType_FuelTank then wname = "TANK" end


        param = get_param_handle("SMS_POS_"..tostring(i+1).."_TEXT")
        param:set(wname)
        sms_sto_name[i+1] = wname
        sms_sto_count[i+1] = station_info["count"]
        sms_sto_type[i+1] = 0
    end
    if sms_mode ~= SMS_MODE_IDS.SJ and sms_mode ~= SMS_MODE_IDS.EJ then
        for i=1,5 do
            param = get_param_handle("SMS_POS_"..tostring(i).."_SEL")
            param:set(0)
        end
    end    
end


local function update_aa()
    SMS_AA_SIGHT:set(sms_aa_sight)
    SMS_AA_QTY:set(sms_aa_qty)
    SMS_AA_NAME:set(sms_aa_name)
    SMS_AA_INTRG_QTY:set(sms_aa_intgr_qty)
    SMS_AA_RR:set(sms_aa_rr)
    SMS_AA_RR_SRC:set(sms_aa_rr_src)
    SMS_AA_SLV_SRC:set(sms_aa_slv_src)
    SMS_AA_COOL:set(sms_aa_cool)
    SMS_AA_SCAN:set(sms_aa_scan)
    SMS_AA_LIMIT:set(sms_aa_limit)
end

local function update_sj()
    for i=1,5 do
        if sms_sto_count[i] == 0 then sms_sj_sel[i] = 0 end
        param = get_param_handle("SMS_POS_"..tostring(i).."_SEL")
        if sms_sj_sel[i] == 1 then
            if get_wpn_mass() ~= WPN_MASS_IDS.LIVE or get_wpn_latearm() ~= WPN_LATEARM_IDS.ON or get_avionics_onground() == 1 then
                param:set(2)
            else 
                param:set(1)
            end
        else
            param:set(0)
        end
    end
end


function update_sms()
    if sms_mode == SMS_MODE_IDS.SJ then update_sj() end
    if sms_mode == SMS_MODE_IDS.AA then update_aa() end

    update_storages()

    SMS_MODE:set(sms_mode)
    SMS_CARGOTYPE:set(sms_cargotype)
    SMS_INV:set(sms_inv)
end

local function SetCommandSmsSj(command,value, CMFD)
    if value == 0 then return 0 end

    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
        sms_mode = sms_mode_last
    elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then 
        sms_sj_sel[4] = (sms_sj_sel[4] + 1) % 2
    elseif command==device_commands.CMFD1OSS12 or command==device_commands.CMFD2OSS12 then 
        sms_sj_sel[5] = (sms_sj_sel[5] + 1) % 2
    elseif command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23 then 
        sms_sj_sel[1] = (sms_sj_sel[1] + 1) % 2
    elseif command==device_commands.CMFD1OSS24 or command==device_commands.CMFD2OSS24 then 
        sms_sj_sel[2] = (sms_sj_sel[2] + 1) % 2
    elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then 
        sms_sj_sel[3] = (sms_sj_sel[3] + 1) % 2
    end
end

local function SetCommandSmsAg(command,value, CMFD)
    if value == 0 then return 0 end
    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
        sms_mode_last = sms_mode
        sms_mode = SMS_MODE_IDS.SAFE
    end
end


local function SetCommandSmsAa(command,value, CMFD)
    if value == 0 then return 0 end
    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
        sms_mode_last = sms_mode
        sms_mode = SMS_MODE_IDS.AG

    elseif command==device_commands.CMFD1OSS2 or command==device_commands.CMFD2OSS2 then 
        sms_aa_sight = (sms_aa_sight + 1) % 3
    elseif command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9 then 
        -- subformato rr sms_aa_rr
    elseif command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10 then 
        sms_aa_rr_src = (sms_aa_rr_src + 1) % 2
    elseif command==device_commands.CMFD1OSS11 or command==device_commands.CMFD2OSS11 then 
        sms_aa_slv_src = (sms_aa_slv_src + 1) % 2
    elseif command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25 then 
        sms_aa_cool = (sms_aa_cool + 1) % 2
    elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then 
        sms_aa_scan = (sms_aa_scan + 1) % 2
    elseif command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then 
        sms_aa_limit = (sms_aa_limit + 1) % 2
    elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then 
        -- step
    end
end

local function SetCommandSmsSafe(command,value, CMFD)
    if value == 0 then return 0 end
    if command==device_commands.CMFD1OSS1 or command==device_commands.CMFD2OSS1 then 
        sms_mode_last = sms_mode
        sms_mode = SMS_MODE_IDS.AA
    end
end

function SetCommandSms(command,value, CMFD)
    if command == device_commands.CMFD1OSS1 and value == -100 then -- Salvo Pressed
        if(sms_mode ~= SMS_MODE_IDS.EJ) then sms_mode_last = sms_mode end
        sms_mode = SMS_MODE_IDS.EJ
        for i=1,5 do
            param = get_param_handle("SMS_POS_"..tostring(i).."_SEL")
            if weapons:get_station_info(i-1).weapon.level3 ~= wsType_AA_Missile then
                set_wpn_sto_jet(i,1)
                param:set(1)
            else
                set_wpn_sto_jet(i,0)
                param:set(0)
            end
        end
        return 0
    elseif command == device_commands.CMFD1OSS1 and value == -200 then -- E-J finished
        sms_mode = sms_mode_last
        return 0
    end


    if sms_mode == SMS_MODE_IDS.SAFE then SetCommandSmsSafe(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.SJ then SetCommandSmsSj(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.AA then SetCommandSmsAa(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.AG then SetCommandSmsAg(command, value, CMFD)
    elseif sms_mode == SMS_MODE_IDS.EJ then sms_mode = sms_mode_last
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
            if sms_mode == SMS_MODE_IDS.SAFE or sms_mode == SMS_MODE_IDS.AA then
                sms_mode_last = sms_mode
                sms_mode = SMS_MODE_IDS.SJ
                sms_inv = 0
            end
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
    update_storages()
    for i=1,5 do
        sms_sj_sel[i] = 1
        sms_sto_name[i] = ""
        sms_sto_count[i] = 0
        sms_sto_type[i] = 0
    end
    
end
