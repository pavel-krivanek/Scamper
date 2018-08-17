Extension { #name : #HtmlFORMNode }

{ #category : #'*HTML-Formatters' }
HtmlFORMNode >> addToHtmlMorph: aHtmlBlockMorph [
	super addToHtmlMorph: aHtmlBlockMorph.
	
	associatedForm morph: htmlMorph.
	associatedForm reset
]
