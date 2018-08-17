Class {
	#name : #ScamperButton,
	#superclass : #IconicButton,
	#instVars : [
		'labelGraphic',
		'labelInfo'
	],
	#category : 'Scamper-Core'
}

{ #category : #'as yet unclassified' }
ScamperButton >> changeBetweenReloadAndStopWithState: aState [

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
]

{ #category : #'as yet unclassified' }
ScamperButton >> iconCancel [
	
	^ ('Scamper/build-support/scamper-icons/png/cancel-w24-h24.png').
]

{ #category : #'as yet unclassified' }
ScamperButton >> iconRefresh [
	
	^ Scamper iconsReference / 'reload-w24-h24.png'.
]

{ #category : #'as yet unclassified' }
ScamperButton >> initialize [

	super initialize.
	IconicButton new
		target: self;
		color: (Color transparent);
		extent: 35@35;
		borderWidth: 0;
		borderColor: (Color transparent);
		actWhen: #buttonUp.		

		
		super color: (Color transparent).
		super borderWidth: 0.
		super borderColor: (Color transparent).
		super actWhen: #buttonUp.
]

{ #category : #'as yet unclassified' }
ScamperButton >> labelGraphic [
	
	^ labelGraphic.  
]

{ #category : #'as yet unclassified' }
ScamperButton >> labelGraphic: aForm [

	super labelGraphic: aForm.
]

{ #category : #'as yet unclassified' }
ScamperButton >> labelInfo [
	
	^ labelInfo.  
]

{ #category : #'as yet unclassified' }
ScamperButton >> labelInfo: aString [

	labelInfo := aString.
]

{ #category : #'as yet unclassified' }
ScamperButton >> on: anObject action: anAction Icon: anIcon labelInfo: aString [ 

	^self
		actionSelector: anAction;
		labelGraphic: anIcon;
		labelInfo: aString. 
]

{ #category : #'as yet unclassified' }
ScamperButton >> selfChangeAction: anAction Icon: anIcon labelInfo: aString [ 

	self
		actionSelector: anAction;
		labelGraphic: anIcon;
		labelInfo: aString.
		
	super labelGraphic: anIcon.
	super actionSelector: anAction. 
]
