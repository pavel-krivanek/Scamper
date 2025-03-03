stepping and presenter
step
	| doc|
	downloadQueue size > 0 ifTrue: [
		doc := downloadQueue next.
		
		"By now MIMEDocument sees svg as application with octet-stream"
	"	((doc notNil and: [doc mainType = 'image']) and: [doc subType = 'svg'])
		ifTrue: [
			[image := SVGMorph fromFileStream: doc contentStream]
				ifError: [:err :rcvr | self altText: 'You need SVGMorphic to display svg content!'. image := nil].
			self setSvgContents.
		]."

"TODO: fast hack to make images working"
		(doc notNil "and: [doc mainType = 'image']")
		ifTrue: [
			[image := ImageReadWriter formFromStream: doc readStream" contentStream binary"]
				on: Error do: [:err  | err traceCr. "ignore" image := nil].
			self setContents.
			]. 
		].