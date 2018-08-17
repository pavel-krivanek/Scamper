Class {
	#name : #HtmlDTNode,
	#superclass : #HtmlDOMNode,
	#category : 'HTML-DOM'
}

{ #category : #accessing }
HtmlDTNode >> startStyles: aFormatter [
	aFormatter ensureNewlines: 1
]

{ #category : #accessing }
HtmlDTNode >> tag [
	^ 'dt'
]
