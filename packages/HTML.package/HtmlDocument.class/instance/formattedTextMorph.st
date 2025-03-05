formatting
formattedTextMorph
	"return a version of this document as a formatted TextMorph (which includes links and such)"
	| formatter text textMorph |
	formatter := HtmlFormatter preferredFormatterClass new.
	self addToFormatter: formatter.
	text := formatter text .

	textMorph := ScamperTextMorph new initialize.
	textMorph contentsWrapped: text.

	^textMorph