Extension { #name : #HtmlDocument }

{ #category : #'*HTML-Formatters' }
HtmlDocument >> addToHtmlMorph: aHtmlBlockMorph [
	self renderChildrenInto: aHtmlBlockMorph
]

{ #category : #'*HTML-Formatters' }
HtmlDocument >> formattedText [
	"return a version of this document as a formatted Text"
	| formatter |
	formatter := HtmlFormatter preferredFormatterClass new.
	self addToFormatter: formatter.
	^formatter text 
]

{ #category : #'*HTML-Formatters' }
HtmlDocument >> formattedTextForBrowser: browser  defaultBaseUrl: defaultBaseUrl [
	"return a version of this document as a formatted Text (which includes links and such)"
	| formatter text |

	"set up the formatter"
	formatter := HtmlFormatter preferredFormatterClass new.
	formatter browser: browser.
	formatter baseUrl: defaultBaseUrl.  "should check if the document specifies something else"

	"do the formatting"
	self addToFormatter: formatter.

	"get and return the result"
	text := formatter text.
	^text
]

{ #category : #'*HTML-Formatters' }
HtmlDocument >> formattedTextMorph [
	"return a version of this document as a formatted TextMorph (which includes links and such)"
	| formatter text textMorph |
	formatter := HtmlFormatter preferredFormatterClass new.
	self addToFormatter: formatter.
	text := formatter text .

	textMorph := TextMorph new initialize.
	textMorph contentsWrapped: text.

	^textMorph
]

{ #category : #'*HTML-Formatters' }
HtmlDocument >> formattedTextMorphForBrowser: browser  defaultBaseUrl: defaultBaseUrl [
	"return a version of this document as a formatted TextMorph (which includes links and such)"
	| formatter textMorph |

	"set up the formatter"
	formatter := HtmlFormatter preferredFormatterClass new.
	formatter browser: browser.
	formatter baseUrl: defaultBaseUrl.  "should check if the document specifies something else"

	"do the formatting"
	self addToFormatter: formatter.

	"get and return the result"
	textMorph := formatter textMorph .
	^textMorph
]
