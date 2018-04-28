menus
optionsPanelButtonPaneWithPosition: aPosition

	| pane |
	
	pane := (AlignmentMorph new)
				borderWidth: 1;
				borderColor: (Color lightGray);
				layoutInset: 5;
				position: aPosition;
				listDirection: #topToBottom;
				color: (Color white);
				wrapCentering: #center;
				cellPositioning: #center;
				clipSubmorphs: true;
				width: self optionsPanelWidth;
				height: self optionsPanelHeight.
	
	pane
		addMorph: (self simpleIconicButtonNamed: 'Bookmarks' translated
						action:  #visitBookmarksPage  
						withIcon: ((ImageReadWriter formFromFileNamed:  
							(self iconBookmark asFileReference))));
		addMorph: (self simpleIconicButtonNamed: 'Add Site as a Bookmark' translated 
						action: #addToBookmark   
						withIcon: ((ImageReadWriter formFromFileNamed:
						(self iconAddBookmark asFileReference))));
		addMorph: (self simpleIconicButtonNamed: 'History' translated 
						action: #visitHistoryPage  
						withIcon: ((ImageReadWriter formFromFileNamed:  
							(self iconHistory asFileReference)))).
				
	^ pane.
				
	
