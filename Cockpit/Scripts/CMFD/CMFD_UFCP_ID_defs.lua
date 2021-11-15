
local count = -1
local function counter()
	count = count + 1
	return count
end

CMFD_UFCP_FORMAT_IDS = {
    UFC1        = counter(),
    UFC2          = counter(),
    UFC3          = counter(),
}
