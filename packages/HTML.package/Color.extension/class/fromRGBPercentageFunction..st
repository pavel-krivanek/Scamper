*HTML
fromRGBPercentageFunction: aString
	|r g b splitString|
	('*%*' match:  aString) ifTrue: 
	[splitString := aString splitOn: ','.
	r := (splitString first trimBoth asInteger min: 0 max: 100) / 100.
	g := (splitString second trimBoth asInteger min: 0 max: 100) / 100.
	b := (splitString third trimBoth asInteger min: 0 max: 100) / 100.
	^ Color r: r g: g b: b.].
	^nil
	