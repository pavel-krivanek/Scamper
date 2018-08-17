Class {
	#name : #HtmlTITLENode,
	#superclass : #HtmlDOMNode,
	#category : 'HTML-DOM'
}

{ #category : #accessing }
HtmlTITLENode >> innerContents [

	^self rawContent
]

{ #category : #accessing }
HtmlTITLENode >> tag [
	^ 'title'
]
