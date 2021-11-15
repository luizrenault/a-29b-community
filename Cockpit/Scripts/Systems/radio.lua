dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avSimplestRadio')

local dev = GetSelf()

function post_initialize()
    avSimplestRadio.SetupRadios(devices.ELECTRIC_SYSTEM, devices.INTERCOM, 3, devices.VUHF1_RADIO, devices.VUHF2_RADIO, devices.HF3_RADIO)
end

dev:listen_command(179)
dev:listen_command(Keys.COM1)
dev:listen_command(Keys.COM2)
dev:listen_command(Keys.COM3)

function SetCommand(command,value)
    if command==Keys.COM1 and value == 1 then
        avSimplestRadio.PTT(1)
    elseif command==Keys.COM2 and value == 1 then
        avSimplestRadio.PTT(2)
    elseif command==Keys.COM3 and value == 1 then
        avSimplestRadio.PTT(3)
    end
end

need_to_be_closed = false


