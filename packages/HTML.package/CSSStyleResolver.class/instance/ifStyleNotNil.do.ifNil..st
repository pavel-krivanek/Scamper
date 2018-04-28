resolution
ifStyleNotNil: attributeKey do: aBlock ifNil: anotherBlock

	(self getStyle: attributeKey) ifNil: [^anotherBlock value] ifNotNil: [ :attribValue | ^aBlock value: attribValue ]