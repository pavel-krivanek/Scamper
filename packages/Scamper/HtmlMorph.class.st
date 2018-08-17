Class {
	#name : #HtmlMorph,
	#superclass : #Morph,
	#instVars : [
		'layoutStyles'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #initialization }
HtmlMorph >> initialize [ 

	super initialize.
	self layoutStyles: (HtmlLayoutStyles newFor: self).
]

{ #category : #accessing }
HtmlMorph >> layoutStyles [
	^ layoutStyles
]

{ #category : #accessing }
HtmlMorph >> layoutStyles: anObject [
	layoutStyles := anObject
]
