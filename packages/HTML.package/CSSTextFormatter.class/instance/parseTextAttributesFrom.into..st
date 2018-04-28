parsing
parseTextAttributesFrom: aCSSProperty into: aContext
	(self attributeMap at: aCSSProperty propertyName ifAbsent: [nil])
		ifNotNil: [:process | process value: aCSSProperty value: aContext ]