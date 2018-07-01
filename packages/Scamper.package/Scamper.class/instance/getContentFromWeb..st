changing page
getContentFromWeb: aUrl
	"get the content from the WebClient and get the cookies to save"

	|client aContent resp contentType urlAfterRedirect |
	
	client := webClient.
	"resp:= client httpGet: (aUrl asString) do: [:req|
		req := self addMatchingCookiesTo: req client: client path: req url].
	
	self storeCookies: client cookies.	
	content:= resp content."
	"aContent := (ZnEasy get: aUrl) contents."
	aContent := (client get: aUrl) contents.
	urlAfterRedirect := resp url.

	contentType := MIMEDocument guessTypeFromName: urlAfterRedirect.
	contentType ifNil: [ contentType := 'text/html' ].
	
	contentType = 'application/octet-stream' ifTrue: [contentType := 'text/html'].
	aContent := MIMEDocument contentType: contentType content: aContent url: urlAfterRedirect.
	
	^ aContent.

			
