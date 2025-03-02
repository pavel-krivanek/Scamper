menu messages
findAgain

	"Find the text-to-find again."

	| where |

	where := self findReplaceService
		findNextSubstring: self findReplaceService findString
		inTextMorph: self morph.
	where ifNil: [ self flash ] ifNotNil: [ self selectInterval: where ].
	^ where