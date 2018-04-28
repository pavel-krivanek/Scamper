*HTML
fromHTMLString: aString
	(self fromColorName: aString) ifNotNil: [:color | ^color].
	(self fromHexRGBString: aString) ifNotNil: [:color | ^color].
	(self fromRGBPercentageFunction: aString) ifNotNil: [:color | ^color].
	(self fromRGBFunction: aString) ifNotNil: [:color | ^color].
	^ self fromString: aString