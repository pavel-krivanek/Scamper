Extension { #name : #HtmlTABLENode }

{ #category : #'*HTML-Formatters' }
HtmlTABLENode >> addToHtmlMorph: aHtmlBlockMorph [	
	super addToHtmlMorph: aHtmlBlockMorph.
	((self attributes at: #border ifAbsent: ['0']) = '0') ifFalse: [htmlMorph addTableLines].
]

{ #category : #'*HTML-Formatters' }
HtmlTABLENode >> defaultBlockMorph [
	^ HtmlTableMorph
]
