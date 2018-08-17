Class {
	#name : #HtmlANode,
	#superclass : #HtmlDOMNode,
	#instVars : [
		'href'
	],
	#category : #'HTML-Core-DOM'
}

{ #category : #rendering }
HtmlANode >> endStyles: aFormatter [

	href ifNotNil: [:value | aFormatter endLink: value ]
]

{ #category : #accessing }
HtmlANode >> href [
	^ href ifNil: [ href := self attributes at: 'href' ifAbsent: [nil] ]
]

{ #category : #accessing }
HtmlANode >> startStyles: aFormatter [

	href := self attributes at: 'href' ifAbsent: [nil].	
	href ifNotNil: [:value | aFormatter startLink: value ]
]

{ #category : #accessing }
HtmlANode >> tag [
	^ 'a'
]

{ #category : #accessing }
HtmlANode >> target [
	^ self attributes at: 'target' ifAbsent: [nil]
]
