Class {
	#name : #HtmlSMALLNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #'initialize-release' }
HtmlSMALLNode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'font-size' -> 'smaller'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #accessing }
HtmlSMALLNode >> tag [
	^ 'small'
]
