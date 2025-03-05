editing keys
encloseWith: aMatchingPair
	"Insert or remove bracket characters around the current selection. Provided for protocol compatibility, but not completely sure this is ever called"
	| event |  
	event := KeyboardEvent new.
	event 
		setType: #keystroke
		buttons: nil
		position:  0@0
		keyValue: aMatchingPair key asciiValue 
		charCode: aMatchingPair key asciiValue
		hand: nil 
		stamp: Time now.
	^self enclose: event 