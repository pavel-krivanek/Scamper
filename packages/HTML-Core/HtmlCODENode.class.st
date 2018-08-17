Class {
	#name : #HtmlCODENode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #accessing }
HtmlCODENode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'font-family' -> 'Courier New'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #accessing }
HtmlCODENode >> tag [
	^ 'code'
]
