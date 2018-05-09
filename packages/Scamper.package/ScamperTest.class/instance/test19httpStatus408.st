as yet unclassified
test19httpStatus408

	| testUrl testString |
	
	"Naive Test if the title of the loaded page matches the title of the original error page."
	testUrl := 'browser:408' asZnUrl.
	testString := 'Scamper: Error 408'.

	(scamper model jumpToUrlAsync: testUrl asZnUrl) wait.
	scamper owner runStepMethods. 

	self assert: (scamper model labelString = testString).