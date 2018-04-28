changing page
jumpToAbsoluteUrlAsync: urlText
	"start downloading a new page.  The page source is downloaded in a background thread"
	
	| newUrl |

	self stopEverything.

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
	
	
