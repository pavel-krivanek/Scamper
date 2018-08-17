Class {
	#name : #HtmlBlockMorph,
	#superclass : #HtmlMorph,
	#instVars : [
		'node',
		'children',
		'backgroundImage',
		'processedBackgroundImage',
		'computedWidth',
		'suppressLayoutUpdates'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #'instance creation' }
HtmlBlockMorph class >> newFor: aHtmlNode [
	^self new 
			node: aHtmlNode;
			yourself
]

{ #category : #accessing }
HtmlBlockMorph >> addChild: aHtmlMorph [
	self addMorphBack: aHtmlMorph.
	self children addLast: aHtmlMorph
]

{ #category : #layout }
HtmlBlockMorph >> adjustBoundsToSubmorphs [
"My bounds should always enclose the submorph's bounds
(that's actually not 100% correct, e.g. take the case of 
<div style='width:100px'><div style='width:200px'></div></div>).
If I don't have submorphs (e.g. I'm just background-image'd), take
my computedSize and the given position
Otherwise take the submorphBounds and make sure they
have at least an extent of computedSize (the resulting bounds
may reside completely in the negative space because of
TextMorph's submorph placement - see BitBltDisplayScanner).
However it's important to set a correct width as it is used
for table column breadth ratio calulation"
	| submorphCorner delta |
	submorphCorner := self submorphs 
		ifEmpty: [ self position + self computedSize ]
		ifNotEmpty: [ ((self submorphBounds origin extent: self computedSize)
						quickMerge: self submorphBounds) corner asIntegerPoint ].
	delta := submorphCorner - self bounds corner.
	(delta isZero)
		ifTrue: [ ^ false ]
		ifFalse: 
			[ self extent: submorphCorner - self position. 
			  ^true ]
]

{ #category : #accessing }
HtmlBlockMorph >> backgroundImage [

	^ backgroundImage
]

{ #category : #accessing }
HtmlBlockMorph >> backgroundImage: anObject [

	backgroundImage := anObject.
	self redraw
]

{ #category : #accessing }
HtmlBlockMorph >> children [

	^ children
]

{ #category : #accessing }
HtmlBlockMorph >> children: anObject [

	children := anObject
]

{ #category : #drawing }
HtmlBlockMorph >> clip: anImage withOrigin: aPoint [
	| width height targetRect origin |
	aPoint ifNil: [ origin := 0@0 ] ifNotNil: [ :value | origin := (0@0) - value ].
	width := (self width > anImage width) ifTrue: [ anImage width ] ifFalse: [ self width ].
	height := (self height > anImage height) ifTrue: [ anImage height ] ifFalse: [ self height ].
	targetRect := Rectangle origin: origin extent: ((width @ height) max: 0@0).
	
	^ anImage contentsOfArea: targetRect
]

{ #category : #accessing }
HtmlBlockMorph >> computedSize [

	^ self computedWidth @ self cssHeight
]

{ #category : #accessing }
HtmlBlockMorph >> computedWidth [
	
	^ computedWidth ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlBlockMorph >> computedWidth: aWidth [

	computedWidth := aWidth.
	self layoutChanged
]

{ #category : #layout }
HtmlBlockMorph >> cornerOf: aRectangle relativeTo: aPoint [
	| translation |
	translation := aPoint - aRectangle origin.
	^ aRectangle corner - translation
]

{ #category : #layout }
HtmlBlockMorph >> cssHeight [

	| resolver |
	self node ifNil: [ ^ 0 ].
	
	resolver := CSSStyleResolver for: node.
 	^ resolver ifStyleNotNil: #height do: [:value | value ] ifNil: [ 0 ]
]

{ #category : #initialization }
HtmlBlockMorph >> defaultBounds [
"answer the default bounds for the receiver"
	^ 0 @ 0 corner: self computedSize
]

{ #category : #accessing }
HtmlBlockMorph >> defaultColor [
	^Color transparent
]

{ #category : #drawing }
HtmlBlockMorph >> downloadBackgroundImageAsync: aUrl [
	| promise |
	promise := Promise new.
	[ [promise resolveWith: aUrl asZnUrl retrieveContents] ifError: [ :e | e logCr ] ]
		forkAt: Processor userBackgroundPriority.
	^ promise
]

{ #category : #drawing }
HtmlBlockMorph >> drawBackground: anImage withRepeat: repeat On: aCanvas [
	| fillBounds fillStyle |
	fillBounds := self bounds.
	fillStyle := BitmapFillStyle fromForm: anImage.
	fillStyle origin: fillBounds origin.
	
	(repeat == #repeatX or: [ repeat == #noRepeat])
		ifTrue: [ fillBounds := fillBounds withHeight: anImage height ].
	(repeat == #repeatY or: [ repeat == #noRepeat]) 
		ifTrue: [ fillBounds := fillBounds withWidth: anImage width ].
	
	aCanvas balloonFillRectangle: fillBounds fillStyle: fillStyle
]

{ #category : #drawing }
HtmlBlockMorph >> drawBackgroundColor: fillColor On: aCanvas [
	| fillStyle |			
	fillStyle := SolidFillStyle color: fillColor.
	aCanvas fillRectangle: self bounds fillStyle: fillStyle borderStyle: self borderStyle
]

{ #category : #drawing }
HtmlBlockMorph >> drawOn: aCanvas [
	| resolver |
	resolver := CSSStyleResolver for: self node.
	
	resolver ifStyleNotNil: #backgroundColor do: 
		 [ :fillColor |	self drawBackgroundColor: fillColor On: aCanvas ].
	
	self backgroundImage ifNotNil: [ :img |
		| repeat |
		repeat := (resolver getStyle: #backgroundRepeat) ifNil: [ #repeat ].
		self drawBackground: img withRepeat: repeat On: aCanvas ].
	
	self processedBackgroundImage ifFalse: [
		self processedBackgroundImage: true.
		self processBackgroundImage: (resolver getStyle: #backgroundImage)
			 at: (resolver getStyle: #backgroundPosition)].
		
	^ super drawOn: aCanvas
]

{ #category : #accessing }
HtmlBlockMorph >> incompleteMorphs [
	| incompleteMorphs |
	incompleteMorphs := OrderedCollection new.
	self children do: [:child | incompleteMorphs addAll: child incompleteMorphs ].
	^incompleteMorphs
]

{ #category : #initialization }
HtmlBlockMorph >> initialize [
	super initialize.
	children := OrderedCollection new.
	
	self processedBackgroundImage: false.
	self layoutPolicy: HtmlBlockLayout new;
		listDirection: #topToBottom;
		wrapDirection: #none;
		listCentering: #topLeft;
		wrapCentering: #topLeft;
		vResizing: #rigid;
		hResizing: #spaceFill;
		cellPositioning: #topLeft
]

{ #category : #testing }
HtmlBlockMorph >> isHtmlBlockMorph [
	^ true
]

{ #category : #testing }
HtmlBlockMorph >> isHtmlBodyMorph [
	^ false
]

{ #category : #layout }
HtmlBlockMorph >> layoutChanged [
	self suppressLayoutUpdates ifTrue: [ ^ self ].
	
	self adjustBoundsToSubmorphs
		ifFalse: [ self superLayoutChanged ]
]

{ #category : #accessing }
HtmlBlockMorph >> node [

	^ node
]

{ #category : #accessing }
HtmlBlockMorph >> node: anObject [

	node := anObject
]

{ #category : #layout }
HtmlBlockMorph >> preferredMinimumWidth [
	| resolver ownWidth childrenWidth |
	self node ifNil: [ ^ #auto ].
	
	resolver := CSSStyleResolver for: node.

	"TODO: add support for intrinsic widths of replaced elements here"
	"add margins and paddings and border-widths here"
	resolver ifStyleNotNil: #absoluteWidth
					do: [:value | ownWidth := value ] ifNil: [ ^ ownWidth := #auto ].

	childrenWidth := (self submorphs 
		collect: [ :morph | morph preferredMinimumWidth ]
		thenSelect: [ :width | width ~= #auto ])
		ifNotEmpty: [ :widths | widths max ] ifEmpty: [ #auto ].
		
	(ownWidth == #auto)
		ifTrue: [ ^ childrenWidth ]
		ifFalse: [ ^ ownWidth ]
]

{ #category : #drawing }
HtmlBlockMorph >> processBackgroundImage: aUrl at: aPosition [
	| absoluteUrl |
	aUrl ifNil: [ ^ self ].
	
	absoluteUrl := aUrl asUrl.
	(aUrl asString beginsWith: 'http') 
		ifFalse: [ absoluteUrl := aUrl asUrlRelativeTo: self node document url ].

	(self downloadBackgroundImageAsync: absoluteUrl)
		then: [ :document |
			| image |
			image := ImageReadWriter formFromStream: document contentStream binary.
			((self width < image width or: [ self height < image height ]) or: [ aPosition notNil ])
				ifTrue: [ self backgroundImage: (self clip: image withOrigin: aPosition) ]
				ifFalse: [ self backgroundImage: image ]].
]

{ #category : #accessing }
HtmlBlockMorph >> processedBackgroundImage [

	^ processedBackgroundImage
]

{ #category : #accessing }
HtmlBlockMorph >> processedBackgroundImage: anObject [

	processedBackgroundImage := anObject
]

{ #category : #layout }
HtmlBlockMorph >> setWidth: availableWidth [

	| resolver absoluteWidth relativeWidth resultWidth availableContentWidth contentWidth useableWidth |
	self node ifNil: [ ^ self ].
	
	resolver := CSSStyleResolver for: node.
	
	absoluteWidth := (resolver getStyle: #absoluteWidth) ifNil: [ #auto ].
	relativeWidth := (resolver getStyle: #relativeWidth) ifNil: [ 100 ].
	useableWidth  := availableWidth - self layoutStyles extraMarginWidth.
	(absoluteWidth == #auto) 
		ifTrue: [ 
			
			availableContentWidth := availableWidth - self layoutStyles extraWidth.
			contentWidth := availableContentWidth * relativeWidth / 100.
			resultWidth := useableWidth * relativeWidth / 100 ]
		ifFalse: [ 
			contentWidth := absoluteWidth.
			resultWidth := absoluteWidth+ self layoutStyles extraWidth].
	self computedWidth: resultWidth;
		suppressLayoutUpdates: true;
		updateSubmorphWidth: contentWidth;
		suppressLayoutUpdates: false;
		layoutChanged
]

{ #category : #layout }
HtmlBlockMorph >> superLayoutChanged [
	| layout |
	fullBounds ifNil:[^self]. "layout will be recomputed so don't bother"
	fullBounds := nil.
	layout := self layoutPolicy.
	layout ifNotNil:[layout flushLayoutCache].
	owner ifNotNil: [owner layoutChanged].
	"note: does not send #ownerChanged here - we'll do this when computing the new layout"
]

{ #category : #accessing }
HtmlBlockMorph >> suppressLayoutUpdates [

	^ suppressLayoutUpdates ifNil: [ false ]
]

{ #category : #accessing }
HtmlBlockMorph >> suppressLayoutUpdates: anObject [

	suppressLayoutUpdates := anObject
]

{ #category : #layout }
HtmlBlockMorph >> updateSubmorphWidth: aWidth [

	self submorphsDo: [:morph | morph setWidth: aWidth ]	
]
