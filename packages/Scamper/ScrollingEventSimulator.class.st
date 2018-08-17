"
This class is used to simulate keyboard events, especially for scrolling keys
"
Class {
	#name : #ScrollingEventSimulator,
	#superclass : #KeyboardEvent,
	#instVars : [
		'keyString'
	],
	#category : 'Scamper-Tests'
}

{ #category : #accessing }
ScrollingEventSimulator >> keyCharacter [

	^ keyString
]

{ #category : #accessing }
ScrollingEventSimulator >> keyString [

	^ keyString
]

{ #category : #accessing }
ScrollingEventSimulator >> keyString: aString [

	keyString := aString
]
