Class {
	#name : #CSSVersion3ConstructFoundError,
	#superclass : #CSSError,
	#category : 'HTML-CSS-Errors'
}

{ #category : #printing }
CSSVersion3ConstructFoundError >> printOn: aStream [

	super printOn: aStream.
	self parent printOn: aStream.
]
