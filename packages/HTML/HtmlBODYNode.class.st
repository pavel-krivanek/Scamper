Class {
	#name : #HtmlBODYNode,
	#superclass : #HtmlDOMNode,
	#category : 'HTML-DOM'
}

{ #category : #'initialize-release' }
HtmlBODYNode >> defaultBlockMorph [
	^ HtmlBodyMorph
]

{ #category : #accessing }
HtmlBODYNode >> tag [
	^ 'body'
]
