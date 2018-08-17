Extension { #name : #SequenceableCollection }

{ #category : #'*HTML-Core' }
SequenceableCollection >> joinOn: aString [

	^ String streamContents:
		[:s |
		self do: [:ea | s nextPutAll: ea asString] separatedBy: [s nextPutAll: aString]]

]
