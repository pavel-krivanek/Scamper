testing
test05FontFamilyShouldBeParsedCorrectly
	| prop result |
	result := Dictionary new.
	prop := CSSProperty new
				propertyName: 'font-family';
				propertyString: 'non-existent, serif, sans-serif';
				yourself.
	self fontFormatter parseTextAttributesFrom: prop into: result.
	self assert: (TextStyle default) equals: (result at: #fontFamily).
