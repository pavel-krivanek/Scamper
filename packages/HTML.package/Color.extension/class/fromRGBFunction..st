*HTML
fromRGBFunction: aString
	|r g b splitString|
	(aString beginsWith: 'rgb') ifTrue: 
	[splitString := aString splitOn: ','.
	r := (splitString first trimBoth asInteger min: 255 max: 0) / 255.
	g := (splitString second trimBoth asInteger min: 255 max: 0) / 255.
	b := (splitString third trimBoth asInteger min: 255 max: 0) / 255. 
	^ Color r: r g: g b: b.].
	^nil
	