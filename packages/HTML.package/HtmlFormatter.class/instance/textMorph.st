formatting
textMorph
	| text textMorph |
	text := outputStream contents.
	textMorph := ScamperTextMorph new contents: text.
	morphsToEmbed do:[ :m | textMorph addMorph: m ].
	^textMorph