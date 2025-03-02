menu messages
findAgainAndReplace

	"Find the text-to-find again and eventually replace it with the current replace text."

	| where |

	where := self findAgain.
	where
		ifNotNil: [ self findReplaceService replaceText ifNotEmpty: [ :rt | self replaceSelectionWith: rt ] ]