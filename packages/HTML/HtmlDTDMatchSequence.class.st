Class {
	#name : #HtmlDTDMatchSequence,
	#superclass : #HtmlDTDMatchGroup,
	#category : 'HTML-Validator'
}

{ #category : #accessing }
HtmlDTDMatchSequence >> separator [

	^','
]

{ #category : #matching }
HtmlDTDMatchSequence >> validateChildren: aStream ofNode: aNode [

	expression do:
	[:ea | 
		
		(ea validateChildren: aStream ofNode: aNode) ifFalse: [^false]
	].
	^true
]
