dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

package.cpath 			= package.cpath..";".. LockOn_Options.script_path.. "..\\..\\bin\\?.dll"
require('avSimplestRadio')

local dev = GetSelf()

function post_initialize()
    avSimplestRadio.Setup(devices.UHF_RADIO, devices.INTERCOM, devices.ELECTRIC_SYSTEM)
end

dev:listen_command(179)
dev:listen_command(Keys.COM1)
dev:listen_command(Keys.COM2)
dev:listen_command(Keys.COM3)

function SetCommand(command,value)
    if command==Keys.COM1 and value == 1 then
        avSimplestRadio.PTT()
    elseif command==Keys.COM2 and value == 1 then
        avSimplestRadio.PTT()
    elseif command==Keys.COM3 and value == 1 then
        avSimplestRadio.PTT()
    end
end

need_to_be_closed = false


