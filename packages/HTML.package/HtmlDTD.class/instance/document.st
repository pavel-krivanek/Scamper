accessing
document
	"Answer the value of document"

	^ document isNil 
		ifFalse: [document]
		ifTrue: [url isNil ifFalse: [document := url asZnUrl retrieveContents] ifTrue: [nil]] 