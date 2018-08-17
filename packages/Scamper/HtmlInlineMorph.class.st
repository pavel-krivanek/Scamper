Class {
	#name : #HtmlInlineMorph,
	#superclass : #TextMorph,
	#instVars : [
		'nodes',
		'incompleteMorphs',
		'layoutStyles'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #accessing }
HtmlInlineMorph >> children [
	^OrderedCollection new
]

{ #category : #geometry }
HtmlInlineMorph >> extent: aPoint [
	self wrapFlag: true.
	super extent: aPoint
]

{ #category : #accessing }
HtmlInlineMorph >> handleInteraction: interactionBlock fromEvent: evt [
	"Perform the changes in interactionBlock, noting any change in selection
	and possibly a change in the size of the paragraph (ar 9/22/2001 - added for TextPrintIts)"
	| oldEditor oldParagraph oldText |
	oldEditor := nil.
	oldParagraph := paragraph.
	oldText := oldParagraph text copy.

	"self selectionChanged."  "Note old selection"

		interactionBlock value.

	"(oldParagraph == paragraph) ifTrue:[
		""this will not work if the paragraph changed"
		"editor := oldEditor.     ""since it may have been changed while in block"
	"].
	self selectionChanged. 
	(oldText = paragraph text and: [ oldText runs = paragraph text runs ])
		ifFalse:[ 
			self paragraph composeAll.
			self updateFromParagraph ].
	self setCompositionWindow."
]

{ #category : #accessing }
HtmlInlineMorph >> hasFocus [
	^editor notNil.
]

{ #category : #accessing }
HtmlInlineMorph >> incompleteMorphs [

	^ incompleteMorphs
]

{ #category : #accessing }
HtmlInlineMorph >> incompleteMorphs: anObject [

	incompleteMorphs := anObject
]

{ #category : #initialization }
HtmlInlineMorph >> initialize [
	super initialize.
	self nodes: OrderedCollection new.
	self layoutStyles: (HtmlLayoutStyles newFor: self).
	self layoutPolicy: HtmlInlineLayout new.
]

{ #category : #testing }
HtmlInlineMorph >> isHtmlBodyMorph [
	^ false
]

{ #category : #accessing }
HtmlInlineMorph >> keyboardFocusChange: aBoolean [ 
	| w |
	paragraph isNil ifFalse:[paragraph focused: aBoolean].
	aBoolean ifTrue:["A hand is wanting to send us characters..."
			self hasFocus ifFalse: [self editor	"Forces install"].
			"Editor blinkingCursor ifTrue: [ self startBlinking ]."
	] ifFalse:["A hand has clicked elsewhere..."
		(w := self world) ifNotNil:[
			w handsDo: [:h | h keyboardFocus == self ifTrue: [^self]].
			"Release control unless some hand is still holding on"
			self releaseEditor].
		"self stopBlinking."
	].

]

{ #category : #accessing }
HtmlInlineMorph >> layoutStyles [
	^ layoutStyles
]

{ #category : #accessing }
HtmlInlineMorph >> layoutStyles: anObject [
	layoutStyles := anObject
]

{ #category : #accessing }
HtmlInlineMorph >> mouseDown: evt [ 
	"Make this TextMorph be the keyboard input focus, if it isn't  
	already, and repond to the text selection gesture."
	"evt yellowButtonPressed
		ifTrue: [
			^ self yellowButtonActivity: evt shiftPressed]."
	evt hand newKeyboardFocus: self.
	self
		handleInteraction: [editor mouseDown: evt]
		fromEvent: evt.

]

{ #category : #accessing }
HtmlInlineMorph >> mouseUp: evt [

	self handleInteraction: [editor mouseUp: evt] fromEvent: evt
]

{ #category : #accessing }
HtmlInlineMorph >> nodes [

	^ nodes
]

{ #category : #accessing }
HtmlInlineMorph >> nodes: anObject [

	nodes := anObject
]

{ #category : #layout }
HtmlInlineMorph >> preferredMinimumWidth [

	^ #auto
]

{ #category : #layout }
HtmlInlineMorph >> setWidth: availableWidth [

	self width: availableWidth
]
