rendering
downloadStateIn: aScamper
	"download the image"
	| doc |
	doc := [url retrieveContents] ifError: [:err | err logCr ].
	downloadQueue nextPut: doc.

