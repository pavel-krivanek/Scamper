Class {
	#name : #UpdatingThreePhaseButtonMorph,
	#superclass : #ThreePhaseButtonMorph,
	#instVars : [
		'getSelector',
		'getArgument'
	],
	#category : 'Scamper-Compatibility'
}

{ #category : #button }
UpdatingThreePhaseButtonMorph >> doButtonAction [
	"Since the action likely changes our state, do a step so we're updated immediately"
	super doButtonAction.
	self step

]

{ #category : #'as yet unclassified' }
UpdatingThreePhaseButtonMorph >> getSelector: sel [
	getSelector := sel
]

{ #category : #'event handling' }
UpdatingThreePhaseButtonMorph >> mouseUp: evt [
	"Since mouseUp likely changes our state, do a step so we're updated immediately"
	super mouseUp: evt.
	self step
]

{ #category : #'stepping and presenter' }
UpdatingThreePhaseButtonMorph >> step [
	| newBoolean |
	super step.
	state == #pressed ifTrue: [^ self].
	newBoolean := target perform: getSelector.
	newBoolean == self isOn
		ifFalse:
			[self state: (newBoolean == true ifTrue: [#on] ifFalse: [#off])]
]

{ #category : #testing }
UpdatingThreePhaseButtonMorph >> wantsSteps [
	^ true
]
