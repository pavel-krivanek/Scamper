Class {
	#name : #CSSAngleValue,
	#superclass : #CSSUnitizedNumberValue,
	#category : #'HTML-Core-CSS'
}

{ #category : #accessing }
CSSAngleValue >> allowableUnits [

	^#('deg' 'grad' 'rad')
]
