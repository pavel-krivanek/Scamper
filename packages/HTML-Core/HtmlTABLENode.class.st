Class {
	#name : #HtmlTABLENode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #'initialize-release' }
HtmlTABLENode >> addDefaultStyle [
	| styles |
	styles := Dictionary newFrom: {
		'display' -> 'table'.
	}.
	self addStyle: (CSSDefaultStyleRule fromDictionary: styles)
]

{ #category : #rendering }
HtmlTABLENode >> endStyles: aFormatter [
	aFormatter ensureNewlines: 1
]

{ #category : #accessing }
HtmlTABLENode >> startStyles: aFormatter [
	aFormatter ensureNewlines: 1
]

{ #category : #accessing }
HtmlTABLENode >> tag [
	^ 'table'
]
