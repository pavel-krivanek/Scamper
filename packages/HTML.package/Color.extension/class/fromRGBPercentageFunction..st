*HTML
fromRGBPercentageFunction: aString
	|r g b splitString|
	('*%*' match:  aString) ifTrue: 
	[splitString := aString splitOn: ','.
	r := (splitString first trimBoth asInteger min: 100 max: 0) / 100.
	g := (splitString second trimBoth asInteger min: 100 max: 0) / 100.
	b := (splitString third trimBoth asInteger min: 100 max: 0) / 100.
	^ Color r: r g: g b: b.].
	^nil
	