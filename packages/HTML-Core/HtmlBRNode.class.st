Class {
	#name : #HtmlBRNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #rendering }
HtmlBRNode >> addToFormatter: formatter [
	formatter addChar: Character cr.
]

{ #category : #accessing }
HtmlBRNode >> tag [
	^ 'br'
]
