Class {
	#name : #CSSAttributeExistsSelector,
	#superclass : #CSSAttributeSelector,
	#category : 'HTML-CSS'
}

{ #category : #testing }
CSSAttributeExistsSelector >> matches: aNode [

	^(self privateAttributeKeyInNode: aNode) notNil
]
