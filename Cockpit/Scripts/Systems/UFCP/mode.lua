-- Methods

local AVIONICS_MASTER_MODE = get_param_handle("AVIONICS_MASTER_MODE")
local sel = 0
local max_sel = 4

function update_mode()
    local master_mode = get_avionics_master_mode()
    local master_mode_aa_int = get_avionics_master_mode_aa_int(master_mode)
    local master_mode_ag = get_avionics_master_mode_ag(master_mode)
    local master_mode_aa_dgft = get_avionics_master_mode_aa_dgft(master_mode)
    local master_mode_nav = not (master_mode_aa_int or master_mode_ag or master_mode_aa_dgft)

    local text = ""
    text = text .. "MODE              \n"

    -- Int
    if sel == 0 then text = text .. "*" else text = text .. " " end
    text = text .. "INT"
    if sel == 0 then text = text .. "*" else text = text .. " " end

    text = text .. " \n"

    -- A/G
    if sel == 1 then text = text .. "*" else text = text .. " " end
    text = text .. "A/G"
    if sel == 1 then text = text .. "*" else text = text .. " " end

    text = text .. "            "
    
    -- NAV
    if sel == 2 then text = text .. "*" else text = text .. " " end
    text = text .. "NAV"
    if sel == 2 then text = text .. "*" else text = text .. " " end

    text = text .. "\n"

    -- DGFT
    if sel == 3 then text = text .. "*" else text = text .. " " end
    text = text .. "DGFT"
    if sel == 3 then text = text .. "*" else text = text .. " " end

    text = text .. "\n"

    if master_mode_aa_int then text = replace_pos(text, 20); text = replace_pos(text, 24) end
    if master_mode_ag then text = replace_pos(text, 27); text = replace_pos(text, 31) end
    if master_mode_nav then text = replace_pos(text, 44); text = replace_pos(text, 48) end
    if master_mode_aa_dgft then text = replace_pos(text, 50); text = replace_pos(text, 55) end

    UFCP_TEXT:set(text)
end

function SetCommandMode(command,value)
    if command == device_commands.UFCP_JOY_DOWN and value == 1 then
        sel = (sel + 1) % max_sel
    elseif command == device_commands.UFCP_JOY_UP and value == 1 then
        sel = (sel - 1) % max_sel
    elseif command == device_commands.UFCP_0 and value == 1 then
        if sel == 0 then
            local param = get_param_handle("WPN_AA_SLV_SRC")
            local slv_src = param:get()
            if slv_src == WPN_AA_SLV_SRC_IDS.BST then 
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.INT_B)
            else
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.INT_L)
            end
        elseif sel == 1 then
            -- TODO this needs to remember the last selected A/G mode
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.CCIP)
        elseif sel == 2 then
            set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.NAV)
        elseif sel == 3 then
            local param = get_param_handle("WPN_AA_SLV_SRC")
            local slv_src = param:get()
            if slv_src == WPN_AA_SLV_SRC_IDS.BST then 
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DGFT_B)
            else 
                set_avionics_master_mode(AVIONICS_MASTER_MODE_ID.DGFT_L)
            end
        end
    end
end