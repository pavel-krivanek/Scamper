drawing
downloadBackgroundImageAsync: aUrl
	| promise |
	promise := Promise new.
	[ promise resolveWith: aUrl asZnUrl retrieveContents ]
		forkAt: Processor userBackgroundPriority.
	^ promise