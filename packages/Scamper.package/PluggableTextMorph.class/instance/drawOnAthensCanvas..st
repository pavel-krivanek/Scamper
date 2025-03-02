drawing
drawOnAthensCanvas: anAthensCanvas
	"Indicate unaccepted edits, conflicts etc."

	super drawOnAthensCanvas: anAthensCanvas. 
	self wantsFrameAdornments ifTrue: [
		self theme drawTextAdornmentFor: self color: Color orange on: anAthensCanvas asCanvasWrapper].
	self drawHighlightsOn: anAthensCanvas asCanvasWrapper