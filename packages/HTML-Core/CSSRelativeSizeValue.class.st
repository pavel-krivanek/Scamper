Class {
	#name : #CSSRelativeSizeValue,
	#superclass : #CSSValue,
	#category : #'HTML-Core-CSS'
}

{ #category : #accessing }
CSSRelativeSizeValue >> isValid [

	^#( 'smaller' 'larger' ) includes: self valueString trimBoth
]
