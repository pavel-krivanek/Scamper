parsing
readColorFrom: aProperty to: aContext

	(Color fromHTMLString: aProperty propertyString) 
		ifNotNil: [ :color | self put: color at: #color to: aContext ]