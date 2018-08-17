"
Tests here do require a Scamper instance to open, eg running a test will open a Scamper window (not viable for Test Auto Runner).
"
Class {
	#name : #ScamperTest,
	#superclass : #TestCase,
	#instVars : [
		'scamper'
	],
	#category : 'Scamper-Tests'
}

{ #category : #'initialize-release' }
ScamperTest >> setUp [

	scamper := Scamper openOnUrl: 'browser:about'.
]

{ #category : #'initialize-release' }
ScamperTest >> tearDown [

	scamper delete.
]

{ #category : #'initialize-release' }
ScamperTest >> test01jumpToRelativeUrl [

	| port server|
	
	"randomize port to minize risk of clushing tests"
	port := (10000 to: 50000) atRandom.
	server := WebServer new listenOn: port.

	"add landing page"
	server addService: '/' action:[:req | 
		req send200Response: 'ok' contentType: 'text/plain'
	].

	"add relative page"
	server addService: '/relative_page' action:[:req | 
		req send200Response: 'ok' contentType: 'text/plain'
	].

	(scamper model jumpToAbsoluteUrlAsync: ('http://localhost:', port asString, '/')) wait.
	1 second asDelay wait.
	scamper owner runStepMethods.
	

	(scamper model jumpToUrlAsync: 'relative_page') wait.
	1 second asDelay wait.
	scamper owner runStepMethods.
	
	self assert: (scamper model currentUrl asString) = ('http://localhost:', port asString, '/relative_page').

	server ifNotNil:[server destroy]
]

{ #category : #'initialize-release' }
ScamperTest >> test02submitForm [

	| server port scamper button form resultText |
	port := (10000 to: 50000) atRandom.
	server := ScamperMockServer new listenOn: port.
	server addSubmitFormService.
	scamper := Scamper openOnUrl: 'http://localhost:', port, '/submitForm'.
	scamper owner runStepMethods.
	
	button := scamper model webContentsPane allMorphs detect: 
		[:morph | (morph respondsTo: #label) and: [ morph label = ' Absenden ']].
	form := button model. 
	form submitAsync wait.
	scamper owner runStepMethods.
	
	resultText := (scamper model webContentsPane allMorphs detect: [:morph | morph isTextMorph ]) text.
	self assert: resultText withSqueakLineEndings equals: 'Scamper4ever! aString /aString/' asText.
	server destroy.
	scamper delete.
]

{ #category : #'initialize-release' }
ScamperTest >> test08AddBookmark [
	| server port browser |
      
	port := (10000 to: 50000) atRandom.
	server := ScamperMockServer new listenOn: port.
	server addPageWithTitleTest.
	browser := Scamper openOnUrl: 'http://localhost:', port, '/testpage'.
	1 second asDelay wait.
	browser owner runStepMethods.
	browser model addToBookmark.
	self assert: 
		(browser model bookmarks keys contains: [ :bm | bm = 'Test']).
	server destroy.
	browser delete.
]

{ #category : #'initialize-release' }
ScamperTest >> test11DisplayHistory [


	| doc |
	doc   := MIMEDocument contentType: 'text/html' content: 'test' url:'test.de'.
	scamper model recentDocuments add: doc.
	scamper model displayHistory.
	scamper model menuHistory delete.

	self assert: ((scamper model menuHistory submorphs select: [:s |
		s isKindOf: MenuItemMorph ]) anySatisfy: [:m |^ m contents = doc url]).
	self assert: ((scamper model menuHistory submorphs select: [:s |
		s isKindOf: MenuItemMorph ]) noneSatisfy:  [:m |^ m contents ~ doc url]).

	
]

{ #category : #'initialize-release' }
ScamperTest >> test12ForwardButton [

	| doc1 doc2 | 
	
	doc1   := MIMEDocument contentType: 'text/html' content: 'test'.
	doc2 := MIMEDocument contentType: 'text/html' content: 'test2'.
	scamper model recentDocuments add: doc1.
	scamper model recentDocuments add: doc2.
	scamper model currentUrlIndex: 1.
	scamper model forward.
	self assert: scamper model currentUrlIndex equals:  2.
	
	
	
	
]

{ #category : #'initialize-release' }
ScamperTest >> test13BackButton [

	scamper model currentUrlIndex: 2.
	scamper model back.
	self assert: scamper model currentUrlIndex equals: 1
]

{ #category : #'initialize-release' }
ScamperTest >> testDefaultBackgroundColor [

	self assert: (scamper model defaultBackgroundColor = Color white).
	self assert: (scamper model backgroundColor = Color white)
]
