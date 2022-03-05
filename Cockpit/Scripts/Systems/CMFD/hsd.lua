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

    -- Waypoints
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

    -- Contact line
    for k=101,105 do
        if nav_fyt_list[k] and nav_fyt_list[k].lat >= -90 and nav_fyt_list[k].lat <= 90 and nav_fyt_list[k].lon >= -180 and nav_fyt_list[k].lon <= 180 then
            local origin_lat_m = nav_fyt_list[k].lat_m
            local origin_lon_m = nav_fyt_list[k].lon_m
            local hdg, distance = calc_brg_dist_elev_time(origin_lat_m, origin_lon_m, 0)

            hdg = math.deg(hdg) % 360            

            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_ID"):set(string.format("%02d", k-100))
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG"):set(hdg) -- Rotation relative to the HSI center
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel) -- Distance relative to the HSI center

            if nav_fyt_list[k+1] and nav_fyt_list[k+1].lat >= -90 and nav_fyt_list[k+1].lat <= 90 and nav_fyt_list[k+1].lon >= -180 and nav_fyt_list[k+1].lon <= 180 then
                local dest_lat_m = nav_fyt_list[k+1].lat_m
                local dest_lon_m = nav_fyt_list[k+1].lon_m
                local hdg2, distance2 = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, 0, origin_lat_m, origin_lon_m, 0)
                hdg2 = math.deg(hdg2) % 360

                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG2"):set(hdg2) -- Angle to next point
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_X"):set(0)
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_Y"):set(distance2 * 0.000539957 / hsd_rad_sel)
            else
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG2"):set(0)
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_X"):set(0)
                get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_Y"):set(0)
            end
            
        else
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_ID"):set(string.format("%02d", k-100))
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG"):set(0)
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_DIST"):set(0)
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_BRG2"):set(0)
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_X"):set(0)
            get_param_handle("CMFD_HSD_CNTLINE" .. k .. "_Y"):set(0)
        end
    end

    -- Flight areas
    for area=1,25 do
        local lat_sum = 0
        local lon_sum = 0
        local code = ""
        local count = 0

        for point=1,6 do
            local k = 200 + (area - 1) * 6 + (point - 1) + 1

            if nav_fyt_list[k] and nav_fyt_list[k].lat >= -90 and nav_fyt_list[k].lat <= 90 and nav_fyt_list[k].lon >= -180 and nav_fyt_list[k].lon <= 180 then
                local origin_lat_m = nav_fyt_list[k].lat_m
                local origin_lon_m = nav_fyt_list[k].lon_m
                local hdg, distance = calc_brg_dist_elev_time(origin_lat_m, origin_lon_m, 0)

                code = nav_fyt_list[k].code
                lat_sum = lat_sum + origin_lat_m
                lon_sum = lon_sum + origin_lon_m
                count = count + 1

                hdg = math.deg(hdg) % 360            

                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_ID"):set(nav_fyt_list[k].code)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_BRG"):set(hdg) -- Rotation relative to the HSI center
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel) -- Distance relative to the HSI center

                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_LABEL_BRG"):set(hdg) -- Rotation relative to the HSI center
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_LABEL_DIST"):set(distance * 0.000539957 / hsd_rad_sel) -- Distance relative to the HSI center

                local l = k + 1
                if point == 6 then
                    l = 200 + (area - 1) * 6 + 1
                end

                if nav_fyt_list[l] and nav_fyt_list[l].lat >= -90 and nav_fyt_list[l].lat <= 90 and nav_fyt_list[l].lon >= -180 and nav_fyt_list[l].lon <= 180 then
                    local dest_lat_m = nav_fyt_list[l].lat_m
                    local dest_lon_m = nav_fyt_list[l].lon_m
                    local hdg2, distance2 = calc_brg_dist_elev_time(dest_lat_m, dest_lon_m, 0, origin_lat_m, origin_lon_m, 0)
                    hdg2 = math.deg(hdg2) % 360

                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_BRG2"):set(hdg2) -- Angle to next point
                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_X"):set(0)
                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_Y"):set(distance2 * 0.000539957 / hsd_rad_sel)
                else
                    get_param_handle("CMFD_HSD_FLTAREAE" .. k .. "_BRG2"):set(0)
                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_X"):set(0)
                    get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_Y"):set(0)
                end

            else
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_ID"):set("")
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_BRG"):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_DIST"):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_BRG2"):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_X"):set(0)
                get_param_handle("CMFD_HSD_FLTAREA" .. k .. "_Y"):set(0)
            end
        end

        if count > 0 then
            local label_lat = lat_sum / count
            local label_lon = lon_sum / count

            local hdg, distance = calc_brg_dist_elev_time(label_lat, label_lon, 0)
            hdg = math.deg(hdg) % 360  

            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_ID"):set(code)
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_BRG"):set(hdg) -- Rotation relative to the HSI center
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_DIST"):set(distance * 0.000539957 / hsd_rad_sel) -- Rotation relative to the HSI center
        else
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_ID"):set("")
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_BRG"):set(0) -- Rotation relative to the HSI center
            get_param_handle("CMFD_HSD_FLTAREA_LABEL" .. area .. "_DIST"):set(0) -- Rotation relative to the HSI center
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