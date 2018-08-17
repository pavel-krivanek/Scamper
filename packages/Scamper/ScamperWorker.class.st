"
I work in the background to help download the morphs that are not completed in a page such as images.

"
Class {
	#name : #ScamperWorker,
	#superclass : #Object,
	#instVars : [
		'items',
		'boss'
	],
	#category : 'Scamper-Core'
}

{ #category : #'intance creation' }
ScamperWorker class >> task: morphs from: aScamper [
	^self new setTask: morphs from: aScamper

]

{ #category : #private }
ScamperWorker >> setTask: morphs from: aScamper [
	items := morphs.
	boss := aScamper

]

{ #category : #work }
ScamperWorker >> start [
	[items do: [:m | m downloadStateIn: boss]] fork

]
