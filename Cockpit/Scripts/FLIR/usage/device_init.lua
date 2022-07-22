creators[devices.FLIR]		      = {"LR::avSimplestFLIR"    ,LockOn_Options.script_path.."FLIR/device.lua"}
indicators[#indicators + 1] = {"LR::ccCamera", LockOn_Options.script_path.."FLIR/indicator.lua", devices.FLIR,	{{}}}
