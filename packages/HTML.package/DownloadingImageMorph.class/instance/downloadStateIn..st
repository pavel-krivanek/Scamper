rendering
downloadStateIn: aScamper
	"download the image"
	| doc |
	doc := [url retrieveContents] on: Error do: [:err | err traceCr ].
	downloadQueue nextPut: doc.

