Class {
	#name : #HtmlFatalError,
	#superclass : #HtmlError,
	#category : #'HTML-Core-DOM-Errors'
}

{ #category : #testing }
HtmlFatalError >> isFatal [

	^true
]

{ #category : #printing }
HtmlFatalError >> printOn: aStream [

	super printOn: aStream.
	'ERROR!  This page is much too broken to parse.' printOn: aStream.
]
