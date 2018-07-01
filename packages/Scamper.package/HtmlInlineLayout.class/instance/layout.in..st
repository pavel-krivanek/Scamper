as yet unclassified
layout: aMorph in: newBounds

	(self textAlign = #centered) ifTrue: [ aMorph editor applyAttribute: (TextAlignment centered). ].
	(self textAlign = #left) ifTrue: [ aMorph editor applyAttribute: (TextAlignment leftFlush). ].
	(self textAlign = #right) ifTrue: [ aMorph editor applyAttribute: (TextAlignment leftFlush). ].