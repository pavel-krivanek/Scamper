font installation
installFonts
	"self installFonts"
	| numberOfFonts |
	numberOfFonts := ((FileDirectory uri: 'Scamper' , FileDirectory slash , 'fonts') fileNamesMatching: '*.ttf') size.
	((FileDirectory uri: 'Scamper' , FileDirectory slash , 'fonts') fileNamesMatching: '*.ttf')
		do: [:fontfile | 
			self newTextStyleFromTTFile:
					(FileDirectory uri: 'Scamper' , FileDirectory slash , 'fonts') fullName , FileDirectory slash , fontfile].
	self fontsInstalled: numberOfFonts.