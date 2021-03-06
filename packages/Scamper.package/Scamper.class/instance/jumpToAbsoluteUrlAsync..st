changing page
jumpToAbsoluteUrlAsync: urlText
	"start downloading a new page.  The page source is downloaded in a background thread. 
	If urlText is no Url, emulate search bar behaviour and google the input"
	|  newUrl queryString |

	self stopEverything.
	(self isSearchWords: urlText) 
	ifTrue: [
		queryString := '?' ,  (self makeQueryArg: urlText asString key: 'q').
		newUrl := (self searchEngineUrl , queryString ) asUrl]
	ifFalse: [
		"get the new url"
		newUrl := urlText asString asUrl].

	"get the new url"
	newUrl := urlText asString asZnUrl.

	"if it fundamentally doesn't fit the pages-and-contents model used internally, spawn off an external viewer for it"
	newUrl isEmpty ifTrue: [ newUrl activate.  ^ Promise unit: self ].

	self status: ('downloading {1}...' translated format:{newUrl asString}).

	self addNextToRecentDocuments.
	^ (self downloadFromUrlAsync: newUrl)
		then: [ :aDocument |
			WorldState addDeferredUIMessage: [ self processDocument: aDocument ].
			self
			].
	
	
