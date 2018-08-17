Class {
	#name : #HtmlCache,
	#superclass : #Object,
	#instVars : [
		'urlToDocument',
		'url'
	],
	#category : 'HTML-Validator'
}

{ #category : #accessing }
HtmlCache >> canonicalize: aStringOrUrl [

	| href |

	href := aStringOrUrl asString.
	^((href beginsWith: 'http:') or: [(href beginsWith: 'https:') or:[(href beginsWith: 'ftp:') or: [href beginsWith: 'file:']]]) 
	ifFalse:
	[
		(ZnUrl combine: url asString withRelative: href).
	]
	ifTrue: [href].
]

{ #category : #accessing }
HtmlCache >> contentsForUrl: anUrl [

	^(self documentForUrl: anUrl) contents
]

{ #category : #accessing }
HtmlCache >> documentForUrl: anUrl [

	^(self queueUrl: anUrl) 
]

{ #category : #'initialize-release' }
HtmlCache >> initialize [

	super initialize.
	urlToDocument := Dictionary new.
]

{ #category : #accessing }
HtmlCache >> queueUrl: anUrl [

	| absoluteUrl |
	absoluteUrl := self canonicalize: anUrl.
	^urlToDocument at: absoluteUrl ifAbsentPut: 
	[
		"| request loader |
		loader := HTTPLoader default.
		request := HTTPLoader httpRequestClass for: absoluteUrl in: loader.
		loader addRequest: request.
		request"
		[absoluteUrl asZnUrl retrieveContents]
		on: Error
		do: ['']
	]	
]

{ #category : #accessing }
HtmlCache >> url [
	"Answer the value of url"

	^ url
]

{ #category : #accessing }
HtmlCache >> url: anObject [
	"Set the value of url"

	url := anObject
]
