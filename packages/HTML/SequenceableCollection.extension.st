Extension { #name : #SequenceableCollection }

{ #category : #'*html' }
SequenceableCollection >> joinOn: aString [

	^ String streamContents:
		[:s |
		self do: [:ea | s nextPutAll: ea asString] separatedBy: [s nextPutAll: aString]]

]
