testing
test05isUrl

	|url1 url2 url3|
	scamper := Scamper new.
	url1 := 'http://subdomain.domain.tld/something/apage' asZnUrl.
	url2 := 'https://subdomain.domain.tld/something/apage' asZnUrl.
	url3 := 'prot://subdomain.domain.tld/something/apage'asZnUrl.

	self assert: (scamper  isUrl: url1);
		 assert: (scamper  isUrl: url2);
		 assert: (scamper  isUrl: url3) not.
