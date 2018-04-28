font installation
installFontsIfNecessary
	"(((FileDirectory uri: 'Scamper' , FileDirectory slash , 'fonts') fileNamesMatching: '*.ttf') size > self fontsInstalled) ifTrue: [self installFonts]."
