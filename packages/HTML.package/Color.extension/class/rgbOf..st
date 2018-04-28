*HTML
rgbOf: aColorName
	"Look in all lists as only 255 literals fit into one dictionary."
	(self htmlColors1 at: aColorName asLowercase ifAbsent: [nil]) ifNotNil: [ :rgb | ^ rgb].
	(self htmlColors2 at: aColorName asLowercase ifAbsent: [nil]) ifNotNil: [ :rgb | ^ rgb].
	^nil