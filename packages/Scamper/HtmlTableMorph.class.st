Class {
	#name : #HtmlTableMorph,
	#superclass : #HtmlBlockMorph,
	#instVars : [
		'layoutFinished'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #accessing }
HtmlTableMorph >> addChild: aHtmlTableRowMorph [
	| count |
	self layoutPolicy rows addLast: (HtmlGridSpace new breadth: 10; min: 1; max: 9999).
	count := 0.
	aHtmlTableRowMorph children do: [ :ea | count := count + 1.
		self
			ensureColumns: count;
			ensureWidth: ea width + 5 ofColumn: count;
			ensureHeight: ea height ofRow: self layoutPolicy rows size; 
			addMorphBack: (ea
				hResizing: #spaceFill;
				setProperty: #gridPosition toValue:
					(HtmlGridPosition new
						column: count;
						row: self layoutPolicy rows size)
			).
		self children addLast: ea.
	].
]

{ #category : #layout }
HtmlTableMorph >> addHorizontalTableLines [
	self layoutPolicy rows do: [ :ea |
		self addLineFrom: 0@(ea position) to: (self width)@(ea position).].
	self addLineFrom: 0@(self height) to: (self width)@(self height).
]

{ #category : #layout }
HtmlTableMorph >> addLineFrom: aPosition to: anotherPosition [
	self addMorph: (LineMorph
			from: aPosition
			to: anotherPosition
			color: Color black
			width: 1).
]

{ #category : #layout }
HtmlTableMorph >> addTableLines [
	layoutFinished := true.
	self
		addHorizontalTableLines;
		addVerticalTableLines.
]

{ #category : #layout }
HtmlTableMorph >> addVerticalTableLines [
	self layoutPolicy columns do: [ :ea |
		self addLineFrom: (ea position)@0 to: (ea position)@(self height).].
	self addLineFrom: (self width)@0 to: (self width)@(self height).
]

{ #category : #accessing }
HtmlTableMorph >> computedWidth: aWidth [

	computedWidth := aWidth.
	self width: aWidth
]

{ #category : #layout }
HtmlTableMorph >> ensureColumns: columnCount [
	(columnCount - self layoutPolicy columns size) timesRepeat: [ | aGridSpace |
		aGridSpace := HtmlGridSpace new
			breadth: 10;
			min: 0;
			max: 9999.
		self layoutPolicy columns addLast: aGridSpace.]
]

{ #category : #layout }
HtmlTableMorph >> ensureHeight: aHeight ofRow: aNumber [
	| aRow |
	aRow := self layoutPolicy rows at: aNumber.
	(aRow min < aHeight) ifTrue: [
			aRow
				min: aHeight;
				breadth: aHeight
			].
]

{ #category : #layout }
HtmlTableMorph >> ensureWidth: aWidth ofColumn: aNumber [
	| aColumn |
	aColumn := self layoutPolicy columns at: aNumber.
	(aColumn min < aWidth) ifTrue: [
			aColumn
				min: aWidth;
				breadth: aWidth
			].
]

{ #category : #initialization }
HtmlTableMorph >> initialize [
	layoutFinished := false.
	super initialize.
	self layoutPolicy: HtmlGridLayout new.

]

{ #category : #layout }
HtmlTableMorph >> layoutChanged [
	"Only redraw when layouting isn't finished yet"
	layoutFinished ifFalse: [^super layoutChanged]
]

{ #category : #layout }
HtmlTableMorph >> updateSubmorphWidth: aWidth [
	self submorphs select: [ :morph | morph isHtmlBlockMorph ] thenDo: [ :morph |
		| position |
		position := morph valueOfProperty: #gridPosition.
		position ifNotNil: [ :pos | morph setWidth:
								(self layoutPolicy columns at: position column) breadth ]]
]
