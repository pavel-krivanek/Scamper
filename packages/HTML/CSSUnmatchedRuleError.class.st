Class {
	#name : #CSSUnmatchedRuleError,
	#superclass : #CSSError,
	#category : 'HTML-CSS-Errors'
}

{ #category : #printing }
CSSUnmatchedRuleError >> printOn: aStream [

	super printOn: aStream.
	self parent printOn: aStream.
]
