Class {
	#name : #HtmlBodyMorph,
	#superclass : #HtmlBlockMorph,
	#instVars : [
		'minimumHeight'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #accessing }
HtmlBodyMorph >> computedSize [

	^ self computedWidth @ (self cssHeight max: self minimumHeight)
]

{ #category : #testing }
HtmlBodyMorph >> isHtmlBodyMorph [
	^ true
]

{ #category : #accessing }
HtmlBodyMorph >> minimumHeight [

	^ minimumHeight ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlBodyMorph >> minimumHeight: aHeight [
	
	minimumHeight := aHeight.
	self layoutChanged
]
