Extension { #name : #HtmlTFOOTNode }

{ #category : #'*HTML-Formatters' }
HtmlTFOOTNode >> addToHtmlMorph: aHtmlTableMorph [
	self children do: [ :ea |
		ea addToHtmlMorph: aHtmlTableMorph.
	]
]
