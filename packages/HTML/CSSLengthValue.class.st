Class {
	#name : #CSSLengthValue,
	#superclass : #CSSUnitizedNumberValue,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSLengthValue >> allowableUnits [

	^#('em' 'ex' 'px' 'in' 'cm' 'mm' 'pt' 'pc') 
]

{ #category : #accessing }
CSSLengthValue >> isRelative [

	^#( 'em' 'ex' 'px') includes: self units
]

{ #category : #accessing }
CSSLengthValue >> isValid [

	^super isValid and:[units notNil or: [valueString asNumber = 0]]
]
