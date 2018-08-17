Class {
	#name : #CSSFrequencyValue,
	#superclass : #CSSUnitizedNumberValue,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSFrequencyValue >> allowableUnits [

	^#( 'hz' 'khz')
]

{ #category : #accessing }
CSSFrequencyValue >> isValid [

	^super isValid and: [valueString asNumber >= 0]
]
