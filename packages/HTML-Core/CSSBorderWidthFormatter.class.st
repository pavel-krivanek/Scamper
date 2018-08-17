Class {
	#name : #CSSBorderWidthFormatter,
	#superclass : #CSSDistanceFormatter,
	#category : #'HTML-Core-Formatter'
}

{ #category : #constants }
CSSBorderWidthFormatter class >> attributePrefix [

	^ 'border'
]

{ #category : #constants }
CSSBorderWidthFormatter class >> attributeSuffix [

	^ '-width'
]
