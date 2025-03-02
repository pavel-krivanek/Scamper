menu messages
saveContentsInFile
	"Save the receiver's contents string to a file, prompting the user for a file-name. Suggest a reasonable file-name."

	| fileName stringToSave labelToUse suggestedName lastIndex |
	stringToSave := self string.
	stringToSave ifEmpty: [ ^ self inform: 'nothing to save.' ].
	labelToUse :=  model dependents detect: [ :dep | dep isKindOf: SystemWindow ] ifFound: [:parentWindow | parentWindow label] ifNone: [ 'Untitled' ].
	suggestedName := nil.
	#(#('Decompressed contents of: ' '.gz'))
		do: [ :leaderTrailer | 
			"can add more here..."
			(labelToUse beginsWith: leaderTrailer first)
				ifTrue: [ suggestedName := labelToUse copyFrom: leaderTrailer first size + 1 to: labelToUse size.
					(labelToUse endsWith: leaderTrailer last)
						ifTrue: [ suggestedName := suggestedName copyFrom: 1 to: suggestedName size - leaderTrailer last size ]
						ifFalse: [ lastIndex := suggestedName lastIndexOf: $. ifAbsent: [ 0 ].
							lastIndex > 1
								ifTrue: [ suggestedName := suggestedName copyFrom: 1 to: lastIndex - 1 ] ] ] ].
	suggestedName ifNil: [ suggestedName := labelToUse , '.text' ].
	fileName := UIManager default request: 'File name?' initialAnswer: suggestedName.
	fileName isEmptyOrNil
		ifFalse: [ fileName asFileReference writeStreamDo: [ :out | out nextPutAll: stringToSave ] ]