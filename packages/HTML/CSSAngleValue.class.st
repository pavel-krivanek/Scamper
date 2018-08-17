Class {
	#name : #CSSAngleValue,
	#superclass : #CSSUnitizedNumberValue,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSAngleValue >> allowableUnits [

	^#('deg' 'grad' 'rad')
]
