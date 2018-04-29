as yet unclassified
test38httpStatus428

	| testUrl testString |
	
	"Naive Test if the title of the loaded page matches the title of the original error page."
	testUrl := 'browser:428' asZnUrl.
	testString := 'Scamper: Error 428'.

	(scamper model jumpToUrlAsync: testUrl asZnUrl) wait.
	scamper owner runStepMethods. 

	self assert: (scamper model labelString = testString).