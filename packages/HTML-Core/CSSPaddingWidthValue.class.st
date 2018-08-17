Class {
	#name : #CSSPaddingWidthValue,
	#superclass : #CSSLengthValue,
	#category : #'HTML-Core-CSS'
}

{ #category : #accessing }
CSSPaddingWidthValue >> allowableUnits [

	^super allowableUnits copyWith: '%'
]
