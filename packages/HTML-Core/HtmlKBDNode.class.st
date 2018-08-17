Class {
	#name : #HtmlKBDNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #accessing }
HtmlKBDNode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'font-family' -> 'TrebuchetMS'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #accessing }
HtmlKBDNode >> tag [
	^ 'kbd'
]
