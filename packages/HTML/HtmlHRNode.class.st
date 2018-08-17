Class {
	#name : #HtmlHRNode,
	#superclass : #HtmlDOMNode,
	#category : 'HTML-DOM'
}

{ #category : #rendering }
HtmlHRNode >> addToFormatter: formatter [
	formatter hr
]

{ #category : #accessing }
HtmlHRNode >> tag [
	^ 'hr'
]
