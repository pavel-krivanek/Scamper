drawing
downloadBackgroundImageAsync: aUrl
	| promise |
	promise := Promise new.
	[ [promise resolveWith: aUrl asZnUrl retrieveContents] on: Error do: [ :e | e traceCr ] ]
		forkAt: Processor userBackgroundPriority.
	^ promise