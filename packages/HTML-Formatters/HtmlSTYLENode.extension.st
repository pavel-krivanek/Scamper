Extension { #name : #HtmlSTYLENode }

{ #category : #'*HTML-Formatters' }
HtmlSTYLENode >> addToHtmlMorph: aHtmlBlockMorph [	
	
	"preliminary fix. Sytle nodes should not render children. Are css sheets still used?"
	^aHtmlBlockMorph

]
