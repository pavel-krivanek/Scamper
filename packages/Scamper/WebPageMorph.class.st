Class {
	#name : #WebPageMorph,
	#superclass : #ScrollPane,
	#instVars : [
		'scamper',
		'document',
		'documentMorph'
	],
	#category : 'Scamper-Core'
}

{ #category : #'instance creation' }
WebPageMorph class >> on: aScamper [
	^self new
			model: aScamper;
			scamper: aScamper;
			yourself
]

{ #category : #accessing }
WebPageMorph >> document [

	^ document
]

{ #category : #accessing }
WebPageMorph >> document: aHtmlDocument [

	document := aHtmlDocument
]

{ #category : #accessing }
WebPageMorph >> documentMorph [

	^ documentMorph
]

{ #category : #accessing }
WebPageMorph >> documentMorph: aHtmlDocumentMorph [
	self scroller removeAllMorphs.
	documentMorph := aHtmlDocumentMorph.
	self scroller addMorph: documentMorph.
]

{ #category : #layout }
WebPageMorph >> extent: newExtent [
	super extent: newExtent.
	"Bug: Because the document is always sized to both-scrollbars-hidden-bounds"
	"there will always be scrollbars in both directions, even if only one is needed"
	self hideScrollBarsIndefinitely;
		 updateDocumentSize;
		 hideScrollBarsIndefinitely: false
]

{ #category : #geometry }
WebPageMorph >> getNorthEastCornerPosition [

	^self fullBounds.
]

{ #category : #geometry }
WebPageMorph >> hExtraScrollRange [
	"Don't know what this was originally for - prevents unneeded scrollbars from disappearing"
	^ 0
]

{ #category : #layout }
WebPageMorph >> hMargin [
	^0
]

{ #category : #initialization }
WebPageMorph >> initialize [
	super initialize.
	getMenuSelector := #menu:shifted:.
]

{ #category : #layout }
WebPageMorph >> layoutChanged [
	"compute new bounds"
	
	self changed.
	super layoutChanged.
	self changed
]

{ #category : #layout }
WebPageMorph >> resetExtent [
	super resetExtent.
	"inspired by ScrollPane>>extent:"
	self resizeScrollBars; 
		hideOrShowScrollBars;
		vSetScrollDelta;
		hSetScrollDelta
]

{ #category : #accessing }
WebPageMorph >> scamper [

	^ scamper
]

{ #category : #accessing }
WebPageMorph >> scamper: anObject [

	scamper := anObject
]

{ #category : #'event handling' }
WebPageMorph >> scrollByKeyboard: event [ 
	"If event is up/down/left/right/pgup/pgdown then scroll and answer true"
	event keyCharacter = Character arrowUp
		ifTrue: 
			[scrollBar scrollUp: 3.
			^ true].
	event keyCharacter = Character arrowDown
		ifTrue: 
			[scrollBar scrollDown: 3.
			^ true].
	event keyCharacter = Character arrowRight
		ifTrue: 
			[hScrollBar scrollDown: 3.
			^ true].
	event keyCharacter = Character arrowLeft
		ifTrue: 
			[hScrollBar scrollUp: 3.
			^ true].
	event keyCharacter = Character pageDown
		ifTrue:
			[scrollBar scrollDown: 15.
			^ true].
	event keyCharacter = Character pageUp
		ifTrue:
			[scrollBar scrollUp: 15.
			^ true].
	^ false
]

{ #category : #layout }
WebPageMorph >> show: aHtmlDocument [
	self document: aHtmlDocument;
		documentMorph: (HtmlDocumentMorph newFor: aHtmlDocument);
		startDownloadingMorphState: documentMorph incompleteMorphs.

	self layoutChanged;
		resetExtent;
		updateDocumentSize.

]

{ #category : #layout }
WebPageMorph >> showImagePage: aImageMorph [
	self document: #image;
		documentMorph: aImageMorph;
		layoutChanged;
		resetExtent;
		updateDocumentSize.
]

{ #category : #layout }
WebPageMorph >> startDownloadingMorphState: morphs [
	| count | 
	count := self scamper workerCount min: morphs size.
	count <= 0 ifTrue: [^self].
	1 to: count do: [:start |
		| worker |
		worker := ScamperWorker
			task: (morphs atAll: (start to: morphs size by: count))
			from: self scamper.
		worker start]


]

{ #category : #layout }
WebPageMorph >> updateDocumentSize [
	| documentWidth |	
	self document = #image ifFalse: [
		documentMorph ifNotNil: [ :dm |
			documentWidth := self documentMorph preferredMinimumWidth.
			(documentWidth == #auto)
				ifTrue: [ self documentMorph setWidth: self scroller width ]
				ifFalse: [ self documentMorph setWidth: (self scroller width min: documentWidth) ].
			documentMorph setMinimumHeight: (self scroller height)]. 
	].
]

{ #category : #geometry }
WebPageMorph >> vExtraScrollRange [
	"Don't know what this was originally for - prevents unneeded scrollbars from disappearing"
	^ 0
]
