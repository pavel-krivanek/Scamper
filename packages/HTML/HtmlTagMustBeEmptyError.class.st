Class {
	#name : #HtmlTagMustBeEmptyError,
	#superclass : #HtmlTagStructureError,
	#category : 'HTML-DOM-Errors'
}

{ #category : #printing }
HtmlTagMustBeEmptyError >> printOn: aStream [

	self parent tag printOn: aStream.
	aStream nextPutAll: ' must be empty.'
]
