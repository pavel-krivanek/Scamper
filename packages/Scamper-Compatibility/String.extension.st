Extension { #name : #String }

{ #category : #'*Scamper-Compatibility' }
String >> asUrlRelativeTo: url [

	^ self asZnUrl asUrlRelativeTo: url
]
