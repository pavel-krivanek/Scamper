parsing
parseTextAttributesFrom: aCSSProperty into: aContext
	aCSSProperty propertyName = 'color' ifFalse: [^nil].
	(Color fromHTMLString: aCSSProperty propertyString) ifNotNil:
		[:color | aContext at: #color put: color].