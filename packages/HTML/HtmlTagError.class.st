Class {
	#name : #HtmlTagError,
	#superclass : #HtmlError,
	#category : 'HTML-DOM-Errors'
}

{ #category : #testing }
HtmlTagError >> isTagError [

	^true
]

{ #category : #printing }
HtmlTagError >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: (' Tag: ', self tag)
]
