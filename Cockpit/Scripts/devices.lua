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


devices["CANOPY"]           = counter()
devices["FLAPS"]            = counter()
devices["EXTANIM"]          = counter()

devices["TEST"]             = counter()
