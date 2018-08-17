Class {
	#name : #HtmlBlockLayout,
	#superclass : #HtmlLayoutPolicy,
	#instVars : [
		'textAlign',
		'margin',
		'padding',
		'float'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #layout }
HtmlBlockLayout >> layout: aMorph in: newBounds [

	| currentY contentOrigin |
	aMorph hasSubmorphs ifFalse: [^self].
	
	contentOrigin := newBounds origin asIntegerPoint + aMorph layoutStyles contentOffset.
	currentY := 0.
	aMorph submorphs do: [ :morph |
		| morphBounds newTopLeft |
		newTopLeft := (contentOrigin + (0@currentY) + morph layoutStyles marginLeftTopAsPoint).
		morphBounds := newTopLeft corner: newBounds corner.
		morph layoutInBounds: morphBounds.
		currentY := currentY + morph height +morph layoutStyles extraMarginHeight].
]

{ #category : #layout }
HtmlBlockLayout >> minExtentOf: aHtmlMorph in: newBounds [
	"Return the minimal size aMorph's children would require given the new bounds"
	| min |
	min := 0@0.
	aHtmlMorph submorphsDo:[:m| | extent |
		
		extent := m minExtent.
		extent:= extent + (m layoutStyles extraMarginWidth @ m layoutStyles extraMarginHeight).
		min := min max: extent].
	^min
]
