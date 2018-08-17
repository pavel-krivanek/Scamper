Class {
	#name : #CSSMarginFormatter,
	#superclass : #CSSDistanceFormatter,
	#category : #'HTML-Formatters'
}

{ #category : #constants }
CSSMarginFormatter class >> attributePrefix [

	^ 'margin'
]

{ #category : #constants }
CSSMarginFormatter class >> attributeSuffix [

	^ ''
]
