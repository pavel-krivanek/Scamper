Class {
	#name : #FormInputSetStub,
	#superclass : #FormInputSet,
	#instVars : [
		'called',
		'submittedCount'
	],
	#category : 'Scamper-Tests'
}

{ #category : #initialization }
FormInputSetStub >> initialize [ 
	super initialize.
	submittedCount := 0.
]

{ #category : #actions }
FormInputSetStub >> submitAsync [ 

	submittedCount := submittedCount + 1.
]

{ #category : #actions }
FormInputSetStub >> submittedCount [

	^submittedCount
]
