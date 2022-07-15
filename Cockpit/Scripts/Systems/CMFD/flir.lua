local FLIR_AZ = get_param_handle("FLIR_AZ")
local FLIR_AZ_DEG = get_param_handle("FLIR_AZ_DEG")
local FLIR_EL = get_param_handle("FLIR_EL")
local FLIR_EL_DEG = get_param_handle("FLIR_EL_DEG")
local FLIR_TIME = get_param_handle("FLIR_TIME")

FLIR_TIME:set(" ")

function update_flir()
    FLIR_AZ_DEG:set(math.deg(FLIR_AZ:get()))
    FLIR_EL_DEG:set(math.deg(FLIR_EL:get()))

    local time = get_absolute_model_time()
    local hour = math.floor(time/3600)
    local minute = math.floor((time/60) % 60)
    local second = math.floor(time%60)
    FLIR_TIME:set(string.format("%02.0f-%02.0f-%02.0f %02.0f:%02.0f:%02.0fL",LockOn_Options.date.day,LockOn_Options.date.month, LockOn_Options.date.year%100,  hour,minute,second))

end

function SetCommandFlir(command,value, CMFD)
   
end

function post_initialize_flir()

end