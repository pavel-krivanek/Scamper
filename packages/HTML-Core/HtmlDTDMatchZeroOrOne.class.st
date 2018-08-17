Class {
	#name : #HtmlDTDMatchZeroOrOne,
	#superclass : #HtmlDTDMatchConstraint,
	#category : #'HTML-Core-Validator'
}

{ #category : #printing }
HtmlDTDMatchZeroOrOne >> printOn: aStream [

	expression printOn: aStream.
	aStream nextPut: $?

	
]

{ #category : #matching }
HtmlDTDMatchZeroOrOne >> validateChildren: aStream ofNode: aNode [

	expression validateChildren: aStream ofNode: aNode.
	^true
]
