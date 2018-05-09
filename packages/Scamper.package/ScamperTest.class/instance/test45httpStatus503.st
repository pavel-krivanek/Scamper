as yet unclassified
test45httpStatus503

	| testUrl testString |
	
	"Naive Test if the title of the loaded page matches the title of the original error page."
	testUrl := 'browser:503' asZnUrl.
	testString := 'Scamper: Error 503'.

	(scamper model jumpToUrlAsync: testUrl asZnUrl) wait.
	scamper owner runStepMethods. 

	self assert: (scamper model labelString = testString).