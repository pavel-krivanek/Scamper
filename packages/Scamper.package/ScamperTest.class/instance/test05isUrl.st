initialize-release
test05isUrl

	|url1 url2 url3|
	url1 := 'http://subdomain.domain.tld/something/apage' asZnUrl.
	url2 := 'https://subdomain.domain.tld/something/apage' asZnUrl.
	url3 := 'prot://subdomain.domain.tld/something/apage'asZnUrl.

	self assert: (scamper model isUrl: url1);
		 assert: (scamper model isUrl: url2);
		 assert: (scamper model isUrl: url3) not.