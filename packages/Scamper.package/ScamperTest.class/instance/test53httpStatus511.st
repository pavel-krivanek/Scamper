as yet unclassified
test53httpStatus511

	| testUrl testString |
	
	"Naive Test if the title of the loaded page matches the title of the original error page."
	testUrl := 'browser:511' asZnUrl.
	testString := 'Scamper: Error 511'.

	(scamper model jumpToUrlAsync: testUrl asZnUrl) wait.
	scamper owner runStepMethods. 

	self assert: (scamper model labelString = testString).