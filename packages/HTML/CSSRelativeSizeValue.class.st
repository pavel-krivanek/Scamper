Class {
	#name : #CSSRelativeSizeValue,
	#superclass : #CSSValue,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSRelativeSizeValue >> isValid [

	^#( 'smaller' 'larger' ) includes: self valueString trimBoth
]
