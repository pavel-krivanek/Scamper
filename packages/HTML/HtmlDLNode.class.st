Class {
	#name : #HtmlDLNode,
	#superclass : #HtmlDOMNode,
	#category : 'HTML-DOM'
}

{ #category : #rendering }
HtmlDLNode >> endStyles: aFormatter [
	aFormatter ensureNewlines: 1.
]

{ #category : #accessing }
HtmlDLNode >> tag [
	^ 'dl'
]
