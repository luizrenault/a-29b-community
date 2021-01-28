declare_loadout({
	category		 = CAT_FUEL_TANKS,
	CLSID			 = "{A-29B TANK}",
	attribute		 =  {wsType_Air,wsType_Free_Fall,wsType_FuelTank,WSTYPE_PLACEHOLDER},


	LandRWCategories = 
    {
        [1] = 
        {
			Name = "AircraftCarrier",
        },
        [2] = 
        {
            Name = "AircraftCarrier With Catapult",
        }, 
        [3] = 
        {
            Name = "AircraftCarrier With Tramplin",
        }, 
    }, -- end of LandRWCategories
    TakeOffRWCategories = 
    {
        [1] = 
        {
			Name = "AircraftCarrier",
        },
        [2] = 
        {
            Name = "AircraftCarrier With Catapult",
        }, 
        [3] = 
        {
            Name = "AircraftCarrier With Tramplin",
        }, 
    }, -- end of TakeOffRWCategories

	Picture			 = "ptb2.png",
	displayName		 = _("A-29B TANK"),
	Weight_Empty	 = 1,
	Weight			 = 1 +  0.00775 * 2300,
	Cx_pil			 = 0.002,
	shape_table_data = 
	{
		{
			name 	= "A-29B TANK",
			file	= "A-29B TANK";
			life	= 1;
			fire	= { 0, 1};
			username	= "A-29B TANK";
			index	= WSTYPE_PLACEHOLDER;
		},
	},
	Elements	= 
	{
		{
			ShapeName	= "A-29B TANK",
		}, 
	}, 
})
