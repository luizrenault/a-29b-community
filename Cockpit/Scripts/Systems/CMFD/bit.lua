local BIT_TEXT = get_param_handle("CMFD_BIT_TEXT")
BIT_TEXT:set("")

function update_bit()
    local text = "TEST\n\n"

    for k=110,120 do
        if nav_fyt_list[k] and nav_fyt_list[k].lat >= -90 and nav_fyt_list[k].lat <= 90 and nav_fyt_list[k].lon >= -180 and nav_fyt_list[k].lon <= 180 then

            local dest_lat_m = nav_fyt_list[k].lat_m
            local dest_lon_m = nav_fyt_list[k].lon_m
            local dest_alt_m = nav_fyt_list[k].altitude / 3.28084
            local radius = nav_fyt_list[k].radius / 60

            text = text .. k .. ") " .. nav_fyt_list[k].lat .. " " .. nav_fyt_list[k].lon .. "\n\n"
        else
            text = text .. k .. " ---" .. "\n\n"
        end
    end

    BIT_TEXT:set(text)
end

function SetCommandBit(command,value, CMFD)
   
end

function post_initialize_bit()

end
