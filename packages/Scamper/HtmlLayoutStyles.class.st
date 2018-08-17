Class {
	#name : #HtmlLayoutStyles,
	#superclass : #Object,
	#instVars : [
		'width',
		'height',
		'marginTop',
		'marginRight',
		'marginBottom',
		'marginLeft',
		'paddingTop',
		'paddingRight',
		'paddingBottom',
		'paddingLeft',
		'borderWidthTop',
		'borderWidthRight',
		'borderWidthBottom',
		'borderWidthLeft',
		'borderColor',
		'float',
		'textAlign',
		'htmlMorph'
	],
	#category : 'Scamper-HTML-Morphs'
}

{ #category : #'instance creation' }
HtmlLayoutStyles class >> newFor: aHtmlMorph [

	| new |
	new := HtmlLayoutStyles new. 
	new htmlMorph: aHtmlMorph.
	^new
]

{ #category : #'applying styles' }
HtmlLayoutStyles >> apply [
	"modify the morph to fit to the styles. padding, borderwidth, bordercolor..."
	
	self height ifNotNil: [:h | self htmlMorph height: h].
	self width ifNotNil: [:w | self htmlMorph setWidth:w].
	
	
]

{ #category : #accessing }
HtmlLayoutStyles >> borderColor [
	^ borderColor
]

{ #category : #accessing }
HtmlLayoutStyles >> borderColor: anObject [
	borderColor := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> borderWidthBottom [
	^ borderWidthBottom ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> borderWidthBottom: anObject [
	borderWidthBottom := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> borderWidthLeft [
	^ borderWidthLeft ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> borderWidthLeft: anObject [
	borderWidthLeft := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> borderWidthRight [
	^ borderWidthRight ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> borderWidthRight: anObject [
	borderWidthRight := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> borderWidthTop [
	^ borderWidthTop ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> borderWidthTop: anObject [
	borderWidthTop := anObject
]

{ #category : #convenience }
HtmlLayoutStyles >> contentOffset [
	^(self borderWidthLeft + self paddingLeft) @ (self borderWidthTop + self paddingTop) 
]

{ #category : #convenience }
HtmlLayoutStyles >> extraHeight [

	^ self paddingTop + self paddingBottom + self borderWidthBottom + self borderWidthTop + self marginBottom + self marginTop
]

{ #category : #convenience }
HtmlLayoutStyles >> extraHeightTop [

	^ self paddingTop + self borderWidthTop + self marginTop
]

{ #category : #convenience }
HtmlLayoutStyles >> extraMarginHeight [

	^ self marginTop + self marginBottom
]

{ #category : #convenience }
HtmlLayoutStyles >> extraMarginWidth [

	^ self marginLeft + self marginRight
]

{ #category : #convenience }
HtmlLayoutStyles >> extraWidth [

	^ self paddingLeft + self paddingRight + self borderWidthLeft + self borderWidthRight + self marginLeft + self marginRight
]

{ #category : #convenience }
HtmlLayoutStyles >> extraWidthLeft [

	^ self paddingLeft  + self borderWidthLeft + self marginLeft
]

{ #category : #'getting styles' }
HtmlLayoutStyles >> getBorderWidthFrom: aResolver [

	aResolver ifStyleNotNil: 'border-top-width' do: [ :borderWidth | self borderWidthTop: borderWidth ];
		ifStyleNotNil: 'border-right-width' do: [ :borderWidth | self borderWidthRight: borderWidth ];
		ifStyleNotNil: 'border-bottom-width' do: [ :borderWidth | self borderWidthBottom: borderWidth ];
		ifStyleNotNil: 'border-left-width' do: [ :borderWidth | self borderWidthLeft: borderWidth ].
]

{ #category : #'getting styles' }
HtmlLayoutStyles >> getComputedStylesFrom: aResolver [

	self getPaddingFrom: aResolver.
	self getMarginFrom: aResolver.
	self getBorderWidthFrom: aResolver.
	self getTextAlignFrom: aResolver.
	self getHeightWidthFrom: aResolver.
]

{ #category : #'getting styles' }
HtmlLayoutStyles >> getHeightWidthFrom: aResolver [

	aResolver ifStyleNotNil: 'height' do: [ :h | self height: h ];
		ifStyleNotNil: 'width' do: [ :w| self width: w ].
]

{ #category : #'getting styles' }
HtmlLayoutStyles >> getMarginFrom: aResolver [

	aResolver ifStyleNotNil: 'margin-top' do: [ :margin | self marginTop: margin ];
		ifStyleNotNil: 'margin-right' do: [ :margin | self marginRight: margin ];
		ifStyleNotNil: 'margin-bottom' do: [ :margin | self marginBottom: margin ];
		ifStyleNotNil: 'margin-left' do: [ :margin | self marginLeft: margin ].
]

{ #category : #'getting styles' }
HtmlLayoutStyles >> getPaddingFrom: aResolver [

	aResolver ifStyleNotNil: 'padding-top' do: [ :padding | self paddingTop: padding ];
		ifStyleNotNil: 'padding-right' do: [ :padding | self paddingRight: padding ];
		ifStyleNotNil: 'padding-bottom' do: [ :padding | self paddingBottom: padding ];
		ifStyleNotNil: 'padding-left' do: [ :padding | self paddingLeft: padding ].
]

{ #category : #'getting styles' }
HtmlLayoutStyles >> getTextAlignFrom: aResolver [

	
	aResolver ifStyleNotNil: #textAlign do: [ :align | self textAlign: align ].
]

{ #category : #accessing }
HtmlLayoutStyles >> height [
	^ height 
]

{ #category : #accessing }
HtmlLayoutStyles >> height: anObject [
	height := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> htmlMorph [
	^ htmlMorph
]

{ #category : #accessing }
HtmlLayoutStyles >> htmlMorph: anObject [
	htmlMorph := anObject
]

{ #category : #convenience }
HtmlLayoutStyles >> innerExtraWidth [

	^ self paddingLeft + self paddingRight + self borderWidthLeft + self borderWidthRight 
]

{ #category : #accessing }
HtmlLayoutStyles >> marginBottom [
	^ marginBottom ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> marginBottom: anObject [
	marginBottom := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> marginLeft [
	^ marginLeft ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> marginLeft: anObject [
	marginLeft := anObject
]

{ #category : #convenience }
HtmlLayoutStyles >> marginLeftTopAsPoint [
	
	^self marginLeft @ self marginTop 
]

{ #category : #accessing }
HtmlLayoutStyles >> marginRight [
	^ marginRight ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> marginRight: anObject [
	marginRight := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> marginTop [
	^ marginTop ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> marginTop: anObject [
	marginTop := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> paddingBottom [
	^ paddingBottom ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> paddingBottom: anObject [
	paddingBottom := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> paddingLeft [
	^ paddingLeft ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> paddingLeft: anObject [
	paddingLeft := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> paddingRight [
	^ paddingRight ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> paddingRight: anObject [
	paddingRight := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> paddingTop [
	^ paddingTop ifNil: [ 0 ]
]

{ #category : #accessing }
HtmlLayoutStyles >> paddingTop: anObject [
	paddingTop := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> textAlign [
	^ textAlign
]

{ #category : #accessing }
HtmlLayoutStyles >> textAlign: anObject [
	textAlign := anObject
]

{ #category : #accessing }
HtmlLayoutStyles >> width [
	^ width 
]

{ #category : #accessing }
HtmlLayoutStyles >> width: anObject [
	width := anObject
]
