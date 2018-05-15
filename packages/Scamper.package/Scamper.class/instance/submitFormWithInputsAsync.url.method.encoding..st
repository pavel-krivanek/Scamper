changing page
submitFormWithInputsAsync: inputs url: url method: method encoding: encoding
	"Submit the given form with the provided inputs, url, method, and encoding"

	| newUrl |
	self stopEverything.
	(method asLowercase ~= 'get' and: [ method asLowercase ~= 'post' ])
		ifTrue:
			[ self inform: ('unknown FORM method: {1}' translated format: {method}).
			^ false ].
	newUrl := url asUrlRelativeTo: currentUrl.
	(newUrl scheme ~= 'http' and: [newUrl scheme ~= 'https'])
		ifTrue:
			[ self inform: 'I can only submit forms via HTTP/S' translated.
			^ false ].
	self status: 'submitting form...' translated.
	self addNextToRecentDocuments.
	
	^ (self downloadFromUrlAsync: newUrl withMethod: method andInputs: inputs andEncoding: encoding)
		then: [ :aDocument |
			WorldState addDeferredUIMessage: [ self processDocument: (MIMEDocument contentType: 'text/html' content: (aDocument content) url: newUrl)].
			self ]
