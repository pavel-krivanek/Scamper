Extension { #name : #HtmlTHEADNode }

{ #category : #'*HTML-Formatters' }
HtmlTHEADNode >> addToHtmlMorph: aHtmlTableMorph [
	self children do: [ :ea |
		ea addToHtmlMorph: aHtmlTableMorph.
	]
]
