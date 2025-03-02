menu declaration
shiftedYellowButtonMenu
	^ (PragmaMenuBuilder 
			pragmaKeyword: self shiftedMenuKeyword
			model: nil) menu.
