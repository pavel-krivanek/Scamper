Extension { #name : #HtmlBRNode }

{ #category : #'*HTML-Formatters' }
HtmlBRNode >> addToFormatter: formatter [
	formatter addChar: Character cr.
]
