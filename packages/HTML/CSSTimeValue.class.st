Class {
	#name : #CSSTimeValue,
	#superclass : #CSSUnitizedNumberValue,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSTimeValue >> allowableUnits [

	^#( 's' 'ms')
]

{ #category : #accessing }
CSSTimeValue >> isValid [

	^super isValid and: [valueString asNumber >= 0]
]
