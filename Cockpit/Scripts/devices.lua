local count = 0
local function counter()
	count = count + 1
	return count
end
-------DEVICE ID-------
devices                     = {}
devices["ELECTRIC_SYSTEM"]  = counter()
devices["ENGINE"]           = counter()
devices["FUEL"]           = counter()
devices["EXTLIGHTS"]           = counter()
devices["INTLIGHTS"]           = counter()
devices["ICEPROT"]           = counter()
devices["ENVIRON"]           = counter()
devices["GEAR"]             = counter()
devices["BRAKES"]           = counter()
devices["CMFD"]           = counter()
devices["HUD"]           = counter()
devices["AVIONICS"]           = counter()
devices["VUHF1_RADIO"]          = counter()
devices["VUHF2_RADIO"]          = counter()
devices["HF3_RADIO"]          = counter()
devices["RADIO"]          = counter()

devices["AIRBRAKE"]          = counter()

devices["CANOPY"]           = counter()
devices["FLAPS"]            = counter()
devices["EXTANIM"]          = counter()
devices["WEAPON_SYSTEM"]          = counter()
devices["INTERCOM"]			=counter()
devices["UFCP"]			=counter()

devices["TEST"]             = counter()
devices["ALARM"]             = counter()
devices["HELMET_DEVICE"]     = counter()
devices["AUTOPILOT"]     = counter()
devices["SAI"]     = counter()
devices["ILS"]     = counter()
devices["ILS_DEVICE"]     = counter()
