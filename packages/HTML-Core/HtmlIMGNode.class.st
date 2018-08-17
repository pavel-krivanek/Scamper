Class {
	#name : #HtmlIMGNode,
	#superclass : #HtmlDOMNode,
	#category : #'HTML-Core-DOM'
}

{ #category : #accessing }
HtmlIMGNode >> alt [
	^self attributes at: 'alt' ifAbsent: ['[image]']
]

{ #category : #accessing }
HtmlIMGNode >> imageExtent [
	"the image extent, according to the WIDTH and HEIGHT attributes.  returns nil if either WIDTH or HEIGHT is not specified"
	| widthText heightText |
	widthText := self attributes at: 'width' ifAbsent: [ ^nil ].
	heightText := self attributes at: 'height' ifAbsent: [ ^nil ].
	^ [ widthText asNumber @ heightText asNumber ] ifError: [ :a :b | nil ]
]

{ #category : #accessing }
HtmlIMGNode >> src [
	^self attributes at: 'src' ifAbsent: [nil]
]

{ #category : #accessing }
HtmlIMGNode >> tag [
	^ 'img'
]
