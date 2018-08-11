parsing
readFontFamilyAttribute: aString to: aContext
	| style |
	style := self class defaultStyle.
	(aString splitOn: ',') reversed
		do: [:family | (self styleForFamily: family) ifNotNil: [:s | style := s]].
	aContext at: #family put: style.

