Class {
	#name : #HtmlHEADNode,
	#superclass : #HtmlDOMNode,
	#category : 'HTML-DOM'
}

{ #category : #accessing }
HtmlHEADNode >> addToFormatter: aFormatter [
	"Do nothing"
]

{ #category : #accessing }
HtmlHEADNode >> tag [
	^ 'head'
]
