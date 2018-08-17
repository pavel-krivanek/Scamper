Extension { #name : #HtmlDOMNode }

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> addToFormatter: aFormatter [
	| newBlockMorph |
	self boxType == #inline ifTrue: [
		self startStyles: aFormatter.
		self children do: [:e | e addToFormatter: aFormatter ].
		self endStyles: aFormatter ].
	self boxType == #inlineBlock ifTrue: [
		self startStyles: aFormatter.
		newBlockMorph := self getHtmlBlockMorph.
		aFormatter addMorph: newBlockMorph.
		aFormatter incompleteMorphs addAll: newBlockMorph incompleteMorphs.
		self endStyles: aFormatter ]
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> addToHtmlMorph: aHtmlBlockMorph [	
	aHtmlBlockMorph addChild: self getHtmlBlockMorph.
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> applyComputedStylesTo: aHtmlMorph [

	| resolver |
	"can currently also be HtmlInlineMorph. HtmlInlineMorph should be refactored to also be HtmlMorph"
	resolver := CSSStyleResolver for: self.
	aHtmlMorph layoutStyles getComputedStylesFrom: resolver.
	aHtmlMorph layoutStyles apply.
	

	
	
	
	
		
	"resolver ifStyleNotNil: #float do: [ :float |
			(float = 'left') ifTrue: [ aHtmlBlockMorph layoutPolicy float: #left ].
			(float = 'right') ifTrue: [ aHtmlBlockMorph layoutPolicy float: #right ].
			]."
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> boxType [

	^ ((CSSStyleResolver for: self) getStyle: #display) ifNil: [ #inline ]
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> defaultBlockMorph [
	^ HtmlBlockMorph
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> flushBlockNode: blockNode to: aHtmlMorph [
	blockNode addToHtmlMorph: aHtmlMorph.
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> flushInlineNodes: inlineNodes to: aHtmlBlockMorph [

	| formatter htmlInlineMorph |
	inlineNodes ifNotEmpty: [
		formatter := HtmlFormatter preferredFormatterClass new.
		
		inlineNodes do: [ :node | node addToFormatter: formatter].
		htmlInlineMorph := formatter htmlInlineMorph.
		inlineNodes do: [ :node | node applyComputedStylesTo: htmlInlineMorph ].
		htmlInlineMorph text ifNotEmpty: [
			htmlInlineMorph nodes: inlineNodes copy.
			aHtmlBlockMorph addChild: htmlInlineMorph ].
		inlineNodes removeAll.
		"resolver := CSSStyleResolver for: (aHtmlBlockMorph node).
		resolver ifStyleNotNil: #align do: [ :align | htmlInlineMorph layoutPolicy textAlign: align ].
		resolver ifStyleNotNil: #float do: [ :float |
			(float = 'left') ifTrue: [ htmlInlineMorph layoutPolicy float: #left ].
			(float = 'right') ifTrue: [ htmlInlineMorph layoutPolicy float: #right ].
			]" ]. 

		
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> getHtmlBlockMorph [

	htmlMorph := self defaultBlockMorph newFor: self.
	self applyComputedStylesTo: htmlMorph.
	self renderChildrenInto: htmlMorph.
	
	
	^ htmlMorph
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> isRenderedInline [
	
	| boxType |
	isRenderedInline ifNotNil: [ :value | ^ value ].
	
	boxType := self boxType.
	boxType == #inlineBlock
		ifTrue: [ ^ isRenderedInline := true ].

	boxType == #inline
		ifFalse: [ ^ isRenderedInline := false ].
	
	self children
		ifEmpty: [ ^ isRenderedInline := true ]
		ifNotEmpty: [ ^ isRenderedInline := self children allSatisfy: [ :child | child isRenderedInline ]]
]

{ #category : #'*HTML-Formatters' }
HtmlDOMNode >> renderChildrenInto: aHtmlBlockMorph [
	| inlineNodes |
	
	inlineNodes := OrderedCollection new.
	self children do: [ :child | child isRenderedInline
			ifTrue: [ inlineNodes add: child ]
			ifFalse: [ self flushInlineNodes: inlineNodes to: aHtmlBlockMorph;
						flushBlockNode: child to: aHtmlBlockMorph] ].
	self flushInlineNodes: inlineNodes to: aHtmlBlockMorph
]
