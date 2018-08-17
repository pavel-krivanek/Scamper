Class {
	#name : #CSSGenericVoiceValue,
	#superclass : #CSSValue,
	#category : #'HTML-Core-CSS'
}

{ #category : #accessing }
CSSGenericVoiceValue >> isValid [

	^#( 'male' 'female' 'child' ) includes: self valueString trimBoth
]
