*HTML
fromRGBFunction: aString
	|r g b splitString|
	(aString beginsWith: 'rgb') ifTrue: 
	[splitString := aString splitOn: ','.
	r := (splitString first trimBoth asInteger min: 0 max: 255) / 255.
	g := (splitString second trimBoth asInteger min: 0 max: 255) / 255.
	b := (splitString third trimBoth asInteger min: 0 max: 255) / 255. 
	^ Color r: r g: g b: b.].
	^nil
	