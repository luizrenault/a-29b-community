
local count = -1
local function counter()
	count = count + 1
	return count
end

CMFD_NAV_FORMAT_IDS = {
    ROUT        = counter(),
    FYT          = counter(),
    MARK          = counter(),
    AC          = counter(),
    AFLD          = counter(),
}
