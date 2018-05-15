window definition
urlEditPane
	"Create and return the URL edit pane."

	| pane paneUI paneURL |
	pane := AlignmentMorph new color: (Color r:1 g:1 b:1).
				
	paneURL := (PluggableTextMorph on: self text: #currentUrl accept: #jumpToAbsoluteUrlAsync:).
				
	paneUI := (AlignmentMorph new)
				color: (Color r:0.1 g:1 b:1).
				
	reloadAndStopButton := (ScamperButton new)
								selfChangeAction: #reload 
								Icon: (ImageReadWriter formFromFileNamed: self iconRefresh asFileReference)
								labelInfo: #status.
		
	pane 	
		addMorph: paneURL fullFrame: LayoutFrame identity;

		addMorph: (self 
					simpleIconicButtonNamed: 'Home' translated
					action: #visitStartPage
					withIcon:  (ImageReadWriter formFromFileNamed: self iconHome asFileReference));
		addTransparentSpacerOfSize: 5 @ 0;
		addMorph: (self 
					simpleIconicButtonNamed: 'Forward' translated 
					action: #forward
					withIcon:  (ImageReadWriter formFromFileNamed: self iconForward asFileReference));
		addTransparentSpacerOfSize: 5 @ 0;
		addMorph: (self 
					simpleIconicButtonNamed: 'Back' translated 
					action: #back
					withIcon: (ImageReadWriter formFromFileNamed: self iconBackward asFileReference));
		addTransparentSpacerOfSize: 5 @ 0;
		
		addMorphBack: reloadAndStopButton;
		addTransparentSpacerOfSize: 5 @ 0;
		addMorphBack: (self 
					simpleIconicButtonNamed: 'Options' translated 
					action: #switchOptionsPanel 
					withIcon:  (ImageReadWriter formFromFileNamed: self iconOptions asFileReference)).
					
	paneURL acceptOnCR: true.
"	paneURL hideScrollBarsIndefinitely.
"	
	^ pane. 
		