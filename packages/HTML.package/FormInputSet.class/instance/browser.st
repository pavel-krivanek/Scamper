accessing
browser
	"get the browser object TextURL-style"
	htmlMorph ifNotNil: [ 
		[ htmlMorph ~= nil ] whileTrue: [
			(htmlMorph hasProperty: #webBrowserView) ifTrue: [ ^ htmlMorph model ].
		  htmlMorph := htmlMorph owner ]].
	^ nil
