local DbOption  = require('Options.DbOption')
local i18n		= require('i18n')
local oms       = require('optionsModsScripts')

local _ = i18n.ptranslate


return {
	autoLeanToAimA29B 		= DbOption.new():setValue(true):checkbox(),
	gunCamera				= DbOption.new():setValue(0):combo({DbOption.Item(_('OFF')):Value(0),
																DbOption.Item(_('ONLY FOR TRACKS')):Value(1),
																DbOption.Item(_('ON')):Value(2),}),
	aiHelper				= DbOption.new():setValue(false):checkbox(),
    CPLocalList				= oms.getCPLocalList("Cockpit_A29B"),	
}
