accessing
prefix

	| in theEnd |

	in := ReadStream on: self content.
	in position: (self start ifNil: [0]).	
	theEnd := self children isEmpty ifTrue:[self end] ifFalse:[self children first start].

	^in next: ((theEnd ifNil: [0]) - (self start ifNil: [0]))