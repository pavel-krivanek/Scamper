class initialization
fromUrl: aStringOrUrl parent: aDOMNode

	| doc href url |

	href := aStringOrUrl asString.
	((href beginsWith: 'http:') or: [(href beginsWith: 'https:') or:[href beginsWith: 'ftp:']]) 
	ifFalse:
	[
		url := (ZnUrl combine: aDOMNode document responseUrl asString withRelative: href).
	]
	ifTrue: [url := href].

	"doc := HttpSocket httpGetDocument: url args: nil accept: 'text/css' request: ''."
	doc := ZnEasy get: url.
	^doc isString ifFalse: "life is good"
	[
		self new 
			content: doc contents; 
			start: 0; end: doc contents size; 
			parent: aDOMNode; 
			url: url;
			parseContents: (ReadStream on: doc contents)		
	]
	ifTrue:
	[
		nil
	]
