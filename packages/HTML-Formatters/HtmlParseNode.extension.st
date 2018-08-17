Extension { #name : #HtmlParseNode }

{ #category : #'*HTML-Formatters' }
HtmlParseNode >> addToFormatter: aFormatter [
	self children do: [:e | e addToFormatter: aFormatter ]
]
