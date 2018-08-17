Class {
	#name : #HtmlUnclosedCommentError,
	#superclass : #HtmlSyntaxError,
	#category : 'HTML-DOM-Errors'
}

{ #category : #testing }
HtmlUnclosedCommentError >> isStructuralError [

	^true
]

{ #category : #testing }
HtmlUnclosedCommentError >> printOn: aStream [

	aStream nextPutAll: 'Comment section not properly terminated.'
]
