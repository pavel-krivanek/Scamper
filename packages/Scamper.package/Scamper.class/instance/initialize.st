initialization
initialize
	self initializeMIMEDatabase.
	webClient := ZnClient new.
"	webClient userAgent: Scamper userAgent.
"	documentQueue := SharedQueue new.
	recentDocuments := OrderedCollection new.
	self bookmarks: Dictionary new.
	self loadBookmark.
	currentUrlIndex := 0.
	currentUrl := ''.
	sessionCookies := OrderedCollection new.
	LongtimeCookies := OrderedCollection new.
	pageSource := ''.
<<<<<<< HEAD
	self status: 'sittin' translated.
	
=======
	self status: 'sittin' translated.
>>>>>>> up/develop
