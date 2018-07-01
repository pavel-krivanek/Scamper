changing page
getContentFromWeb: aUrl
	"get the content from the WebClient and get the cookies to save"
	
	|client aContent resp contentType|
	
	client := webClient.
	"resp:= client httpGet: (aUrl asString) do: [:req|
		req := self addMatchingCookiesTo: req client: client path: req url].
	
	self storeCookies: client cookies.	
	content:= resp content."
	"aContent := (ZnEasy get: aUrl) contents."
	aContent := (client get: aUrl) contents.
	urlAfterRedirect := aUrl. "TODO: get redirect url"

	contentType := MIMEDocument guessTypeFromName: aUrl.
	contentType ifNil: [ contentType := 'text/html' ].
	
	contentType = 'application/octet-stream' ifTrue: [contentType := 'text/html'].
	aContent := MIMEDocument contentType: contentType content: aContent url: aUrl.
	
	^ aContent.

			
