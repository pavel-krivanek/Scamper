drawing
downloadBackgroundImageAsync: aUrl
	| promise |
	promise := Promise new.
	[ [promise resolveWith: aUrl asZnUrl retrieveContents] ifError: [ :e | e logCr ] ]
		forkAt: Processor userBackgroundPriority.
	^ promise