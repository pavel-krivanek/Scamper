Class {
	#name : #CSSSelectorError,
	#superclass : #CSSError,
	#category : 'HTML-CSS-Errors'
}

{ #category : #printing }
CSSSelectorError >> printOn: aStream [

	super printOn: aStream.
	self parent selector printOn: aStream.
]
