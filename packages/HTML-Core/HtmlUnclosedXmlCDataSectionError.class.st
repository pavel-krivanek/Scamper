Class {
	#name : #HtmlUnclosedXmlCDataSectionError,
	#superclass : #HtmlSyntaxError,
	#category : #'HTML-Core-DOM-Errors'
}

{ #category : #testing }
HtmlUnclosedXmlCDataSectionError >> isStructuralError [

	^true
]

{ #category : #testing }
HtmlUnclosedXmlCDataSectionError >> printOn: aStream [

	aStream nextPutAll: 'CDATA section not properly terminated.'
]
