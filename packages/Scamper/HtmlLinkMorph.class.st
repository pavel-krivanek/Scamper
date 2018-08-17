Class {
	#name : #HtmlLinkMorph,
	#superclass : #HtmlBlockMorph,
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #'event handling' }
HtmlLinkMorph >> handleMouseDown: anEvent [
	anEvent wasHandled: true.
	self mouseDown: anEvent
]

{ #category : #'event handling' }
HtmlLinkMorph >> handleMouseMove: anEvent [
	anEvent wasHandled: true.
	self mouseMove: anEvent
]

{ #category : #'event handling' }
HtmlLinkMorph >> handlesMouseDown: evt [
	^ true
]

{ #category : #'event handling' }
HtmlLinkMorph >> handlesMouseOver: evt [
	^ true
]

{ #category : #'event handling' }
HtmlLinkMorph >> mouseDown: evt [
	self node href ifNotNil: [:target | (TextURL new url: target) actOnClickFor: self ].
	Cursor currentCursor == Cursor webLink ifTrue: [Cursor normal show]
]

{ #category : #'event handling' }
HtmlLinkMorph >> mouseLeave: evt [
	Cursor normal show
]

{ #category : #'event handling' }
HtmlLinkMorph >> mouseMove: evt [
	Cursor webLink show
]
