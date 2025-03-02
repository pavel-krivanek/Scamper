drawing
drawOn: aCanvas
	"Indicate unaccepted edits, conflicts etc."

	super drawOn: aCanvas. 
	self wantsFrameAdornments ifTrue: [
		self theme drawTextAdornmentFor: self color: Color orange on: aCanvas].
	self drawHighlightsOn: aCanvas