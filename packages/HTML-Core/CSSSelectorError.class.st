Class {
	#name : #CSSSelectorError,
	#superclass : #CSSError,
	#category : #'HTML-Core-CSS-Errors'
}

{ #category : #printing }
CSSSelectorError >> printOn: aStream [

	super printOn: aStream.
	self parent selector printOn: aStream.
]
