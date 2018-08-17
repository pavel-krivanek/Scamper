Class {
	#name : #PluggableTextMorphSubmitOnEnter,
	#superclass : #PluggableTextMorph,
	#instVars : [
		'nodes',
		'incompleteMorphs',
		'acceptTarget'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #'instance creation' }
PluggableTextMorphSubmitOnEnter class >> on: stringModel text: getTextSel accept: setTextSel acceptTarget: acceptObject acceptAction: aSymbol [

	| plugTextMorph |
	plugTextMorph := self on: stringModel text: getTextSel accept: setTextSel.
	plugTextMorph acceptTarget: acceptObject.
	plugTextMorph acceptAction: aSymbol.
	^plugTextMorph
	
	

]

{ #category : #actions }
PluggableTextMorphSubmitOnEnter >> accept [
	super accept.
	self acceptTarget perform: acceptAction. 
		
]

{ #category : #accessing }
PluggableTextMorphSubmitOnEnter >> acceptAction [
	^ acceptAction
]

{ #category : #accessing }
PluggableTextMorphSubmitOnEnter >> acceptAction: anObject [
	acceptAction := anObject
]

{ #category : #accessing }
PluggableTextMorphSubmitOnEnter >> acceptTarget [
	^ acceptTarget
]

{ #category : #accessing }
PluggableTextMorphSubmitOnEnter >> acceptTarget: anObject [
	acceptTarget := anObject
]

{ #category : #initialization }
PluggableTextMorphSubmitOnEnter >> initialize [ 
	super initialize.
	self setText: ''. "compatability for squeak < 5.0"
	self acceptOnCR: true.
]
