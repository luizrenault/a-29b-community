local count = 0
local function counter()
	count = count + 1
	return count
end

CMFD_TEXT = {
    FLIR_FILTER_STATUS = counter(),
    FLIR_SYMBOLOGY = counter(),
    FLIR_GAIN = counter(),
    FLIR_SCENE = counter(),
    FLIR_TRACKER = counter(),
    FLIR_CURRENT_MODE = counter(),
    FLIR_FOV = counter(),
    FLIR_FREEZE = counter(),
    FLIR_POLARITY = counter(),
    FLIR_STATUS = counter(),
    FLIR_COORDS = counter(),
    FLIR_TARGET = counter(),
}
