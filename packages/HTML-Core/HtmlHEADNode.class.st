Class {
	#name : #HtmlHEADNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #accessing }
HtmlHEADNode >> addToFormatter: aFormatter [
	"Do nothing"
]

{ #category : #accessing }
HtmlHEADNode >> tag [
	^ 'head'
]
