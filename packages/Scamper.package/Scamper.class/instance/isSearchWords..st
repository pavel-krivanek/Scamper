testing
isSearchWords: aString

	| asUrl |
	asUrl := aString asString asZnUrl.
	
	((self isUrl: aString) or: (self isInternBrowserUrl: aString)) ifTrue: [^false].
	^ ('*.##*' match: aString) not
	