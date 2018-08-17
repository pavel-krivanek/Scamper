Extension { #name : #PositionableStream }

{ #category : #'*Scamper-Compatibility' }
PositionableStream >> last [
	"Return the element that was read last"

	^ collection at: position
]

{ #category : #'*Scamper-Compatibility' }
PositionableStream >> unCommand [
	"If this read stream is at a <, then skip up to just after the next >.  For removing html commands."
	| char |
	[self peek = $<] whileTrue: ["begin a block"
		[self atEnd == false and: [self next ~= $>]] whileTrue.
		"absorb characters"
		].
 
]
