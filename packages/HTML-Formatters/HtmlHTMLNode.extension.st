Extension { #name : #HtmlHTMLNode }

{ #category : #'*HTML-Formatters' }
HtmlHTMLNode >> addToHtmlMorph: aHtmlBlockMorph [
	self renderChildrenInto: aHtmlBlockMorph
]
