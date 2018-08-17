Class {
	#name : #HtmlDTDMatchConstraint,
	#superclass : #HtmlDTDMatchExpression,
	#category : #'HTML-Core-Validator'
}

{ #category : #accessing }
HtmlDTDMatchConstraint >> allowedElements [

	^expression allowedElements
]

{ #category : #matching }
HtmlDTDMatchConstraint >> allowsItem: anItem [

	^expression allowsItem: anItem
]
