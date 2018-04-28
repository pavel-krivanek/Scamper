resolution
ifStyleNotNil: attributeKey do: aBlock

	(self getStyle: attributeKey) ifNotNil: [ :attribValue | ^aBlock value: attribValue ]