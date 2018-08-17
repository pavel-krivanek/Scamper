Extension { #name : #HtmlTBODYNode }

{ #category : #'*HTML-Formatters' }
HtmlTBODYNode >> addToHtmlMorph: aHtmlTableMorph [
	self children do: [ :ea |
		ea addToHtmlMorph: aHtmlTableMorph.
	]
]
