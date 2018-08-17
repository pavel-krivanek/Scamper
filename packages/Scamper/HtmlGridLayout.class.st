Class {
	#name : #HtmlGridLayout,
	#superclass : #HtmlLayoutPolicy,
	#instVars : [
		'columns',
		'rows'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #accessing }
HtmlGridLayout >> columns [

	^ columns
]

{ #category : #accessing }
HtmlGridLayout >> columns: anObject [

	columns := anObject.
	self recomputeRatios: columns.
]

{ #category : #layout }
HtmlGridLayout >> computeSpacePositions: aSpaceCollection in: newBreadth [

	|  pos |
	
	"Compute the new positions"
	pos := 0.
	aSpaceCollection do: [ :ea | | b |
		b := (newBreadth * (ea ratio)) asInteger.
		b < ea min ifTrue: [ b := ea min ].
		b > ea max ifTrue: [ b := ea max ].
		ea position: pos ; breadth: b.
		pos := pos + b.
	].
	^ pos
]

{ #category : #'initialize-release' }
HtmlGridLayout >> initialize [
	super initialize.
	columns := OrderedCollection new.
	rows := OrderedCollection new.

]

{ #category : #layout }
HtmlGridLayout >> layout: aMorph in: newBounds [
	"Compute the layout for the given morph based on the new bounds"
	|  origin x y w h |
	aMorph hasSubmorphs ifFalse: [^self].
	self
		recomputeRatios: columns;
		recomputeRatios: rows.
	origin := newBounds origin asIntegerPoint.
	
	self layoutSpace: columns in: newBounds width.
	self layoutSpace: rows in: newBounds height.

	aMorph submorphs do: [ :morph | | gridPosition |
		gridPosition := morph valueOfProperty: #gridPosition.
		gridPosition notNil ifTrue: [ | column morphBounds row |
			column := columns at: gridPosition column.
			row := rows at: gridPosition row.
			x := column position.
			y := row position.
			w := column breadth.
			h := row breadth.
			morphBounds := (origin + (x@y)) corner: (origin + (x@y) + (w@h)).
			morph layoutInBounds: morphBounds.
		]
	].

]

{ #category : #layout }
HtmlGridLayout >> layoutSpace: aSpaceCollection in: newBreadth [
	|pos|
	
	pos := self computeSpacePositions: aSpaceCollection in: newBreadth.
	
	"If still space left, iterate until done or no more resizable columns"
	pos < newBreadth ifTrue: [ | n |
		[ n := (aSpaceCollection select: [ :ea | ea breadth < ea max ]) size.
		 (pos < newBreadth) and: [n > 0]] whileTrue: [ | bsup |
			bsup := ((newBreadth - pos ) / n) asInteger.
			bsup <= 0 ifTrue: [ bsup := 1 ].
			pos := 0.
			aSpaceCollection do: [ :ea | | b |
				b := ea breadth.
				((pos + b < newBreadth) and: [ b < ea max ]) ifTrue: [
					b := b + bsup.
					b > ea max ifTrue: [ b := ea max ].					
				].
				ea position: pos; breadth: b.
				pos := pos + b.
			].
		].
	].


]

{ #category : #layout }
HtmlGridLayout >> recomputeRatios: aGridSpaceCollection [
	"Recompute ratios based on initial breadth"
	| pos totalBreadth |
	totalBreadth := self totalBreadth: aGridSpaceCollection.
	pos := 0.
	aGridSpaceCollection do: [ :ea | 
		ea start: (pos = 0 ifTrue: [ 0 ] ifFalse: [ 1 / (totalBreadth / pos) ]).
		ea ratio: (1 / (totalBreadth / ea breadth)).
		pos := pos + ea breadth.
	].
	^ pos

]

{ #category : #accessing }
HtmlGridLayout >> rows [

	^ rows
]

{ #category : #accessing }
HtmlGridLayout >> rows: anObject [

	rows := anObject.
	self recomputeRatios: rows.
]

{ #category : #accessing }
HtmlGridLayout >> totalBreadth: aGridSpaceCollection [
	^ (aGridSpaceCollection collect: [:ea | ea breadth]) sum
]
