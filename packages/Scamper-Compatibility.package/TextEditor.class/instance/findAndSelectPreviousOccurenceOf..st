find-select
findAndSelectPreviousOccurenceOf: aRegex

	| where |

	where := self findPrevious: aRegex startingAt: self startIndex.
	where ifNotNil: [ self selectInterval: where ].
	( morph respondsTo: #editView )
		ifTrue: [ morph editView selectionInterval: self selectionInterval ].
	^ where