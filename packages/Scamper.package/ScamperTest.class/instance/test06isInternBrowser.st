initialize-release
test06isInternBrowser

	|url1 url2|
	
	url1 := 'browser:something' asZnUrl.
	url2 := 'something:something' asZnUrl.

	self assert: (scamper model isInternBrowserUrl: url1); 
		 assert: (scamper model isInternBrowserUrl: url2) not.
