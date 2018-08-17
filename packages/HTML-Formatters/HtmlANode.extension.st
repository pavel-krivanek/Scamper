Extension { #name : #HtmlANode }

{ #category : #'*HTML-Formatters' }
HtmlANode >> addToFormatter: aFormatter [
	"Currently not supported:"
	"name := self attributes at: 'name' ifAbsent: [nil].
	name ifNotNil: [
			aFormatter noteAnchorStart: name ]."
	super addToFormatter: aFormatter
]

{ #category : #'*HTML-Formatters' }
HtmlANode >> defaultBlockMorph [
	^ HtmlLinkMorph
]
