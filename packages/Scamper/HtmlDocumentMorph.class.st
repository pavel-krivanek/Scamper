Class {
	#name : #HtmlDocumentMorph,
	#superclass : #HtmlBlockMorph,
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #'instance creation' }
HtmlDocumentMorph class >> newFor: aHtmlDocument [
	^self new
			renderDocument: aHtmlDocument;
			yourself
]

{ #category : #rendering }
HtmlDocumentMorph >> clear [
	self removeAllMorphs.
]

{ #category : #accessing }
HtmlDocumentMorph >> document [

	^ self node
]

{ #category : #accessing }
HtmlDocumentMorph >> document: aHtmlDocument [

	self node: aHtmlDocument
]

{ #category : #rendering }
HtmlDocumentMorph >> render [
	self document addToHtmlMorph: self.
]

{ #category : #rendering }
HtmlDocumentMorph >> renderDocument: aHtmlDocument [
	self clear.
	self document: aHtmlDocument.
	self render
]

{ #category : #rendering }
HtmlDocumentMorph >> setMinimumHeight: aHeight [
	
	| bodyMorph |
	bodyMorph := self submorphs detect: [:m | m isHtmlBodyMorph ] ifNone: [ nil ].
	bodyMorph ifNotNil: [ :m | m minimumHeight: aHeight ]
]
