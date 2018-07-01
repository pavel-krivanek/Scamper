changing page
downloadFromUrlAsync: aUrl withMethod: method andInputs: inputs andEncoding: encoding
	"Submit the given form with the provided inputs, url, method, and encoding"

	| promise downloadWork client resp urlWithArgs|
	promise := Promise new.
	
	downloadWork := [	| newSource |
		newSource := method asLowercase = 'get'
			ifTrue: [
					urlWithArgs := aUrl asString.
					urlWithArgs := urlWithArgs, '?'.
					"build url with input"
					inputs keysAndValuesDo: [:k :v |
						urlWithArgs := urlWithArgs, (self makeQueryArg: (v asArray first) key: k ).
						urlWithArgs := urlWithArgs, '&'.
						].
					client := ZnClient new.
					(client get: urlWithArgs) contents.
					"client := WebClient new.
					client userAgent: Scamper userAgent.
					resp := client httpGet: urlWithArgs asString.
					resp content; close" ]
			ifFalse:
				[ encoding = MIMEDocument contentTypeMultipart
					ifTrue: [ aUrl postMultipartFormArgs: inputs ]
					ifFalse: [ aUrl queryAddAll: inputs. aUrl ] ].

		downloadingProcess := nil.
		promise resolveWith: newSource ].
	
	downloadingProcess := downloadWork forkAt: Processor userBackgroundPriority.
	
	^ promise.
		
