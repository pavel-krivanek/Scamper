as yet unclassified
changeBetweenReloadAndStopWithState: aState

	| browserState |
	
	browserState := aState asString.

	(browserState = 'done.' | browserState = 'sittin')
		ifTrue: [
				^ self 
					selfChangeAction: #reload 
					Icon: (ImageReadWriter formFromFileNamed: self iconRefresh asFileReference)
					labelInfo: 'Reload'
				].
			
	(browserState match: 'downloading')
		ifTrue: [
				^ self 
					selfChangeAction: #stopEverything  
					Icon: ((ImageReadWriter formFromFileNamed: self iconCancel asFileReference)) 
					labelInfo: 'Cancel'
				].
			
	(browserState = 'parsing')
		ifTrue: [
				^ self 
					selfChangeAction: #stopEverything  
					Icon: ((ImageReadWriter formFromFileNamed: self iconCancel asFileReference)) 
					labelInfo: 'Cancel'
				].