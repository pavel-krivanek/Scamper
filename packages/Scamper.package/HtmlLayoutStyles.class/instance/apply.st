applying styles
apply
	"modify the morph to fit to the styles. padding, borderwidth, bordercolor..."
	
	self height ifNotNil: [:h | self htmlMorph height: h].
	self width ifNotNil: [:w | self htmlMorph setWidth:w].
	
	