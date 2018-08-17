Class {
	#name : #HtmlGridPosition,
	#superclass : #LayoutProperties,
	#instVars : [
		'column',
		'row'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #accessing }
HtmlGridPosition >> column [

	^ column
]

{ #category : #accessing }
HtmlGridPosition >> column: anObject [

	column := anObject
]

{ #category : #accessing }
HtmlGridPosition >> row [

	^ row
]

{ #category : #accessing }
HtmlGridPosition >> row: anObject [

	row := anObject
]
