-- API functions to determine state of electric system
-- To use, add this near the top of your system file:
-- dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
-- and then call the functions below as needed, e.g.
-- if get_elec_mon_dc_ok() then
--   -- do stuff
-- end

function get_elec_primary_ac_ok()
    return elec_primary_ac_ok:get()==1 and true or false
end

function get_elec_primary_dc_ok()
    return elec_primary_dc_ok:get()==1 and true or false
end

function get_elec_26V_ac_ok()
    return elec_26V_ac_ok:get()==1 and true or false
end

function get_elec_aft_mon_ac_ok()
    return elec_aft_mon_ac_ok:get()==1 and true or false
end

function get_elec_fwd_mon_ac_ok()
    return elec_fwd_mon_ac_ok:get()==1 and true or false
end

function get_elec_mon_primary_ac_ok()
    return elec_mon_primary_ac_ok:get()==1 and true or false
end

function get_elec_mon_dc_ok()
    return elec_mon_dc_ok:get()==1 and true or false
end

function get_elec_mon_arms_dc_ok()
    return elec_mon_arms_dc_ok:get()==1 and true or false
end

function get_elec_emergency_gen_active()
    return elec_emergency_gen_active:get()==1 and true or false
end

function get_elec_external_power()
    return elec_external_power:get()==1 and true or false
end

function get_elec_retraction_release_ground()
    return elec_ground_mode:get()==1 and true or false
end

function get_elec_retraction_release_airborne()
    return elec_ground_mode:get()==0 and true or false
end

function debug_print_electric_system()
    print_message_to_user("primAC:"..tostring(elec_primary_ac_ok:get())..",primDC:"..tostring(elec_primary_dc_ok:get())..",26VAC:"..tostring(elec_26V_ac_ok:get())..
        "primmonAC:"..tostring(elec_mon_primary_ac_ok:get())..",afmonAC:"..tostring(elec_aft_mon_ac_ok:get())..",fwdmonAC:"..tostring(elec_fwd_mon_ac_ok:get())..
        "monDC:"..tostring(elec_mon_dc_ok:get())..",armsDC:"..tostring(elec_mon_arms_dc_ok:get()) )
end


elec_primary_ac_ok=get_param_handle("ELEC_PRIMARY_AC_OK") -- 1 or 0
elec_primary_dc_ok=get_param_handle("ELEC_PRIMARY_DC_OK") -- 1 or 0
elec_26V_ac_ok=get_param_handle("ELEC_26V_AC_OK") -- 1 or 0
elec_aft_mon_ac_ok=get_param_handle("ELEC_AFT_MON_AC_OK") -- 1 or 0
elec_fwd_mon_ac_ok=get_param_handle("ELEC_FWD_MON_AC_OK") -- 1 or 0
elec_mon_primary_ac_ok=get_param_handle("ELEC_MON_PRIMARY_AC_OK") -- 1 or 0
elec_mon_dc_ok=get_param_handle("ELEC_MON_DC_OK") -- 1 or 0
elec_mon_arms_dc_ok=get_param_handle("ELEC_MON_ARMS_DC_OK") -- 1 or 0
elec_emergency_gen_active=get_param_handle("ELEC_EMERGENCY_GEN_ACTIVE") -- 1 or 0
elec_external_power=get_param_handle("ELEC_EXTERNAL_POWER") -- 1 or 0
elec_ground_mode=get_param_handle("ELEC_GROUND_MODE") -- 1 or 0

