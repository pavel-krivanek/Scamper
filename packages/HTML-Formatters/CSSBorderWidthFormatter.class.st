Class {
	#name : #CSSBorderWidthFormatter,
	#superclass : #CSSDistanceFormatter,
	#category : #'HTML-Formatters'
}

{ #category : #constants }
CSSBorderWidthFormatter class >> attributePrefix [

	^ 'border'
]

{ #category : #constants }
CSSBorderWidthFormatter class >> attributeSuffix [

	^ '-width'
]
