dofile(LockOn_Options.script_path.."Systems/ufcp_api.lua")

local hsd_rad_sel = 20

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

function update_hsd()
    for k=1,100 do
        -- TODO (0,0) is a valid waypoint.
        if nav_fyt_list[k] and nav_fyt_list[k].lat ~= 0 and nav_fyt_list[k].lon ~= 0 then

            local dest_lat_m = nav_fyt_list[k].lat_m
            local dest_lon_m = nav_fyt_list[k].lon_m
            local dest_alt_m = nav_fyt_list[k].altitude / 3.28084

            local hdg, distance = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, dest_alt_m)
            hdg = math.deg(hdg) % 360

            get_param_handle("CMFD_HSD_WP" .. k .. "_ID"):set(string.format("%02d", k-1))
            get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):set(hdg)
            get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel)
        else
            get_param_handle("CMFD_HSD_WP" .. k .. "_ID"):set(string.format("%02d", k-1))
            get_param_handle("CMFD_HSD_WP" .. k .. "_BRG"):set(0)
            get_param_handle("CMFD_HSD_WP" .. k .. "_DIST"):set(0)
        end
    end
end

function SetCommandHsd(command,value, CMFD)
   
end

function post_initialize_adhsi()

end