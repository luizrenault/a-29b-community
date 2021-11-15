dofile(LockOn_Options.script_path.."CMFD/CMFD_DVR_ID_defs.lua")

local DVR_TEXT = get_param_handle("CMFD_DVR_TEXT")
--DVR_TEXT:set("hello")

local DVR_FORMAT = get_param_handle("CMFD_DVR_FORMAT")
local DVR_STATE = get_param_handle("CMFD_DVR_STATE")
local DVR_MODE = get_param_handle("CMFD_DVR_MODE")
local DVR_CYCLE = get_param_handle("CMFD_DVR_CYCLE")

local DVR_HUD_CHECKED = get_param_handle("CMFD_DVR_HUD_CHECKED")
local DVR_FWD_LCMFD_CHECKED = get_param_handle("CMFD_DVR_FWD_LCMFD_CHECKED")
local DVR_FWD_RCMFD_CHECKED = get_param_handle("CMFD_DVR_FWD_RCMFD_CHECKED")
local DVR_AFT_LCMFD_CHECKED = get_param_handle("CMFD_DVR_AFT_LCMFD_CHECKED")
local DVR_AFT_RCMFD_CHECKED = get_param_handle("CMFD_DVR_AFT_RCMFD_CHECKED")
local DVR_FLIR_CHECKED = get_param_handle("CMFD_DVR_FLIR_CHECKED")

local DVR_RESET_BLINK = get_param_handle("CMFD_DVR_RESET_BLINK")

local DVR_SWITCH_STATE = get_param_handle("UFCP_DVR_SWITCH_STATE")


local CMFDDoi = get_param_handle("CMFDDoi")

local format = CMFD_DVR_FORMAT_IDS.DVR
local state = CMFD_DVR_STATE_IDS.REC
local mode = CMFD_DVR_MODE_IDS.AUTO
local cycle = CMFD_DVR_REC_IDS.NO_CYCLE

local time_recorded = 0
local total_time_recorded = 0
local total_time = 240 * 60

local source1 = -1
local source2 = -1

local dvr_time = get_absolute_model_time()

local dvr_erase = false
local allow_erase_at = -1.0
local cancel_erase_at = -1.0

function get_doi()
    local doi = CMFDDoi:get()
    if doi == 0 then
        -- HUD
        return CMFD_DVR_SOURCE_IDS.HUD
    elseif doi == 1 then
        -- FWD L CMFD
        return CMFD_DVR_SOURCE_IDS.FWD_LCMFD
    elseif doi == 2 then
        -- FWD R CMFD
        return CMFD_DVR_SOURCE_IDS.FWD_RCMFD
    end

    -- Since there is no aft seat, the other CMFDs can't be DOI.
end

function update_dvr()
    if mode == CMFD_DVR_MODE_IDS.AUTO then
        source1 = CMFD_DVR_SOURCE_IDS.HUD
        source2 = get_doi()
    end

    local dvr_switch_state = DVR_SWITCH_STATE:get()
    if dvr_switch_state == 1 then state = CMFD_DVR_STATE_IDS.REC
    elseif dvr_switch_state == 0 then state = CMFD_DVR_STATE_IDS.STBY
    else state = CMFD_DVR_STATE_IDS.STOP end

    -- Erase
    if dvr_time > cancel_erase_at then
        dvr_erase = false
        allow_erase_at = -1.0
        cancel_erase_at = -1.0
    end

    local interval = math.floor(2 * get_absolute_model_time() % 2)
    DVR_RESET_BLINK:set(((dvr_erase and interval == 0) or not (state == CMFD_DVR_STATE_IDS.STOP or state == CMFD_DVR_STATE_IDS.EOT)) and 1 or 0)

    local text = ""
    if cycle == CMFD_DVR_REC_IDS.NO_CYCLE then
        if total_time - total_time_recorded <= 0 then
            text = text .. "DVR END"
            set_advice(ADVICE_ID.DVR_END,1)
            set_advice(ADVICE_ID.DVR_10_MN,0)
        elseif total_time - total_time_recorded <= 10 * 60 then
            text = text .. "DVR 10 MIN"
            set_advice(ADVICE_ID.DVR_END,0)
            set_advice(ADVICE_ID.DVR_10_MN,1)
        else
            set_advice(ADVICE_ID.DVR_10_MN,0)
            set_advice(ADVICE_ID.DVR_END,0)
        end
    else
        set_advice(ADVICE_ID.DVR_10_MN,0)
        set_advice(ADVICE_ID.DVR_END,0)
    end

    local time_remaining = total_time - total_time_recorded
    if source1 >= 0 and source2 >= 0 then time_remaining = time_remaining / 2 end
    if cycle == CMFD_DVR_REC_IDS.CYCLE then time_remaining = 3200 * 60 end

    local cur_time = get_absolute_model_time()
    if time_remaining <= 0 then 
        if state == CMFD_DVR_STATE_IDS.STBY or state == CMFD_DVR_STATE_IDS.REC then
            state = CMFD_DVR_STATE_IDS.EOT 
        end

        total_time_recorded = math.min(total_time_recorded, 240 * 60)
        time_recorded = math.min(time_recorded, 240 * 60)
    else
        if state == CMFD_DVR_STATE_IDS.EOT then state = CMFD_DVR_STATE_IDS.STOP end

        if state == CMFD_DVR_STATE_IDS.REC then
            time_recorded = time_recorded + (cur_time - dvr_time)
            if source1 >= 0 and source2 >= 0 then 
                total_time_recorded = total_time_recorded + (cur_time - dvr_time) * 2
            else
                total_time_recorded = total_time_recorded + (cur_time - dvr_time)
            end
        end
    end
    dvr_time = cur_time

    total_time_recorded = math.min(total_time_recorded, 240 * 60)
    time_recorded = math.min(time_recorded, 240 * 60)

    text = text ..
    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n" ..
    "REMAINING: " .. string.format("%03d", time_remaining / 60) .. " MINUTES(M)   \n"
    if cycle == CMFD_DVR_REC_IDS.NO_CYCLE then
        text = text .. "TIME RECORDED: " .. string.format("%03d", time_recorded / 60) .. " MINUTES  "
    end

    DVR_TEXT:set(text)

    DVR_FORMAT:set(format)
    DVR_STATE:set(state)
    DVR_MODE:set(mode)
    DVR_CYCLE:set(cycle)

    DVR_HUD_CHECKED:set((source1 == CMFD_DVR_SOURCE_IDS.HUD or source2 == CMFD_DVR_SOURCE_IDS.HUD) and 1 or 0)
    DVR_FWD_LCMFD_CHECKED:set((source1 == CMFD_DVR_SOURCE_IDS.FWD_LCMFD or source2 == CMFD_DVR_SOURCE_IDS.FWD_LCMFD) and 1 or 0)
    DVR_FWD_RCMFD_CHECKED:set((source1 == CMFD_DVR_SOURCE_IDS.FWD_RCMFD or source2 == CMFD_DVR_SOURCE_IDS.FWD_RCMFD) and 1 or 0)
    DVR_AFT_LCMFD_CHECKED:set((source1 == CMFD_DVR_SOURCE_IDS.AFT_LCMFD or source2 == CMFD_DVR_SOURCE_IDS.AFT_LCMFD) and 1 or 0)
    DVR_AFT_RCMFD_CHECKED:set((source1 == CMFD_DVR_SOURCE_IDS.AFT_RCMFD or source2 == CMFD_DVR_SOURCE_IDS.AFT_RCMFD) and 1 or 0)
    DVR_FLIR_CHECKED:set((source1 == CMFD_DVR_SOURCE_IDS.FLIR or source2 == CMFD_DVR_SOURCE_IDS.FLIR) and 1 or 0)
end

local function ToggleSelection(source)
    if source1 == source then
        source1 = -1
        mode = CMFD_DVR_MODE_IDS.MAN
    elseif source2 == source then
        source2 = -1
        mode = CMFD_DVR_MODE_IDS.MAN
    elseif source1 == -1 then
        source1 = source
        mode = CMFD_DVR_MODE_IDS.MAN
    elseif source2 == -1 then
        source2 = source
        mode = CMFD_DVR_MODE_IDS.MAN
    end
end

local function ResetDVR()
    if not dvr_erase then
        -- Request ERASE
        dvr_erase = true

        allow_erase_at = dvr_time + 1
        cancel_erase_at = dvr_time + 6
    else
        -- Confirm ERASE
        
        time_recorded = 0
        total_time_recorded = 0

        dvr_erase = false
        allow_erase_at = -1.0
        cancel_erase_at = -1.0
    end
end

function SetCommandDvr(command,value, CMFD)
    if value == 1 then
        if (command==device_commands.CMFD1OSS3 or command==device_commands.CMFD2OSS3) then
            -- Switch between AUTO and MAN
            if mode == CMFD_DVR_MODE_IDS.AUTO then
                mode = CMFD_DVR_MODE_IDS.MAN
            else
                mode = CMFD_DVR_MODE_IDS.AUTO
            end
        elseif (command==device_commands.CMFD1OSS4 or command==device_commands.CMFD2OSS4) then
            -- Switch between NO CYCLE and CYCLE
            if cycle == CMFD_DVR_REC_IDS.CYCLE then
                cycle = CMFD_DVR_REC_IDS.NO_CYCLE
            else
                cycle = CMFD_DVR_REC_IDS.CYCLE
            end
        elseif (command==device_commands.CMFD1OSS6 or command==device_commands.CMFD2OSS6) then
            if state == CMFD_DVR_STATE_IDS.STOP or state == CMFD_DVR_STATE_IDS.EOT then
                ResetDVR()
            end
            -- Press once, start to blink for 5 seconds
            -- Press again, it erases the MMC
        elseif (command==device_commands.CMFD1OSS8 or command==device_commands.CMFD2OSS8) then
            -- TODO toggle FLIR as source
            ToggleSelection(CMFD_DVR_SOURCE_IDS.FLIR)
        elseif (command==device_commands.CMFD1OSS9 or command==device_commands.CMFD2OSS9) then
            -- TODO toggle AFT R CMFD as source
            ToggleSelection(CMFD_DVR_SOURCE_IDS.AFT_RCMFD)
        elseif (command==device_commands.CMFD1OSS10 or command==device_commands.CMFD2OSS10) then
            -- TODO toggle AFT L CMFD as source
            ToggleSelection(CMFD_DVR_SOURCE_IDS.AFT_LCMFD)
        elseif (command==device_commands.CMFD1OSS23 or command==device_commands.CMFD2OSS23) then
            -- TODO access PLBCK format
        elseif (command==device_commands.CMFD1OSS25 or command==device_commands.CMFD2OSS25) then
            -- TODO toggle FWD L CMFD as source
            ToggleSelection(CMFD_DVR_SOURCE_IDS.FWD_LCMFD)
        elseif (command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26) then
            -- TODO toggle FWD R CMFD as source
            ToggleSelection(CMFD_DVR_SOURCE_IDS.FWD_RCMFD)
        elseif (command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27) then
            -- TODO toggle HUD as source
            ToggleSelection(CMFD_DVR_SOURCE_IDS.HUD)
        end
    end

    -- TODO I couldn't find a way for it to listen to device_commands.UFCP_DVR. Help.
    if command == device_commands.UFCP_DVR then
        state = CMFD_DVR_STATE_IDS.STOP
        if value == 1 then
            state = CMFD_DVR_STATE_IDS.REC
        elseif value == 0 then
            state = CMFD_DVR_STATE_IDS.STBY
        elseif value == -1 then
            state = CMFD_DVR_STATE_IDS.STOP
        end
    end
end

function post_initialize_dvr()

end