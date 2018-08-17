"
Tests here do not require a Scamper instance to open (viable for Test Auto Runner).

"
Class {
	#name : #ScamperUnitTest,
	#superclass : #TestCase,
	#instVars : [
		'scamper'
	],
	#category : 'Scamper-Tests'
}

{ #category : #testing }
ScamperUnitTest >> test03DocumentWithoutTitleTagShouldntRaiseErrors [
	| document |

	document := HtmlDocument new parseContents: (ReadStream on: 'No title here').
	self shouldnt: [Scamper new titleOf: document] raise: Error.
]

{ #category : #testing }
ScamperUnitTest >> test05isSearchWords [

	| s1 s2 s3 s4 |
	scamper := Scamper new.
	
	s1 := 'hpi bestes informatikinstitut deutschlands' .
	s2 := 'www.hpi.de' .
	s3 := 'http://localhost:5050/index'.
	s4 := 'http://google.com/search'.

	self assert: (scamper isSearchWords:  s1);
		 assert: (scamper isSearchWords:  s2) not;
		 assert: (scamper isSearchWords:  s3) not;
		assert: (scamper isSearchWords:  s4) not.
]

{ #category : #testing }
ScamperUnitTest >> test05isUrl [

	|url1 url2 url3|
	scamper := Scamper new.
	url1 := 'http://subdomain.domain.tld/something/apage' asZnUrl.
	url2 := 'https://subdomain.domain.tld/something/apage' asZnUrl.
	url3 := 'prot://subdomain.domain.tld/something/apage'asZnUrl.

	self assert: (scamper  isUrl: url1);
		 assert: (scamper  isUrl: url2);
		 assert: (scamper  isUrl: url3) not.

]

{ #category : #testing }
ScamperUnitTest >> test06isInternBrowser [

	|url1 url2|
	
	scamper := Scamper new.
	url1 := 'browser:something' asUrl.
	url2 := 'something:something' asUrl.

	self assert: (scamper isInternBrowserUrl: url1); 
		 assert: (scamper isInternBrowserUrl: url2) not.

]

{ #category : #testing }
ScamperUnitTest >> test07intializeMIMEDatabase [

	self assert: (MIMEDocument guessTypeFromExtension: 'html') equals: 'text/html'.
	self assert: (MIMEDocument guessTypeFromExtension: 'png') equals: 'image/png'.
	self assert: (MIMEDocument guessTypeFromExtension:  'svg') equals: 'image/svg'.
]

{ #category : #testing }
ScamperUnitTest >> test09ScamperAppsbar [ 

	| appList |
	
	Scamper install.
	appList := TheWorldMenu registeredOpenCommands.
	self assert: 
		(appList contains: [ :each| each = {'Scamper' . {Scamper . #open}} ]).
]

{ #category : #testing }
ScamperUnitTest >> testFormsSubmitOnEnter [
	
	| evt form input |
	form := FormInputSetStub new.
	input := PluggableTextMorphSubmitOnEnter on: StringHolder new text: #contents accept: #acceptContents: acceptTarget: form acceptAction: #submitAsync. 
	evt := KeyboardEvent new setType: #keyStroke buttons: 0 position: nil keyValue: 13 hand: nil stamp: nil. "keyStroke enter"
	self assert: (form submittedCount = 0).
	input keyStroke: evt.
	self assert: (form submittedCount = 1)
	

]

{ #category : #testing }
ScamperUnitTest >> testMakeQueryArgWithKey [

	| in1 in2 in3 |
	scamper := Scamper new.
	in1 := 'hpi gutes institut'.
	in2 := '  hpi   '.
	in3 := 'hpigutesinstitut'.
	
	self assert: 'q=hpi+gutes+institut' equals: (scamper makeQueryArg: in1 key: 'q').
	self assert: 'q=hpi' equals: (scamper makeQueryArg: in2 key: 'q').
	self assert: 'q=hpigutesinstitut' equals: (scamper makeQueryArg: in3 key: 'q').
	 
]
