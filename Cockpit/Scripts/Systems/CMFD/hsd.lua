dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

local hsd_rad_sel = 20

local HSD_RAD_SEL = get_param_handle("HSD_RAD_SEL")

local ADHSI_DTK_HDG = get_param_handle("ADHSI_DTK_HDG")
local ADHSI_DTK_DIST = get_param_handle("ADHSI_DTK_DIST")
local ADHSI_DTK = get_param_handle("ADHSI_DTK")
local CMFD_NAV_FYT = get_param_handle("CMFD_NAV_FYT")

local function calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m, orig_lat_m, orig_lon_m, orig_alt_m)
    local o_lat_m, o_alt_m, o_lon_m = sensor_data.getSelfCoordinates()
    orig_lat_m = orig_lat_m or o_lat_m
    orig_lon_m = orig_lon_m or o_lon_m
    orig_alt_m = orig_alt_m or o_alt_m

    local brg, dist

    local lat = dest_lat_m - orig_lat_m
    local lon = dest_lon_m - orig_lon_m

    brg = math.atan2(lon, lat)
    dist = math.sqrt(lat * lat + lon * lon)

    return brg, dist
end

local function coord_project(orig_lat_m, orig_lon_m, brg, dist)
    orig_lat_m = orig_lat_m + dist * math.cos(math.rad(brg))
    orig_lon_m = orig_lon_m + dist * math.sin(math.rad(brg))
    return orig_lat_m, orig_lon_m
end

function update_hsd()
    for k=1,100 do
        if nav_fyt_list[k] and nav_fyt_list[k].lat >= -90 and nav_fyt_list[k].lat <= 90 and nav_fyt_list[k].lon >= -180 and nav_fyt_list[k].lon <= 180 then

            local dest_lat_m = nav_fyt_list[k].lat_m
            local dest_lon_m = nav_fyt_list[k].lon_m
            local dest_alt_m = nav_fyt_list[k].altitude / 3.28084

            local hdg, distance = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m)
            hdg = math.deg(hdg) % 360

            get_param_handle("CMFD_HSD_WP" .. k .. "_ID"):set(string.format("%02d", k-1))
            get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):set(hdg)
            get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel)

            get_param_handle("CMFD_HSD_DTK" .. k .. "_BRG"):set(get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):get())
            get_param_handle("CMFD_HSD_DTK" .. k .. "_DIST"):set(get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):get())
            get_param_handle("CMFD_HSD_DTK" .. k):set((ADHSI_DTK:get() == 1 and CMFD_NAV_FYT:get() == k-1) and 1 or 0)

            if ADHSI_DTK:get() == 1 and CMFD_NAV_FYT:get() == k-1 then 
                dest_lat_m, dest_lon_m = coord_project(dest_lat_m, dest_lon_m, ADHSI_DTK_HDG:get()+180, ADHSI_DTK_DIST:get()/0.000539957)
                
                hdg, distance = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m)
                hdg = math.deg(hdg) % 360

                get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):set(hdg)
                get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel)
            end


        else
            get_param_handle("CMFD_HSD_WP" .. k .. "_ID"):set(string.format("%02d", k-1))
            get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):set(0)
            get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):set(0)
        end
    end

    HSD_RAD_SEL:set(hsd_rad_sel)
end

function SetCommandHsd(command,value, CMFD)
    if value == 1 then 
        local selected=-1

        -- Change zoom
        if command==device_commands.CMFD1OSS27 or command==device_commands.CMFD2OSS27 then 
            hsd_rad_sel = math.max(20, hsd_rad_sel / 2) -- increase zoom
        elseif command==device_commands.CMFD1OSS28 or command==device_commands.CMFD2OSS28 then 
            hsd_rad_sel = math.min(1280, hsd_rad_sel * 2) -- decrease zoom

        -- Select ADHSI format
        elseif command==device_commands.CMFD1OSS26 or command==device_commands.CMFD2OSS26 then 
            selected=SUB_PAGE_ID.ADHSI
        
        end

        if selected > 0 then
            CMFD["Format"]:set(selected)
            CMFD["Sel"]:set(selected)
            if CMFD["Primary"]:get()==1 then
                CMFD["SelRight"]:set(selected)
                CMFD["SelRightName"]:set(SUB_PAGE_NAME[selected])
            else 
                CMFD["SelLeft"]:set(selected)
                CMFD["SelLeftName"]:set(SUB_PAGE_NAME[selected])
            end
        end
    end
end

function post_initialize_hsd()

end