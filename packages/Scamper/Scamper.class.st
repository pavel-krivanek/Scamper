"
a basic web browser.

It downloads things in a background thread; the background thread puts downloaded objects onto downloadQueue as they arrive.  The queue is checked in the step method.

A custom start page is provided for.  It's not as convenient as bookmarks are, but it does have a lot of flexibility--the user can put anything on the start page that is desired.

There is a hook for displaying the ""lint"" of a page; currently it's not a very effective linter.
"
Class {
	#name : #Scamper,
	#superclass : #Model,
	#instVars : [
		'status',
		'debugInfo',
		'currentUrl',
		'pageSource',
		'document',
		'downloadingProcess',
		'documentQueue',
		'recentDocuments',
		'currentUrlIndex',
		'bookDir',
		'webPageMorph',
		'sessionCookies',
		'content',
		'webClient',
		'tabs',
		'bookmarks',
		'aStream',
		'reloadAndStopButton',
		'tabPaneVariable',
		'currentTab',
		'optionsPanel',
		'searchEngineUrl',
		'menuHistory'
	],
	#classVars : [
		'LongtimeCookies',
		'StartUrl'
	],
	#category : 'Scamper-Core'
}

{ #category : #initialization }
Scamper class >> StartUrl [
	"The default URL to start from"

	<preference: 'Homepage'
		category: 'scamper'
		description: 'The home URL for scamper'
		type: #String>

	^StartUrl ifNil:['']
]

{ #category : #initialization }
Scamper class >> StartUrl: aStringOrUrl [
	"Specify the default URL to start from."

	StartUrl := aStringOrUrl asZnUrl
]

{ #category : #cookies }
Scamper class >> addLongtimeCookie: aCookie [

	"remove older duplicates"
	LongtimeCookies do: [:cookie |
		LongtimeCookies  := LongtimeCookies reject: [:any | any = aCookie]].
	LongtimeCookies add: aCookie
]

{ #category : #'instance creation' }
Scamper class >> fileReaderServicesForFile: fullName suffix: suffix [

	^(suffix = 'htm') | (suffix = 'html') 
		ifTrue: [self services]
		ifFalse: [#()]
]

{ #category : #'window definition' }
Scamper class >> iconsReference [

	^ self package mcWorkingCopy ancestry ancestors first package repository location / 'build-support' / 'scamper-icons' / 'png'
]

{ #category : #initialization }
Scamper class >> initialize [
	"Initialize the class"

	self StartUrl: 'https://www.google.com'.
	"FileList registerFileReader: self."
	"WebBrowser register: self."


]

{ #category : #initialization }
Scamper class >> install [ 
	Scamper initialize.
	Scamper registerInSqueakMenus.
]

{ #category : #cookies }
Scamper class >> longtimeCookies [

	^ LongtimeCookies
]

{ #category : #cookies }
Scamper class >> longtimeCookies: aCollection [

	LongtimeCookies := aCollection.
]

{ #category : #initialization }
Scamper class >> menuCommandOn: aBuilder [ 
	<worldMenu> 
	(aBuilder item: #'Scamper')
			parent: #Tools;
			action:[self new openAsMorph]; 
			help: 'Scamper Web Browser'.
]

{ #category : #'instance creation' }
Scamper class >> new [
	^ super new initialize
]

{ #category : #'instance creation' }
Scamper class >> newInstancePointingAt: aStringOrUrl [
	"Answer a Scamper browser on specified url.
		Scamper newInstancePointingAt: 'www.squeak.org'
		Scamper newInstancePointingAt: 'file://C%3A/test.htm'
	"

	
		^ (self new jumpToUrlAsync: aStringOrUrl asZnUrl) morphicWindow applyModelExtent
]

{ #category : #'instance creation' }
Scamper class >> newOpenableMorph [
	"Answer a morph that bears the receiver, but don't blast it onto the screen"

	^ self newInstancePointingAt: StartUrl
]

{ #category : #'instance creation' }
Scamper class >> newOrExistingOn: aStringOrUrl [
	| aUrl siteStr |
	"If a Scamper is open on the same site, return its SystemWindow, else return a new Scamper."

aUrl := aStringOrUrl asZnUrl.
siteStr := aUrl schemeName, '://', aUrl authority.

Smalltalk isMorphic ifTrue: [
	World submorphsDo: [:m | 
		((m isKindOf: SystemWindow) and: [m model isKindOf: Scamper]) ifTrue: [
			(m model currentUrl asString beginsWith: siteStr) ifTrue: [
					m expand.
					^ m]]]].

^ self new openAsMorph

]

{ #category : #'instance creation' }
Scamper class >> open [
	"Scamper open"

	^ self openOnUrl: StartUrl
]

{ #category : #'instance creation' }
Scamper class >> openAsMorph [
	"Deprecated. Use open instead."

	^ self open
]

{ #category : #'instance creation' }
Scamper class >> openFile: fullFileName [
	Scamper openOnUrl: 
		(FileDirectory forFileName: fullFileName) url , 
		(FileDirectory localNameFor: fullFileName) encodeForHTTP

]

{ #category : #'instance creation' }
Scamper class >> openFileFromFileList: fullName [
	
	self openFile: fullName
]

{ #category : #'instance creation' }
Scamper class >> openOnUrl: aStringOrUrl [
	"Open Scamper browser on specified url.
		Scamper openOnUrl: 'www.squeak.org'
		Scamper openOnUrl: 'file://C%3A/test.htm'
	"
	| scamper |
	scamper := self new.
	(scamper jumpToUrlAsync: aStringOrUrl asZnUrl) wait.
	^ scamper openAsMorph
]

{ #category : #'instance creation' }
Scamper class >> openOnUrlAsync: aStringOrUrl [
	"Open Scamper browser on specified url.
		Scamper openOnUrl: 'www.squeak.org'
		Scamper openOnUrl: 'file://C%3A/test.htm'
	"
	^ (self new jumpToUrlAsync: aStringOrUrl asZnUrl)
]

{ #category : #initialization }
Scamper class >> registerInSqueakMenus [ 
	TheWorldMenu registerOpenCommand: {'Scamper'. {self. #open}}.
]

{ #category : #'instance creation' }
Scamper class >> serviceOpenInWebBrowser [
	"Answer a service for opening a web browser on a file"

	^ SimpleServiceEntry 
			provider: self 
			label: 'open in web browser'
			selector: #openFile:
			description: 'open in web browser'
			buttonLabel: 'open'
]

{ #category : #'instance creation' }
Scamper class >> services [

	^ Array with: self serviceOpenInWebBrowser


]

{ #category : #'class initialization' }
Scamper class >> unload [
	"Unload the receiver from global registries"

	WebBrowser unregister: self.
]

{ #category : #'instance creation' }
Scamper class >> userAgent [

	^ 'Scamper v1.0.0-SS15'
]

{ #category : #'browser urls' }
Scamper >> aboutScamperHTML [
	"return a string of HTML which introduces Scamper"
	^'
<html>
<head>
<title >{1}</title>
</head>
<body>
<h1 >{2}</h1>
{3}
<ul>
<li ><a href="http://wiki.squeak.org/squeak/">{4}</a>
<li><a href="http://wiki.squeak.org/squeak/14">{5}</a>
<li><a href="http://www.squeak.org">{6}</a>
<li><a href="http://www.squeakland.org">{7}</a>
</ul>
</body>
</html>' format:{
	'About Scamper' translated.
	'Scamper' translated.
	'This is Scamper, a WWW browser for Squeak.  Here are some URL''s to start at:' translated.
	'The Squeak Swiki' translated.
	'Scamper''s Home Page' translated.
	'Squeak''s Home Page' translated.
	'The SqueakLand Home Page' translated
	}
]

{ #category : #cookies }
Scamper >> addMatchingCookiesTo: aRequest client: aWebClient path: aPath [

	sessionCookies  do: [:c | 
			(aWebClient acceptCookie: c host: aWebClient server path: aPath) ifTrue: [
				aRequest addHeader: 'Cookie' value: c asString]].
	
	LongtimeCookies  do: [:c | 
			(aWebClient acceptCookie: c host: aWebClient server path: aPath) ifTrue: [
				aRequest addHeader: 'Cookie' value: c asString]].
	^ aRequest

]

{ #category : #menus }
Scamper >> addNewSubMenu: aDictionary [ 
	| subMenu url sub |
	subMenu := MenuMorph new.
	aDictionary
		keysAndValuesDo: 
			[:name :value | 
			url := value.
			(url isKindOf: Dictionary)
				ifTrue: 
					[sub := self addNewSubMenu: url.
					subMenu add: name subMenu: sub]
				ifFalse: [subMenu
						add: name
						target: self
						selector: #jumpToUrlAsync:
						argument: url]].
	^ subMenu
]

{ #category : #'document handling' }
Scamper >> addNextToRecentDocuments [
	
	self updateRecentDocuments.
	currentUrlIndex := currentUrlIndex + 1

]

{ #category : #cookies }
Scamper >> addSessionCookie: aCookie [

	"remove older duplicates"
	sessionCookies do: [:cookie |
		sessionCookies := sessionCookies reject: [:any | any = aCookie]].
	sessionCookies add: aCookie.
]

{ #category : #tabs }
Scamper >> addTab [
	|pair|
	
	pair:= Array new: 2.
	pair at: 1 put: '';
		at: 2 put: self currentTab asString.
		
	self tabs addLast: pair.
	self currentTab: (self tabs size).
	self addTabButton.

]

{ #category : #'as yet unclassified' }
Scamper >> addTabButton [
	|button indexOfTab|
				
	indexOfTab:= (self tabs size).
	
	button:= (SimpleButtonMorph new
		target: self;
		color: (Color r:1 g:1 b:1);
		hResizing: #spaceFill;
		label: ((self tabs at: indexOfTab) at: 2);
		actionSelector: #openTab:;
		arguments: indexOfTab asOrderedCollection).
		button openInWorld.
	
	tabPaneVariable addMorph: button.
					
]

{ #category : #menus }
Scamper >> addToBookmark [

	| key value file filename |

	key := (self getTitle: document) ifNil: ['Untitled' translated].
	value := self currentUrl.
	filename := key,'.lin'.
	self bookDir deleteFileNamed: filename. 
	file := StandardFileStream fileNamed: (self bookDir fullNameFor: filename).
	file ifNil:[self error: 'could not save file' translated].
	file nextPutAll: value asString. 
	file close.
	self bookmarks add: (Association key: key value: value).
	

]

{ #category : #menus }
Scamper >> back [
	"The user hit the back button -- go to the previous document"

	"this method is added to Scamper: Aibek 4/18/99"

	currentUrlIndex > 1
		ifFalse: [ ^ self ].
	currentUrlIndex := currentUrlIndex - 1.
	currentUrlIndex <= recentDocuments size
		ifTrue: [ self displayDocument: (recentDocuments at: currentUrlIndex) ]
]

{ #category : #'button text' }
Scamper >> backButtonText [

	^ 'Go back to previous URL in history' translated.
]

{ #category : #access }
Scamper >> backgroundColor [
	^self defaultBackgroundColor
]

{ #category : #accessing }
Scamper >> bookDir [
	^ bookDir
]

{ #category : #accessing }
Scamper >> bookDir: anObject [
	bookDir := anObject
]

{ #category : #menus }
Scamper >> bookmark [
	| menu sub url |
	menu := (MenuMorph entitled: ' Bookmark ' translated)
				defaultTarget: self.
	menu addStayUpItem.
	menu addLine.
	menu
		add: 'add to bookmark' translated
		target: self
		selector: #addToBookmark.
	menu add: 'Import...' translated target: self selector: #importBookmark. 
	menu addLine.
	self bookmarks
		keysAndValuesDo: 
			[:name :value | 
			url := value.
			(url isKindOf: Dictionary)
				ifTrue: 
					[sub := self addNewSubMenu: url.
					menu add: name subMenu: sub]
				ifFalse: [menu
						add: name
						selector: #jumpToUrlAsync:
						argument: url]].
	menu addLine.
	menu
		add: 'Clear Bookmark' translated
		target: self
		selector: #clearBookmark.
	menu popUpInWorld: self currentWorld

]

{ #category : #'button text' }
Scamper >> bookmarkButtonText [
	^ 'Display a list of bookmarks' translated.
]

{ #category : #access }
Scamper >> bookmarks [
	^ bookmarks

]

{ #category : #access }
Scamper >> bookmarks: aDictionary [
	bookmarks := aDictionary.

]

{ #category : #'browser urls' }
Scamper >> bookmarksHTML [
	"returns a string which lists user boomarks in html"
	
	| bookmarkList |
	bookmarkList := ''.
	self bookmarks keysAndValuesDo: [ :aKey : aValue | bookmarkList := bookmarkList, '<li><a href="', aValue asString, '">', aKey asString,'</a></li>' ].
	^'
<html>
<head>
<title>{1}</title>
</head>
<body>
<h1>{2}</h1>
<ul>', bookmarkList, 
'</ul>
</body>
</html>' format:{
	'Bookmarks' translated.
	'Bookmarks' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> browserUrlContents: aRequest [

	aRequest = 'start' ifTrue: [ 
		^MIMEDocument contentType: 'text/html' content: self startPage ].

	aRequest = 'about' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self aboutScamperHTML ].
	
	aRequest = 'history' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self historyHTML ].
	
	aRequest = 'deleteHistory' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self deleteHistory].
	
	aRequest = 'bookmarks' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self bookmarksHTML ].
	
	aRequest = '400' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error400Page  ].
	
	aRequest = '401' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error401Page  ].
		
	aRequest = '402' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error402Page  ].	
		
	aRequest = '403' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error403Page  ].	
	
	aRequest = '404' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error404Page  ].	
	
	aRequest = '405' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error405Page  ].	
	
	aRequest = '406' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error406Page  ].	
	
	aRequest = '407' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error407Page  ].	
	
	aRequest = '404' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error404Page  ].	
	
	aRequest = '404' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error404Page  ].	
	
	aRequest = '408' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error408Page  ].	
	
	aRequest = '409' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error409Page  ].	
	
	aRequest = '410' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error410Page  ].	
	
	aRequest = '411' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error411Page  ].	
	
	aRequest = '412' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error412Page  ].
	
	aRequest = '413' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error413Page  ].
		
	aRequest = '414' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error414Page  ].
		
	aRequest = '415' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error415Page  ].
		
	aRequest = '416' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error416Page  ].
		
	aRequest = '417' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error417Page  ].
		
	aRequest = '418' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error418Page  ].
		
	aRequest = '420' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error420Page  ].
		
	aRequest = '421' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error421Page  ].
		
	aRequest = '422' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error422Page  ].
		
	aRequest = '423' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error423Page  ].
		
	aRequest = '424' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error424Page  ].
		
	aRequest = '425' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error425Page  ].
		
	aRequest = '426' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error426Page  ].	
				
	aRequest = '428' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error428Page  ].
			
	aRequest = '429' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error429Page  ].
			
	aRequest = '431' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error431Page  ].
			
	aRequest = '451' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error451Page  ].
			
	aRequest = '500' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error500Page  ].
				
	aRequest = '501' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error501Page  ].
				
	aRequest = '502' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error502Page  ].
				
	aRequest = '503' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error503Page  ].
				
	aRequest = '504' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error504Page  ].
				
	aRequest = '505' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error505Page  ].
				
	aRequest = '506' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error506Page  ].
				
	aRequest = '507' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error507Page  ].
				
	aRequest = '508' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error508Page  ].
				
	aRequest = '509' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error509Page  ].
				
	aRequest = '510' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error510Page  ].
				
	aRequest = '511' ifTrue: [
		^MIMEDocument contentType: 'text/html' content: self error511Page  ].
	
		^ nil
]

{ #category : #'button text' }
Scamper >> buildUrlStringFrom: aUrl WithFormInput: aDictionary [
	| urlWithArgs first |
	urlWithArgs := (aUrl downloadUrl) asText.
	urlWithArgs append: '?'.
	"build url with input"
	first := false.
	aDictionary keysAndValuesDo: [:k :valueCollection |
		first ifTrue: [ first := false ] ifFalse: [ urlWithArgs append: $& ].
		urlWithArgs append: (self makeQueryArg: valueCollection first key: k )].
	^urlWithArgs asString 
	
	
]

{ #category : #'window definition' }
Scamper >> buttonRowPane [
	"Create and return a pane of navigation buttons."

	| buttonRow |
	
	buttonRow := (AlignmentMorph new)
				borderWidth: 0;
				layoutInset: 0;
				color:(Color transparent );
				hResizing: #spaceFill;
				wrapCentering: #center;
				cellPositioning: #leftCenter;
				clipSubmorphs: true;
				addTransparentSpacerOfSize: 5 @ 0.
	buttonRow
		addMorphBack: (self 
					simpleButtonNamed: 'History' translated
					action: #visitHistoryPage
					text: self historyButtonText);
		addTransparentSpacerOfSize: 5 @ 0;
		addMorphBack: (self 
					simpleButtonNamed: 'Bookmark' translated
					action: #visitBookmarksPage
					text: self bookmarkButtonText);
		addTransparentSpacerOfSize: 5 @ 0;
		addMorphBack: (self 
					simpleIconicButtonNamed: 'Stop'
					action: #stopEverything
					withIcon:  ((ImageReadWriter formFromFileNamed:  (self iconCancel asFileReference))));
		addTransparentSpacerOfSize: 5 @ 0;
		addMorphBack: (self 
					simpleButtonNamed: 'Stop!' translated
					action: #stopEverything
					text: self stopButtonText);
		addTransparentSpacerOfSize: 5@0;
		addMorphBack: (self
					simpleButtonNamed: 'Source'
					action: #viewSource
					text: 'View Source' ).
	^buttonRow

]

{ #category : #'change/update' }
Scamper >> changeAll: aspects [
	"We have changed all of the aspects in the given array"
	
	aspects do:[:symbol| self changed: symbol].
]

{ #category : #'as yet unclassified' }
Scamper >> clearBookmark [
	| Directory |
	Directory :=FileDirectory on: (self bookDir pathName).
	Directory deleteLocalFiles.
	self bookmark: Dictionary new.
	
]

{ #category : #tabs }
Scamper >> closeAllTabs [

	self tabs: nil.
	self visitStartPage.
]

{ #category : #'document handling' }
Scamper >> content [

	^ content
]

{ #category : #'document handling' }
Scamper >> content: aString [ 

	content := aString 
]

{ #category : #menus }
Scamper >> createBookmarkFiles: aDirectory dict: aDictionary dirname: aName [
	| dir file filename |
	(aDirectory directoryExists: aName) ifFalse:[aDirectory createDirectory: aName]. 
	dir := aDirectory directoryNamed: aName.
	aDictionary keysAndValuesDo:[:k :v |
				(v isKindOf: Dictionary)
					ifTrue:[self createBookmarkFiles: dir dict: v dirname: k]
					ifFalse:[filename := k, '.lin'.
							dir deleteFileNamed: filename.
							file := StandardFileStream fileNamed: (dir fullNameFor: filename).
							file ifNil:[self error: 'could not save file' translated].
							file nextPutAll: v asString.
							file close]
				].
]

{ #category : #tabs }
Scamper >> createTab [
	"creates a pair that can be added to tabs collection"	
	
	| pair|
	Transcript show: self document.
	pair:= Array new: 2.
	pair at: 1 put: self document;
		at: 2 put: (self getTitle: self document).
	^pair
	
]

{ #category : #accessing }
Scamper >> currentTab [
	^ currentTab
]

{ #category : #accessing }
Scamper >> currentTab: anObject [
	currentTab := anObject
]

{ #category : #access }
Scamper >> currentUrl [
	^currentUrl
]

{ #category : #accessing }
Scamper >> currentUrl: anObject [
	currentUrl := anObject
]

{ #category : #accessing }
Scamper >> currentUrlIndex [
	^ currentUrlIndex
]

{ #category : #accessing }
Scamper >> currentUrlIndex: anObject [
	currentUrlIndex := anObject
]

{ #category : #access }
Scamper >> defaultBackgroundColor [
	^Color white
]

{ #category : #private }
Scamper >> defaultWorkerCount [
	^5

]

{ #category : #menus }
Scamper >> deleteHistory [
	"Let the user select a previous page to view."

	self recentDocuments: nil.
	self recentDocuments: OrderedCollection new.
	^self historyHTML

]

{ #category : #'document handling' }
Scamper >> displayDocument: mimeDocument [
	"switch to viewing the given MIMEDocument"
	|  handled  urlString |
	handled := false.

	"add it to the history"
"	recentDocuments removeAllSuchThat: [ :d | d url = mimeDocument url ]."
	currentUrlIndex > recentDocuments size
		ifTrue: [recentDocuments addLast: mimeDocument].
"		ifFalse: [recentDocuments removeAt: currentUrlIndex]."
	recentDocuments size > 20 ifTrue: [ recentDocuments removeFirst ].
	
	mimeDocument mainType = 'image' 
		ifTrue: [handled := self displayImagePage: mimeDocument].

	(mimeDocument contentType beginsWith: 'text/html') 
		ifTrue: [handled := self displayTextHtmlPage: mimeDocument].

	(#('audio/midi' 'audio/x-midi') includes: mimeDocument contentType) 
		ifTrue: [handled := self processMidiPage: mimeDocument].

	"Before we display plain text files we should look at the extension of the URL"
	(handled not and:[ mimeDocument mainType = 'text']) ifTrue:[
		urlString := mimeDocument url asString.
		(urlString endsWithAnyOf: #('.gif' '.jpg' '.pcx')) 
			ifTrue:[handled := self displayImagePage: mimeDocument].
		(handled not and:[urlString endsWithAnyOf: #('.mid' '.midi')])
			ifTrue:[handled := self processMidiPage: mimeDocument].
	].

	(handled not and: [ mimeDocument mainType = 'text']) ifTrue: [
		self displayPlainTextPage: mimeDocument.
		handled := true].


	handled ifFalse: [self processUnhandledPage: mimeDocument].

]

{ #category : #menus }
Scamper >> displayHistory [

	"Let the user selecet a previous page to view."
	
	menuHistory := MenuMorph entitled: 'Recent URLs' translated.
	menuHistory defaultTarget: self;
				  addStayUpItem;
				  addLine.
	recentDocuments reverseDo:
		[:doc |
		menuHistory add: doc url asString selector: #displayDocument: argument: doc].
	menuHistory popUpInWorld: self currentWorld

]

{ #category : #'document handling' }
Scamper >> displayImagePage: newSource [
	"an image--embed it in a text"
	| image imageMorph handled|
	handled := true.
	
	"check if Image is svg"
	((newSource contentType) includesSubString: 'svg') ifTrue: [
		[imageMorph := SVGMorph fromFileStream: newSource contentStream.]
			ifError: [:err :crvr | imageMorph := StringMorph new; contents: 'You need SVGMorphic to display svg content!'.] 
	]
	"if not -> use default ImageReader"
	ifFalse: [
	image := ImageReadWriter formFromStream: (RWBinaryOrTextStream with: newSource content) binary reset.
	imageMorph := ImageMorph new image: image.
	].

	self webContentsPane showImagePage: imageMorph.
	currentUrl := newSource url.
	pageSource := newSource content.

	"remove it from the history--these thigns are too big!"
	"ideally, there would be a smarter history mechanism that can do things like remove items when memory consumption gets too high...."
"	recentDocuments removeLast."

	self changeAll: 	#(currentUrl relabel hasLint lint backgroundColor formattedPage formattedPageSelection).
	self status: 'done' translated.
	^handled
]

{ #category : #'document handling' }
Scamper >> displayPlainTextPage: newSource [
	"treat as plain text"
	pageSource := newSource content.
	document := nil.
	formattedPage := pageSource withSqueakLineEndings.
	backgroundColor := self defaultBackgroundColor.
	currentUrl := newSource url.

	self status: 'sittin' translated.
	self changeAll: 	#(currentUrl relabel hasLint lint formattedPage formattedPage
formattedPageSelection).
	^true
]

{ #category : #'document handling' }
Scamper >> displayTextHtmlPage: newSource [
	"HTML page--format it"
	currentUrl := newSource url.
	"utf8mode := UTF8TextConverter strictUtf8Conversions.
	UTF8TextConverter strictUtf8Conversions: false."
	pageSource := newSource content.
	self status: 'parsing...' translated.
	document := (HtmlDocument new parseContents: (ReadStream on: pageSource)).
	document
		requestUrl: currentUrl;
	 	responseUrl: currentUrl.
	self status: 'applying styles...' translated.
	document stylesheets do: [:stylesheet |
		(stylesheet absoluteUrl = currentUrl) ifFalse: [ stylesheet loadStyles]].
	document applyStyles.
	self status: 'laying out...' translated.
	self webContentsPane show: document.

	self changeAll: 	#(currentUrl relabel).
	self status: 'done.' translated.
	^true

]

{ #category : #accessing }
Scamper >> doItContext [
	^nil
]

{ #category : #accessing }
Scamper >> doItReceiver [
	^nil
]

{ #category : #access }
Scamper >> document [
	"return the current parsed HTML document, or nil if we aren't viewing a page"
	^document
]

{ #category : #accessing }
Scamper >> document: anObject [
	document := anObject
]

{ #category : #'changing page' }
Scamper >> downloadFromUrlAsync: aUrl [
	
	| promise downloadWork handled|
	
	promise := Promise new.
	handled := false.
	
	downloadWork := [ | newSource |
		
		"webpage"
		(self isUrl: aUrl) ifTrue: [newSource := [self getContentFromWeb: aUrl] ifError: [ :msg :ctx |
				msg logCr.
		MIMEDocument contentType: 'text/plain' content: msg ]. handled := true.].
		"intern site"
		(self isInternBrowserUrl: aUrl) ifTrue: [newSource := [ aUrl getlocalContentsforBrowser: self ] ifError: [ :msg :ctx |
		MIMEDocument contentType: 'text/plain' content: msg ]. handled := true.].
		"file"
		handled ifFalse: [newSource := [aUrl retrieveContentsForBrowser: self] ifError: [ :msg :ctx |
		MIMEDocument contentType: 'text/plain' content: msg ]. handled := true.].

		newSource 
			ifNil: [ newSource := MIMEDocument contentType: 'text/plain' content: 'Error retrieving this URL' translated].

		newSource url ifNil: [
			newSource := MIMEDocument contentType: newSource contentType  content: newSource content  url: aUrl ].

		downloadingProcess := nil.
		promise resolveWith: newSource ].
	
	downloadingProcess := downloadWork forkAt: Processor userBackgroundPriority.

	^ promise.
]

{ #category : #'changing page' }
Scamper >> downloadFromUrlAsync: aUrl withMethod: method andInputs: inputs andEncoding: encoding [
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
					urlWithArgs := self buildUrlStringFrom: aUrl WithFormInput: inputs.
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
		

]

{ #category : #menus }
Scamper >> editStartPage [
	| win textMorph |
	Smalltalk isMorphic ifFalse: [^ self inform: 'only works for morphic currently' translated].

	win := SystemWindow labelled: 'edit Bookmark page' translated.
	win model: self.
	textMorph := PluggableTextMorph on: self text: #startPage  accept: #startPage:.
	win addMorph: textMorph frame: (0@0 extent: 1@1).
	win openInWorld.
	^ true
]

{ #category : #'browser urls' }
Scamper >> error400Page [
	"return a string of HTML about status 400"
	^ self errorPageTemplate format:{
	'Error 400' translated.
	'An error occured: Bad Request	.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error401Page [
	"return a string of HTML about status 401"
	^ self errorPageTemplate format:{
	'Error 401' translated.
	'An error occured: Unauthorized.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error402Page [
	"return a string of HTML about status 402"
	^ self errorPageTemplate format:{
	'Error 402' translated.
	'An error occured: Payment Required.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error403Page [
	"return a string of HTML about status 403"
	^ self errorPageTemplate format:{
	'Error 403' translated.
	'An error occured: Forbidden.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error404Page [
	"return a string of HTML about status 404"
	^ self errorPageTemplate format:{
	'Error 404' translated.
	'An error occured: The page was not found.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error405Page [
	"return a string of HTML about status 405"
	^ self errorPageTemplate format:{
	'Error 405' translated.
	'An error occured: Method Not Allowed.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error406Page [
	"return a string of HTML about status 406"
	^ self errorPageTemplate format:{
	'Error 406' translated.
	'An error occured: Not Acceptable.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error407Page [
	"return a string of HTML about status 407"
	^self errorPageTemplate format:{
	'Error 407' translated.
	'An error occured: Proxy Authentication Required.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error408Page [
	"return a string of HTML about status 408"
	^ self errorPageTemplate format:{
	'Error 408' translated.
	'An error occured: Request Time-out.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error409Page [
	"return a string of HTML about status 409"
	^ self errorPageTemplate format:{
	'Error 409' translated.
	'An error occured: Conflict.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error410Page [
	"return a string of HTML about status 410"
	^ self errorPageTemplate format:{
	'Error 410' translated.
	'An error occured: Gone.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error411Page [
	"return a string of HTML about status 411"
	^ self errorPageTemplate format:{
	'Error 411' translated.
	'An error occured: Length Required.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error412Page [
	"return a string of HTML about status 412"
	^ self errorPageTemplate format:{
	'Error 412' translated.
	'An error occured: Precondition Failed.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error413Page [
	"return a string of HTML about status 413"
	^ self errorPageTemplate format:{
	'Error 413' translated.
	'An error occured: Request Entity Too Large.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error414Page [
	"return a string of HTML about status 414"
	^self errorPageTemplate format:{
	'Error 414' translated.
	'An error occured: Request-URL Too Long.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error415Page [
	"return a string of HTML about status 415"
	^ self errorPageTemplate format:{
	'Error 415' translated.
	'An error occured: Unsupported Media Type.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error416Page [
	"return a string of HTML about status 416"
	^self errorPageTemplate format:{
	'Error 416' translated.
	'An error occured: Requested range not satisfiable.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error417Page [
	"return a string of HTML about status 417"
	^ self errorPageTemplate format:{
	'Error 417' translated.
	'An error occured: Expectation Failed.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error418Page [
	"return a string of HTML about status 418"
	^ self errorPageTemplate format:{
	'Error 418' translated.
	'An error occured: Im a teapot.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error420Page [
	"return a string of HTML about status 420"
	^ self errorPageTemplate format:{
	'Error 420' translated.
	'An error occured: 	Policy Not Fulfilled.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error421Page [
	"return a string of HTML about status 421"
	^self errorPageTemplate format:{
	'Error 421' translated.
	'An error occured: Misdirected Request.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error422Page [
	"return a string of HTML about status 422"
	^ self errorPageTemplate format:{
	'Error 422' translated.
	'An error occured: Unprocessable Entity.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error423Page [
	"return a string of HTML about status 423"
	^ self errorPageTemplate format:{
	'Error 423' translated.
	'An error occured: 	Locked.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error424Page [
	"return a string of HTML about status 424"
	^self errorPageTemplate format:{
	'Error 424' translated.
	'An error occured: Failed Dependency.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error425Page [
	"return a string of HTML about status 425"
	^self errorPageTemplate format:{
	'Error 425' translated.
	'An error occured: Unordered Collection.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error426Page [
	"return a string of HTML about status 426"
	^ self errorPageTemplate format:{
	'Error 426' translated.
	'An error occured: Upgrade Required.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error428Page [
	"return a string of HTML about status 428"
	^self errorPageTemplate format:{
	'Error 428' translated.
	'An error occured: Precondition Required.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error429Page [
	"return a string of HTML about status 429"
	^self errorPageTemplate format:{
	'Error 429' translated.
	'An error occured: Too Many Requests.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error431Page [
	"return a string of HTML about status 431"
	^ self errorPageTemplate format:{
	'Error 431' translated.
	'An error occured: Request Header Fields Too Large.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error451Page [
	"return a string of HTML about status 451"
	^ self errorPageTemplate format:{
	'Error 451' translated.
	'An error occured: Unavailable For Legal Reasons.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error500Page [
	"return a string of HTML about status 500"
	^ self errorPageTemplate format:{
	'Error 500' translated.
	'An error occured: Internal Server Error.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error501Page [
	"return a string of HTML about status 501"
	^ self errorPageTemplate format:{
	'Error 501' translated.
	'An error occured: Not Implemented.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error502Page [
	"return a string of HTML about status 502"
	^ self errorPageTemplate format:{
	'Error 502' translated.
	'An error occured: Bad Gateway.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error503Page [
	"return a string of HTML about status 503"
	^ self errorPageTemplate format:{
	'Error 503' translated.
	'An error occured: Service Unavailable.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error504Page [
	"return a string of HTML about status 504"
	^ self errorPageTemplate format:{
	'Error 504' translated.
	'An error occured: Gateway Time-out.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error505Page [
	"return a string of HTML about status 505"
	^ self errorPageTemplate format:{
	'Error 505' translated.
	'An error occured: HTTP Version not supported.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error506Page [
	"return a string of HTML about status 506"
	^ self errorPageTemplate format:{
	'Error 506' translated.
	'An error occured: Variant Also Negotiates.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error507Page [
	"return a string of HTML about status 507"
	^ self errorPageTemplate format:{
	'Error 507' translated.
	'An error occured: Insufficient Storage.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error508Page [
	"return a string of HTML about status 508"
	^ self errorPageTemplate format:{
	'Error 508' translated.
	'Loop Detected.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error509Page [
	"return a string of HTML about status 509"
	^ self errorPageTemplate format:{
	'Error 509' translated.
	'Bandwidth Limit Exceeded.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error510Page [
	"return a string of HTML about status 510"
	^ self errorPageTemplate format:{
	'Error 510' translated.
	'Not Extended.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> error511Page [
	"return a string of HTML about status 511"
	^ self errorPageTemplate format:{
	'Error 511' translated.
	'Network Authentication Required.' translated.
	}
]

{ #category : #'browser urls' }
Scamper >> errorPageTemplate [
	"returns a generic error page template"
	^'
<html>
<head>
<title>{1}</title>
</head>
<body>
<h1>{1}</h1>
<p>
{2}
</p>

</body>
</html>'
]

{ #category : #access }
Scamper >> formattedPage [
	"format the current page and return it as a Text"
 	^formattedPage ifNil: [ ^Text new ].
	
]

{ #category : #access }
Scamper >> formattedPageSelection [
	currentAnchorLocation ifNil: [ ^0 to: -1 ].
	^currentAnchorLocation to: currentAnchorLocation
]

{ #category : #menus }
Scamper >> forward [
	"this method is added to Scamper: Aibek 4/18/99"
	currentUrlIndex >= recentDocuments size
		ifTrue: [^self]
		ifFalse: [
			currentUrlIndex := currentUrlIndex + 1.
			self displayDocument: (recentDocuments at: currentUrlIndex).
		]

]

{ #category : #'button text' }
Scamper >> forwardButtonText [
	
	^ 'Go forward to next URL in history' translated.
]

{ #category : #'changing page' }
Scamper >> getContentFromWeb: aUrl [
	"get the content from the WebClient and get the cookies to save"

	|client aContent resp contentType urlAfterRedirect |
	
	client := webClient.
	"resp:= client httpGet: (aUrl asString) do: [:req|
		req := self addMatchingCookiesTo: req client: client path: req url].
	
	self storeCookies: client cookies.	
	content:= resp content."
	"aContent := (ZnEasy get: aUrl) contents."
	aContent := (client get: aUrl) contents.
	urlAfterRedirect := aUrl. "TODO: get redirect url"

	contentType := MIMEDocument guessTypeFromName: urlAfterRedirect.
	contentType ifNil: [ contentType := 'text/html' ].
	
	contentType = 'application/octet-stream' ifTrue: [contentType := 'text/html'].
	aContent := MIMEDocument contentType: contentType content: aContent url: urlAfterRedirect.
	
	^ aContent.

			

]

{ #category : #'not yet categorized' }
Scamper >> getTitle: aHTMLDocument [
  "Get title of HTMLDocument"
  
  | a b leftOffset rightOffset|
  
  leftOffset := 7.
  rightOffset := 1.
  a := document asString findString: '<title>'.
  b := document asString findString: '</title>'.
  ^ (a = b) 
		ifFalse: [ document asString copyFrom: (a+leftOffset) to: (b-rightOffset) ]
		ifTrue: [ 'untitled' ]
	
]

{ #category : #lint }
Scamper >> hasLint [
	"whether the current page has any questionable HTML in it"
	document ifNil: [ ^false ].
	^document lint ~= ''
]

{ #category : #'button text' }
Scamper >> historyButtonText [

	^ 'Return to a recent URL in history' translated.
]

{ #category : #'browser urls' }
Scamper >> historyHTML [
	"returns a string which shows th users browser history in html"
	
	| historyList |
	historyList := ''.
	self recentDocuments reverseDo: [ :doc | historyList := historyList, '<li><a href="', doc url asString, '">', doc url asString,'</a></li>' ].
	^'
<html>
<head>
<title>{1}</title>
</head>
<body>
<h1>{1}</h1>
<table>
<tr>
<td>
<h3>{4}</h3>
<ul>', historyList, 
'</ul>
</td>
<td>
<h3>{2}</h3>
<a href="browser:deleteHistory">{3}<a/>
</td>
</tr>
</table>
</body>
</html>' format:{
	'History' translated.
	'Options' translated.
	'Delete History' translated.
	'Recently visited pages' translated.
	}
]

{ #category : #'button text' }
Scamper >> homeButtonText [
	
	^ 'Go to start page' translated.
]

{ #category : #'window definition' }
Scamper >> iconAddBookmark [
	
	^ self iconsReference / 'link-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconBackward [
	
	^ self iconsReference / 'back-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconBookmark [
	
	^ self iconsReference / 'folder-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconCancel [
	
	^ self iconsReference / 'cancel-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconForward [
	
	^ self iconsReference / 'next-1-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconHistory [
	
	^ self iconsReference / 'glasses-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconHome [
	
	^ self iconsReference / 'house-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconNewTab [
	
	^ self iconsReference / 'copy-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconOptions [
	
	^ self iconsReference / 'settings-1-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconRefresh [

	^ self iconsReference / 'reload-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconSettings [
	
	^ self iconsReference / 'settings-w24-h24.png'
]

{ #category : #'window definition' }
Scamper >> iconTabs [
	
	^ self iconsReference / 'copy-w24-h24.png'
]

{ #category : #menus }
Scamper >> iconsReference [

	^ self class iconsReference 
]

{ #category : #menus }
Scamper >> importBookmark [
	| newDirectory importLinks filename file |
	newDirectory := FillInTheBlank request: 'Directory to import' translated initialAnswer: self bookDir pathName.
	(newDirectory isNil or: [ newDirectory isEmpty ]) ifTrue: [ ^self ].
	(FileDirectory new directoryExists: newDirectory)
		ifTrue:[importLinks := self makeBookmark: (FileDirectory on: newDirectory).
				importLinks isEmpty 
					ifFalse:[importLinks associationsDo:[:ass | self bookmarks add: ass.
							(ass value isKindOf: Dictionary)
								ifTrue:[self createBookmarkFiles: self bookDir dict: ass value dirname: ass key]
								ifFalse:[filename := ass key,'.lin'.
										self bookDir deleteFileNamed: filename.
										file := StandardFileStream fileNamed: (self bookDir fullNameFor: filename).
										file ifNil:[self error: 'could not save file' translated].
										file nextPutAll: ass value asString. 
										file close]
								]
							].
				]
		ifFalse:[self importBookmark].

]

{ #category : #menus }
Scamper >> importUrl: aFile [
	| oldFile url strings position |
	oldFile := FileStream oldFileOrNoneNamed: aFile.
	oldFile isBinary 
		ifTrue:[ self error: 'not url file' translated]
		ifFalse:[ strings := (oldFile contentsOfEntireFile) substrings.
				strings do:[:sub |
				( sub includesSubstring: 'URL=')
					ifTrue:[ position := sub findString: 'http://'.
							position > 0 ifTrue:[url := sub copyFrom: position to: sub size]
										ifFalse:[ position := sub findString: 'ftp://'.
												position > 0 ifTrue:[url := sub copyFrom: position to: sub size].
												]
							]	
					].
				]. 
	url =='' ifTrue:[ self error: 'blank file: url not exist' translated].
	^url asZnUrl
]

{ #category : #initialization }
Scamper >> initialize [
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
	self status: 'sittin' translated.


]

{ #category : #initialization }
Scamper >> initializeMIMEDatabase [

	MIMEDocument resetMIMEdatabase.
"	MIMEDocument linkExtension: 'svg' toType: 'image/svg'."
]

{ #category : #'as yet unclassified' }
Scamper >> initializeTabs [

	| pair|
	
	self tabs ifNil: [self tabs: OrderedCollection new].
	self currentTab: 0.
	pair:= Array new: 2.
	pair at: 1 put: '';
		at: 2 put: self currentTab asString.
	self currentTab: 1.
	self tabs addLast: pair.
	self addTabButton.
	
]

{ #category : #menus }
Scamper >> inspectParseTree [
	"inspect a parse tree of the current page's source"
	document ifNotNil: [ document inspect ]
]

{ #category : #'change/update' }
Scamper >> invalidateLayout [
	
	self changeAll: #( backgroundColor formattedPage formattedPageSelection ).
]

{ #category : #testing }
Scamper >> isInternBrowserUrl: aUrl [

	^ ('browser:*' match: aUrl asString).
]

{ #category : #testing }
Scamper >> isLocalhostAdress: aString [

	^ 'http://localhost:*' match: aString
]

{ #category : #testing }
Scamper >> isSearchWords: aString [

	| asUrl |
	asUrl := aString asString asZnUrl.
	
	((self isUrl: aString) or: (self isInternBrowserUrl: aString)) ifTrue: [^false].
	
	(self isLocalhostAdress: aString) ifTrue: [^false].
	
	^ ('*.##*' match: aString) not 
	
]

{ #category : #testing }
Scamper >> isUrl: aUrl [

	^ ('http://*' match: aUrl asString) or: ['https://*' match: aUrl asString].
]

{ #category : #testing }
Scamper >> isWebBrowser [
	
	^ true.
]

{ #category : #'changing page' }
Scamper >> jumpToAbsoluteUrlAsync: urlText [
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
	
	

]

{ #category : #'changing page' }
Scamper >> jumpToNewUrl [
	"change to a new, user-specified page"
	| newUrl |
	newUrl := FillInTheBlank request: 'url to visit' translated initialAnswer: currentUrl asString.
	(newUrl isNil or: [ newUrl isEmpty ]) ifTrue: [ ^self ].
	self jumpToAbsoluteUrlAsync: newUrl.
]

{ #category : #'changing page' }
Scamper >> jumpToUrl: urlText [
	"this method is called by the framework on web browsers - therefore don't block"
	
	self jumpToAbsoluteUrlAsync: (urlText asUrlRelativeTo: currentUrl).

]

{ #category : #'changing page' }
Scamper >> jumpToUrlAsync: urlText [
	"start downloading a new page. The page source is downloaded in a background thread"
	
	
	^ self jumpToAbsoluteUrlAsync: (urlText / currentUrl).
	
]

{ #category : #access }
Scamper >> labelString [
	"return the title of the current page, or nil if there is none"

	document isNil
		ifTrue: [ ^ 'Scamper' ]
		ifFalse: [ ^ 'Scamper: ' , ((self titleOf: document) ifNil: [ '(untitled)' translated ]) ]
]

{ #category : #lint }
Scamper >> lint [
	"return a string describing any questionable HTML that was noticed in the current page"
	"(not currently very comprehensive)"
	document ifNil: [ ^'' ].
	^document lint
]

{ #category : #'user interface' }
Scamper >> loadBookmark [
	| directory favorite |
	favorite := 'Bookmark'.
	"directory := FileDirectory default.
	(directory directoryExists: favorite)
			ifTrue:[bookDir := directory directoryNamed: favorite.
					self bookmarks: (self makeBookmark: bookDir)
					]
			ifFalse:[directory createDirectory: favorite.
					bookDir := directory directoryNamed: favorite.
					self bookmarks: Dictionary new ].
	"

]

{ #category : #cookies }
Scamper >> longtimeCookies [ 

	^ LongtimeCookies
]

{ #category : #'user interface' }
Scamper >> makeBookmark: aDirectory [
	| directories dir book extension extension1|
	extension := '*.lin'.
	extension1 := '*.url'. " for IE favorite files"
	book := Dictionary new.
	directories := aDirectory directoryNames.
	directories isEmpty
		ifFalse:[directories do:[:dn |
					dir := aDirectory directoryNamed: dn.
					book add: ( Association key: dn value: ( self makeBookmark: dir))
					]].
	aDirectory fileNames do:
	[:fn | (extension match: fn)
				ifTrue:[ book add: (Association key: (fn truncateTo: (fn size - 4))
							value: (self readUrlFromFile: (aDirectory fullNameFor: fn)))].
		  (extension1 match: fn)
				ifTrue:[ book add: (Association key: (fn truncateTo: (fn size - 4))
							value: ( self importUrl: (aDirectory fullNameFor: fn)))].
	].
	^book
	
		
]

{ #category : #'browser urls' }
Scamper >> makeQueryArg: aString key: keyString [

	| query inputs |
	query := (keyString , '=').
	inputs := aString trimBoth.
	1 to: inputs size do: [:i |
		((inputs at: i) = Character space)
			ifTrue: [
				query := query , '+'] 
			ifFalse: [
				query := query , (inputs at: i) asString]].
	^query
]

{ #category : #menus }
Scamper >> menu: menu shifted: shifted [ 
	"added 'back' and 'forward' menu options: Aibek 4/18/99"
	| lines selections linePositions |
	lines := 'back
forward
new URL
history
view source
inspect parse tree
go to start page
edit start page
bookmark' translated.
	linePositions := #(2 4 6 ).
	selections := #(#back #forward #jumpToNewUrl #visitHistoryPage #viewSource #inspectParseTree #visitStartPage #editStartPage #visitBookmarksPage ).
	downloadingProcess
		ifNotNil: 
			[lines := lines , String cr , 'stop downloading' translated.
			linePositions := linePositions , selections size asOrderedCollection.
			selections := selections , #(#stopEverything )].
	menu
		labels: lines
		lines: linePositions
		selections: selections.
	^ menu
]

{ #category : #accessing }
Scamper >> menuHistory [
	^ menuHistory
]

{ #category : #accessing }
Scamper >> menuHistory: anObject [
	menuHistory := anObject
]

{ #category : #'window definition' }
Scamper >> morphicWindow [
	"Create and return a Morphic window for Scamper."
	| window |
	
	window := (SystemWindow labelled: 'Scamper')
		model: self;
		width: 800;
		height: 600;
		setProperty: #webBrowserView toValue: true;
		"URL edit pane and buttons"
		addMorph: self urlEditPane fullFrame: ((LayoutFrame identity bottomFraction: 0; bottomOffset: 40));		
		addMorph: self tabPane fullFrame: ((LayoutFrame identity bottomFraction: 0; topOffset: 40; bottomOffset: 80));
		"The web page pane"
		addMorph: self webContentsPane fullFrame: ((LayoutFrame identity topOffset: 100; bottomOffset: -20));	 
		"Status pane"	
		addMorph: self statusPane fullFrame: ((LayoutFrame identity topFraction: 1; topOffset: -20)).		
	
	self initializeTabs.
	
	window openInWorld.
	
	^ window.
		
	


]

{ #category : #creation }
Scamper >> openAsMorph [

	^ self morphicWindow asMorph. 

]

{ #category : #tabs }
Scamper >> openNewTab [

	self updateTab.
	self addTab.
	self visitStartPage.
	self updateTab.
]

{ #category : #'button text' }
Scamper >> openNewTabText [

	^ 'Open New Tab' translated.
]

{ #category : #tabs }
Scamper >> openTab: anIndex [
	
	self updateTab.
	self currentTab: anIndex.
	self webContentsPane show: ((self tabs at: anIndex) at: 1).
	self document: ((self tabs at: anIndex) at: 1).
	
	
]

{ #category : #menus }
Scamper >> optionsPanel [ 

	^ optionsPanel.
				
	

]

{ #category : #menus }
Scamper >> optionsPanelButtonPaneWithPosition: aPosition [

	| pane |
	
	pane := (AlignmentMorph new)
				borderWidth: 1;
				borderColor: (Color lightGray);
				layoutInset: 5;
				position: aPosition;
				listDirection: #topToBottom;
				color: (Color white);
				wrapCentering: #center;
				cellPositioning: #center;
				clipSubmorphs: true;
				width: self optionsPanelWidth;
				height: self optionsPanelHeight.
	
	pane
		addMorph: (self simpleIconicButtonNamed: 'Bookmarks' translated
						action:  #visitBookmarksPage  
						withIcon: ((ImageReadWriter formFromFileNamed:  
							(self iconBookmark asFileReference))));
		addMorph: (self simpleIconicButtonNamed: 'Add Site as a Bookmark' translated 
						action: #addToBookmark   
						withIcon: ((ImageReadWriter formFromFileNamed:
						(self iconAddBookmark asFileReference))));
		addMorph: (self simpleIconicButtonNamed: 'History' translated 
						action: #visitHistoryPage  
						withIcon: ((ImageReadWriter formFromFileNamed:  
							(self iconHistory asFileReference)))).
				
	^ pane.
				
	

]

{ #category : #menus }
Scamper >> optionsPanelButtonPanewithPosition: aPosition [

	| pane |
	
	pane := (AlignmentMorph new)
				borderWidth: 1;
				borderColor: (Color lightGray);
				layoutInset: 5;
				listDirection: #topToBottom;
				position: aPosition;
				color: (Color white);
				wrapCentering: #center;
				cellPositioning: #center;
				clipSubmorphs: true;
				width: self optionsPanelWidth;
				height: 120.
				
	
	pane
		addMorph: (self simpleIconicButtonNamed: 'Bookmarks' translated
						action:  #bookmarks 
						withIcon: ((ImageReadWriter formFromFileNamed:  
							(self iconBookmark asFileReference))));

		addMorph: (self simpleIconicButtonNamed: 'History' translated
						action:  #visitHistoryPage 
						withIcon: ((ImageReadWriter formFromFileNamed:  
							(self iconHistory asFileReference)))).
				.

	^ pane.
				
	

]

{ #category : #menus }
Scamper >> optionsPanelHeight [

	^ 120.
]

{ #category : #menus }
Scamper >> optionsPanelPosition [

	| posX posY |
	
	posX := (self webContentsPane fullBounds corner x) - (self optionsPanelWidth).
	posY := self webContentsPane position y. 

	^ (posX @ posY).
				
	

]

{ #category : #menus }
Scamper >> optionsPanelWidth [

	^ 50.
]

{ #category : #menus }
Scamper >> perform: selector orSendTo: otherTarget [
	"Selector was just chosen from a menu by a user.  If can respond, then
perform it on myself. If not, send it to otherTarget, presumably the
editPane from which the menu was invoked."

	(self respondsTo: selector)
		ifTrue: [^ self perform: selector]
		ifFalse: [^ otherTarget perform: selector]
]

{ #category : #'document handling' }
Scamper >> processDocument: aDocument [
	| backgroundColor formattedPage |
	aDocument == #stateDownloaded ifTrue: [ 
		"images and such have been downloaded; update the page"
		self status: 'reformatting page...' translated.
		formattedPage := document formattedTextForBrowser: self defaultBaseUrl: currentUrl.
		backgroundColor := Color fromString: document body bgcolor.
		self changeAll: #(backgroundColor formattedPage).
		self status: 'sittin' translated. ]
	ifFalse: [	
		self displayDocument: aDocument
	]
]

{ #category : #'document handling' }
Scamper >> processMidiPage: newSource [
	Smalltalk at: #MIDIFileReader ifPresent:
		[:reader |
		reader playStream: (RWBinaryOrTextStream with: newSource content) reset binary.
		self status: 'sittin' translated.
		^true].
	^false
]

{ #category : #'document handling' }
Scamper >> processUnhandledPage: newSource [
	"offer to save it to a file"

	| fileName file |
	self status: 'sittin' translated.
	(newSource url asString endsWith: '.pr')
		ifTrue:
			[ (self confirm: 'Looks like a Squeak project - do you want to load it as such?' translated)
				ifTrue: [ ^ ProjectLoading thumbnailFromUrl: newSource url asString ] ].
	(self
		confirm:
			('unkown content-type {1}--
Would you like to save to a file?' translated format: {newSource contentType}))
		ifFalse: [ ^ false ].
	fileName := ''.
	[ fileName := FillInTheBlank request: 'file to save in' translated initialAnswer: fileName.
	fileName isEmpty
		ifTrue: [ ^ self ].
	file := FileStream fileNamed: fileName.
	file isNil ] whileTrue.
	file reset.
	file binary.
	file nextPutAll: newSource content.
	file close.
	^ true
]

{ #category : #'user interface' }
Scamper >> readUrlFromFile: aFile [
	| oldFile url |
	oldFile := FileStream oldFileOrNoneNamed: aFile.
	oldFile isBinary 
		ifTrue:[ self error: 'not url file' translated]
		ifFalse:[url := (oldFile contentsOfEntireFile) trimBoth.
				url =='' ifTrue:[ self error: 'blank file: url not exist' translated].
				^url asZnUrl].
	
]

{ #category : #accessing }
Scamper >> recentDocuments [
	^ recentDocuments
]

{ #category : #accessing }
Scamper >> recentDocuments: anObject [
	recentDocuments := anObject
]

{ #category : #'window definition' }
Scamper >> refreshAndCancelButtonWithStatus: browserState [
	"Create and return a simple button with Scamper as the target."

	| iconAction iconForm |
	super initialize.
	"browserState := #status."
	
	(browserState asString isEmpty) ifTrue: [
		iconForm := self iconRefresh.
		iconAction := '#reload'.
		].
	
	(browserState asString = 'sittin') ifTrue: [
		iconForm := self iconRefresh.
		iconAction := '#reload'. 
		].
	
	^ IconicButton new
		target: self;
		labelGraphic: self iconRefresh;
		color: Color transparent;
		extent: 25 @ 25;
		borderWidth: 0;
		actionSelector: #reload;
		actWhen: #buttonUp;
		yourself.
		


]

{ #category : #'changing page' }
Scamper >> release [
	self stopEverything.
	super release.
]

{ #category : #menus }
Scamper >> reload [
	self stopEverything.
	self jumpToUrlAsync: currentUrl
	

]

{ #category : #accessing }
Scamper >> reloadAndStopButton [ 
	^ reloadAndStopButton. 
]

{ #category : #accessing }
Scamper >> reloadAndStopButton: anObject [
	reloadAndStopButton := anObject.
]

{ #category : #'button text' }
Scamper >> reloadButtonText [

	^ 'Reload page' translated.
]

{ #category : #accessing }
Scamper >> searchEngineUrl [
	^ searchEngineUrl ifNil: [searchEngineUrl :=  'http://google.com/search']
]

{ #category : #accessing }
Scamper >> searchEngineUrl: anObject [
	searchEngineUrl := anObject
]

{ #category : #cookies }
Scamper >> sessionCookies [

	^ sessionCookies
]

{ #category : #cookies }
Scamper >> sessionCookies: aCollection [

	sessionCookies := aCollection
]

{ #category : #lint }
Scamper >> showLint [
	(StringHolder new contents: self lint) openLabel: 'lint for ', self currentUrl printString.
]

{ #category : #tabs }
Scamper >> showTabs [
	| menu |
	menu := (MenuMorph entitled: ' Tabs ' translated)
				defaultTarget: self.
	menu addStayUpItem.
	menu addLine.
	menu
		add: 'New Tab' translated
		target: self
		selector: #openNewTab.
	menu addLine.
	self tabs ifNotNil: [ self tabs do: [:a | 
		menu
			add: (a at: 2) translated
			target: self
			selector: #openTab: 
			argument: (self tabs indexOf: a)]].
	menu addLine.
	menu
		add: 'Close All Tabs' translated
		target: self
		selector: #closeAllTabs.
	menu popUpInWorld: self currentWorld
]

{ #category : #'window definition' }
Scamper >> simpleButtonNamed: buttonLabel action: selector text: balloonText [
	"Create and return a simple button with Scamper as the target."

	^SimpleButtonMorph new
		label: buttonLabel;
		target: self;
		color: Color transparent;
		borderColor: Color black;
		actionSelector: selector;
		actWhen: #buttonUp;
		setBalloonText: balloonText;
		yourself

]

{ #category : #'window definition' }
Scamper >> simpleIconicButtonNamed: buttonLabel action: selector withIcon: iconForm [
	"Create and return a simple button with Scamper as the target."

	
	^IconicButton new
		"label: buttonLabel;"
		target: self;
		labelGraphic: iconForm;
		color: Color transparent;
		borderWidth: 0;
		extent: 35@35;
		"position: (50@50);"
		actionSelector: selector;
		actWhen: #buttonUp;
		yourself

]

{ #category : #'window definition' }
Scamper >> simpleIconicButtonNamed: buttonLabel action: selector withIcon: iconForm andVerticalPosition: aVerticalPosition [
	"Create and return a simple button with Scamper as the target."

	
	^IconicButton new
		"label: buttonLabel;"
		target: self;
		labelGraphic: iconForm;
		color: Color transparent;
		borderWidth: 0;
		extent: 35@35;
		position: (50@50);
		actionSelector: selector;
		actWhen: #buttonUp;
		yourself

]

{ #category : #'changing page' }
Scamper >> startDownloadingStateIn: aDocument  url: aUrl [
	"download the state for the given document in a background thread.  signal the foreground when the data has arrived"
	
	downloadingProcess := [	
		aDocument allSubentitiesDo: [ :e |
			e downloadState: aUrl ].
		documentQueue nextPut: #stateDownloaded.
		downloadingProcess := nil. ] newProcess.
	downloadingProcess resume.
]

{ #category : #'start page' }
Scamper >> startPage [
	"return the contents of the user's personal start page"
	
	| file |
	
	file := FileStream oldFileOrNoneNamed: 'StartPage.html'.
	file 
		ifNil: [ ^'<title>{1}</title>
<h1>{1}</h1>
{2}' format:{'Personal Start Page' translated. 'This space is empty' translated} ]
		ifNotNil: [ ^file contentsOfEntireFile ]
]

{ #category : #'start page' }
Scamper >> startPage: newPage [
	"fill in the contents of the user's personal start page"

	| file |
	
	FileDirectory default deleteFileNamed: 'StartPage.html'.
	[file := FileStream fileNamed: 'StartPage.html'.
	file ifNil: [self error: 'could not save file' translated].
	file nextPutAll: newPage asString.
	] ensure: [file close].
	self changed: #startPage.
	
	^ true.
]

{ #category : #access }
Scamper >> status [

	^ status.
]

{ #category : #access }
Scamper >> status: aSymbol [
	
	status := aSymbol.
	self changed: #status.
	(reloadAndStopButton = nil) 
		ifFalse: [ reloadAndStopButton changeBetweenReloadAndStopWithState: self status].
]

{ #category : #'window definition' }
Scamper >> statusPane [
	"Create and return the browser status pane."

	| pane |
	
	pane := (PluggableTextMorph on: self text: #status accept: nil)
			borderWidth: 0;
			color: (Color transparent).
	pane hideScrollBarsIndefinitely.
	
	^ pane.
]

{ #category : #stepping }
Scamper >> step [
	"check if a new document has arrived"
	| results |
	[documentQueue isEmpty] whileFalse: [
		results := documentQueue next.

		results == #stateDownloaded ifTrue: [ 
			"images and such have been downloaded; update the page"
			self status: 'reformatting page...' translated.
			formattedPage := document formattedTextForBrowser: self defaultBaseUrl: currentUrl.
			backgroundColor := Color fromString: document body bgcolor.
			self changeAll: #(backgroundColor formattedPage).
			self status: 'sittin' translated. ]
		 ifFalse: [		
			self displayDocument: results 	
		] ]
]

{ #category : #'button text' }
Scamper >> stopButtonText [

	^ 'Stop loading page' translated.
]

{ #category : #'changing page' }
Scamper >> stopEverything [
	"stop all background threads and empty queues for communicating with them; bring this Scamper to a sane state before embarking on something new"
	
	downloadingProcess ifNotNil: [
		downloadingProcess terminate.
		downloadingProcess := nil. ].

	[ documentQueue isEmpty ] whileFalse: [ documentQueue next ].

	self status: 'sittin' translated.
]

{ #category : #cookies }
Scamper >> storeCookies: aCollection [

	aCollection do: [:cookie |
		"valid expiry -> longtimeCookie"
		(cookie expiry notNil and: [cookie expiry > DateAndTime now]) ifTrue: [
			Scamper addLongtimeCookie: cookie].
		"no exiry -> session cookie"
		(cookie expiry isNil) ifTrue: [
			self addSessionCookie: cookie]].
		

	
]

{ #category : #'changing page' }
Scamper >> submitFormWithInputsAsync: inputs url: url method: method encoding: encoding [
	"Submit the given form with the provided inputs, url, method, and encoding"

	| newUrl |
	self stopEverything.
	(method asLowercase ~= 'get' and: [ method asLowercase ~= 'post' ])
		ifTrue:
			[ self inform: ('unknown FORM method: {1}' translated format: {method}).
			^ false ].
	newUrl := url asUrlRelativeTo: currentUrl.
	(newUrl scheme ~= 'http' and: [newUrl scheme ~= 'https'])
		ifTrue:
			[ self inform: 'I can only submit forms via HTTP/S' translated.
			^ false ].
	self status: 'submitting form...' translated.
	self addNextToRecentDocuments.
	
	^ (self downloadFromUrlAsync: newUrl withMethod: method andInputs: inputs andEncoding: encoding)
		then: [ :aDocument |
			WorldState addDeferredUIMessage: [ self processDocument: (MIMEDocument contentType: 'text/html' content: (aDocument content) url: newUrl)].
			self ]

]

{ #category : #menus }
Scamper >> switchOptionsPanel [
"Opens up on click a panel with several option buttons."

	(optionsPanel isNil) 
	ifTrue: [
	
	optionsPanel := (BorderedMorph new)
						position: self optionsPanelPosition;
						width: self optionsPanelWidth;
						height: self optionsPanelHeight;
						color: (Color white);
						borderWidth: 0;
						yourself. 
		
	optionsPanel addMorph: (self optionsPanelButtonPaneWithPosition: optionsPanel position).
	webPageMorph addMorph: optionsPanel.
	
	] ifFalse: [
		optionsPanel delete.
		optionsPanel := nil.
	].
				
	

]

{ #category : #'as yet unclassified' }
Scamper >> tabPane [


	tabPaneVariable:= (AlignmentMorph new)
		hResizing: #shrinkWrap;
		color: (Color r:1 g:1 b:1).
		
	tabPaneVariable addMorphBack: (self
		simpleIconicButtonNamed: 'new Tab' translated
		action: #openNewTab 
		withIcon:  ((ImageReadWriter formFromFileNamed: self iconNewTab asFileReference))).	
	
	^ tabPaneVariable.
]

{ #category : #accessing }
Scamper >> tabPaneVariable [
	^ tabPaneVariable
]

{ #category : #accessing }
Scamper >> tabPaneVariable: anObject [
	tabPaneVariable := anObject
]

{ #category : #accessing }
Scamper >> tabs [
	^ tabs
]

{ #category : #accessing }
Scamper >> tabs: anObject [
	tabs := anObject
]

{ #category : #'document handling' }
Scamper >> titleOf: aHtmlDocument [
	| titleNodes |
	titleNodes := aHtmlDocument nodesSelect: [:node | node tag = 'title'].
	titleNodes isEmpty
		ifTrue: [^nil]
		ifFalse: [^titleNodes first innerContents]
]

{ #category : #'document handling' }
Scamper >> updateRecentDocuments [
	"delete all elements in recentDocuments after currentUrlIndex"
	[recentDocuments size > currentUrlIndex] whileTrue: 
		[recentDocuments removeLast]

]

{ #category : #'as yet unclassified' }
Scamper >> updateTab [
	
	self tabs ifNil: [self initializeTabs].
	self tabs at: self currentTab put: self createTab.
]

{ #category : #'window definition' }
Scamper >> urlEditPane [
	"Create and return the URL edit pane."

	| pane paneUI paneURL |
	pane := AlignmentMorph new color: (Color r:1 g:1 b:1).
				
	paneURL := (PluggableTextMorph on: self text: #currentUrl accept: #jumpToAbsoluteUrlAsync:).
				
	paneUI := (AlignmentMorph new)
				color: (Color r:0.1 g:1 b:1).
				
	reloadAndStopButton := (ScamperButton new)
								selfChangeAction: #reload 
								Icon: (ImageReadWriter formFromFileNamed: self iconRefresh asFileReference)
								labelInfo: #status.
		
	pane 	
		addMorph: paneURL fullFrame: LayoutFrame identity;

		addMorph: (self 
					simpleIconicButtonNamed: 'Home' translated
					action: #visitStartPage
					withIcon:  (ImageReadWriter formFromFileNamed: self iconHome asFileReference));
		addTransparentSpacerOfSize: 5 @ 0;
		addMorph: (self 
					simpleIconicButtonNamed: 'Forward' translated 
					action: #forward
					withIcon:  (ImageReadWriter formFromFileNamed: self iconForward asFileReference));
		addTransparentSpacerOfSize: 5 @ 0;
		addMorph: (self 
					simpleIconicButtonNamed: 'Back' translated 
					action: #back
					withIcon: (ImageReadWriter formFromFileNamed: self iconBackward asFileReference));
		addTransparentSpacerOfSize: 5 @ 0;
		
		addMorphBack: reloadAndStopButton;
		addTransparentSpacerOfSize: 5 @ 0;
		addMorphBack: (self 
					simpleIconicButtonNamed: 'Options' translated 
					action: #switchOptionsPanel 
					withIcon:  (ImageReadWriter formFromFileNamed: self iconOptions asFileReference)).
					
	paneURL acceptOnCR: true.
	paneURL hideScrollBarsIndefinitely.
	
	^ pane. 
		
]

{ #category : #menus }
Scamper >> viewSource [
	"view the source HTML of this page"
	(StringHolder new contents: (pageSource withSqueakLineEndings)) openLabel: ('source for {1}' translated format: {currentUrl printString}).
]

{ #category : #menus }
Scamper >> visitBookmarksPage [
	self jumpToAbsoluteUrlAsync: 'browser:bookmarks'.
	^true
]

{ #category : #menus }
Scamper >> visitHistoryPage [
	self jumpToAbsoluteUrlAsync: 'browser:history'.
	^true
]

{ #category : #menus }
Scamper >> visitStartPage [
	self jumpToAbsoluteUrlAsync: StartUrl.

	^true

]

{ #category : #stepping }
Scamper >> wantsSteps [
	^ true
]

{ #category : #'window definition' }
Scamper >> webContentsPane [
	"Return the web page pane."

	^webPageMorph ifNil: [webPageMorph := WebPageMorph on: self.]
]

{ #category : #accessing }
Scamper >> webPageMorph [

	^ webPageMorph
]

{ #category : #accessing }
Scamper >> webPageMorph: aMorph [

	webPageMorph := aMorph
]

{ #category : #access }
Scamper >> workerCount [
	^self defaultWorkerCount 

]
