Class {
	#name : #HtmlUnclosedProcessingDirectiveError,
	#superclass : #HtmlSyntaxError,
	#category : 'HTML-DOM-Errors'
}

{ #category : #testing }
HtmlUnclosedProcessingDirectiveError >> isStructuralError [

	^true
]

{ #category : #testing }
HtmlUnclosedProcessingDirectiveError >> printOn: aStream [

	aStream nextPutAll: 'Processing directive not properly terminated.'
]
