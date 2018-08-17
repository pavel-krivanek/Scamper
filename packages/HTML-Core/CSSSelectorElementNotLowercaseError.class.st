Class {
	#name : #CSSSelectorElementNotLowercaseError,
	#superclass : #CSSSelectorError,
	#instVars : [
		'element'
	],
	#category : #'HTML-Core-CSS-Errors'
}

{ #category : #accessing }
CSSSelectorElementNotLowercaseError >> element [
	"Answer the value of element"

	^ element
]

{ #category : #accessing }
CSSSelectorElementNotLowercaseError >> element: anObject [
	"Set the value of element"

	element := anObject
]
