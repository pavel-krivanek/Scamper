window definition
buttonRowPane
	"Create and return a pane of navigation buttons."

	| buttonRow |
	
	buttonRow := (AlignmentMorph new)
				borderWidth: 0;
				layoutInset: 0;
				color:(Color transparent );
				hResizing: #spaceFill;
				wrapCentering: #center;
				cellPositioning: #leftCenter;
				clipSubmorphs: true;
				addTransparentSpacerOfSize: 5 @ 0.
	buttonRow
		addMorphBack: (self 
					simpleButtonNamed: 'History' translated
					action: #visitHistoryPage
					text: self historyButtonText);
		addTransparentSpacerOfSize: 5 @ 0;
		addMorphBack: (self 
					simpleButtonNamed: 'Bookmark' translated
					action: #visitBookmarksPage
					text: self bookmarkButtonText);
		addTransparentSpacerOfSize: 5 @ 0;
		addMorphBack: (self 
					simpleIconicButtonNamed: 'Stop'
					action: #stopEverything
					withIcon:  ((ImageReadWriter formFromFileNamed:  (self iconCancel asFileReference))));
		addTransparentSpacerOfSize: 5 @ 0;
		addMorphBack: (self 
					simpleButtonNamed: 'Stop!' translated
					action: #stopEverything
					text: self stopButtonText);
		addTransparentSpacerOfSize: 5@0;
		addMorphBack: (self
					simpleButtonNamed: 'Source'
					action: #viewSource
					text: 'View Source' ).
	^buttonRow
