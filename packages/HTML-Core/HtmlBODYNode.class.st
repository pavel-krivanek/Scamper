Class {
	#name : #HtmlBODYNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #'initialize-release' }
HtmlBODYNode >> defaultBlockMorph [
	^ HtmlBodyMorph
]

{ #category : #accessing }
HtmlBODYNode >> tag [
	^ 'body'
]
