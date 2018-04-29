as yet unclassified
test43httpStatus501

	| testUrl testString |
	
	"Naive Test if the title of the loaded page matches the title of the original error page."
	testUrl := 'browser:501' asZnUrl.
	testString := 'Scamper: Error 501'.

	(scamper model jumpToUrlAsync: testUrl asZnUrl) wait.
	scamper owner runStepMethods. 

	self assert: (scamper model labelString = testString).