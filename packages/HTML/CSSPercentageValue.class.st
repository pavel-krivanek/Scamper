Class {
	#name : #CSSPercentageValue,
	#superclass : #CSSUnitizedNumberValue,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSPercentageValue >> allowableUnits [

	^#( '%' )
]

{ #category : #accessing }
CSSPercentageValue >> isValid [

	^super isValid and: [valueString asNumber >= 0]
]
