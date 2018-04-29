accessing
addImportedUrl: aUrl

	| doc ss |

	doc := aUrl asZnUrl retrieveContents.
	ss := CSSStyleSheet new content: doc content; start: 0; end: doc content size.
	self addImportedStyleSheet: ss.
	ss parseContents: (ReadStream on: ss content).