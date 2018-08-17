Class {
	#name : #CSSMarginFormatter,
	#superclass : #CSSDistanceFormatter,
	#category : 'HTML-Formatter'
}

{ #category : #constants }
CSSMarginFormatter class >> attributePrefix [

	^ 'margin'
]

{ #category : #constants }
CSSMarginFormatter class >> attributeSuffix [

	^ ''
]
