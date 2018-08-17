Class {
	#name : #CSSValueTypeZeroOrMoreOf,
	#superclass : #CSSValueTypeConstraint,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSValueTypeZeroOrMoreOf class >> type [

	^$*
]

{ #category : #testing }
CSSValueTypeZeroOrMoreOf >> addValues: aCollection fromStream: in [

	| pos |
	[
		pos := in position.
		type addValues: aCollection fromStream: in
	] whileTrue:[].
	in position: pos.
	^true
]
