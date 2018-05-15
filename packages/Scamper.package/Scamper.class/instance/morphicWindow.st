window definition
morphicWindow
	"Create and return a Morphic window for Scamper."
	| window |
	
	window := (SystemWindow labelled: 'Scamper')
		model: self;
		width: 800;
		height: 600;
		setProperty: #webBrowserView toValue: true;
		"URL edit pane and buttons"
		addMorph: self urlEditPane fullFrame: ((LayoutFrame identity bottomFraction: 0; bottomOffset: 60));		
		addMorph: self tabPane fullFrame: ((LayoutFrame identity bottomFraction: 0; topOffset: 60; bottomOffset: 100));
		"The web page pane"
		addMorph: self webContentsPane fullFrame: ((LayoutFrame identity topOffset: 100; bottomOffset: -20));	 
		"Status pane"	
		addMorph: self statusPane fullFrame: ((LayoutFrame identity topFraction: 1; topOffset: -20)).		
	
	self initializeTabs.
	
	window openInWorld.
	
	^ window.
		
	

