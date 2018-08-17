Class {
	#name : #CSSGenericVoiceValue,
	#superclass : #CSSValue,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSGenericVoiceValue >> isValid [

	^#( 'male' 'female' 'child' ) includes: self valueString trimBoth
]
