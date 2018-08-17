Extension { #name : #ZnUrl }

{ #category : #'*Scamper-Compatibility' }
ZnUrl >> asText [

	^ self asString asText
]

{ #category : #'*Scamper-Compatibility' }
ZnUrl >> asUrlRelativeTo: url [

	^ url asZnUrl / self
]

{ #category : #'*Scamper-Compatibility' }
ZnUrl class >> combine: url withRelative: href [

	^ url asZnUrl / href asZnUrl asRelativeUrl
]
