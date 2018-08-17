Class {
	#name : #HtmlHRNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #rendering }
HtmlHRNode >> addToFormatter: formatter [
	formatter hr
]

{ #category : #accessing }
HtmlHRNode >> tag [
	^ 'hr'
]
