size-conversion
relativeSizeToPx: aString parentAndDefaultSize: aNumber
	| value |
	aString ifNil: [^aNumber].
	(aString endsWith: 'larger') ifTrue: [ ^aNumber * 1.3].
	(aString endsWith: 'smaller') ifTrue: [ ^aNumber * 0.7].
	value := [aString asNumber] ifError: [0]. "TODO: .5em"
	value ifNil: [^aNumber].
	
	(aString endsWithAnyOf: {'em' . 'ex'}) ifTrue: [ ^value * aNumber ].
	(aString endsWith: '%') ifTrue: [ ^value / 100 * aNumber ].
	
	^aNumber