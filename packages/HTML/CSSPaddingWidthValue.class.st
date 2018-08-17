Class {
	#name : #CSSPaddingWidthValue,
	#superclass : #CSSLengthValue,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSPaddingWidthValue >> allowableUnits [

	^super allowableUnits copyWith: '%'
]
