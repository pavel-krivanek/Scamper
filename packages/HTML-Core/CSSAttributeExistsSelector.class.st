Class {
	#name : #CSSAttributeExistsSelector,
	#superclass : #CSSAttributeSelector,
	#category : #'HTML-Core-CSS'
}

{ #category : #testing }
CSSAttributeExistsSelector >> matches: aNode [

	^(self privateAttributeKeyInNode: aNode) notNil
]
