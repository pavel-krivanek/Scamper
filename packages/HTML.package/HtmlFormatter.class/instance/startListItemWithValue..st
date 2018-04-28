formatting commands
startListItemWithValue: aValue
	listLengths at: (listLengths size) put: (aValue asNumber - 1).
	self startListItem.