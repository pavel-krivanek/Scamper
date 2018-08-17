"
I am a kind of Model that includes a piece of text.  In some cases, the text can be edited, and in some the text is a method.

Categories 'code pane menu' and 'message list menu' are messages that may be called by my menus when the text is a method, and when some pane is a list of methods.  Other of my subclasses may ignore these two catagories altogether.
"
Class {
	#name : #StringHolder,
	#superclass : #Model,
	#instVars : [
		'contents'
	],
	#category : 'Scamper-Compatibility'
}

{ #category : #'class initialization' }
StringHolder class >> initialize [
	"The class variables were initialized once, and subsequently filled with
	information. Re-executing this method is therefore dangerous." 
	 
	"workSpace := StringHolder new"

	"StringHolder initialize"
]

{ #category : #accessing }
StringHolder >> acceptContents: aString [ 
	"Set aString to be the contents of the receiver.  Return true cuz happy"

	self contents: aString.
	^ true
]

{ #category : #toolbuilder }
StringHolder >> annotation [
	^''
]

{ #category : #toolbuilder }
StringHolder >> buildCodePaneWith: builder [
	| textSpec |
	textSpec := builder pluggableTextSpec new.
	textSpec 
		model: self;
		getText: #contents; 
		setText: #contents:notifying:; 
		selection: #contentsSelection; 
		menu: #codePaneMenu:shifted:.
	^textSpec
]

{ #category : #toolbuilder }
StringHolder >> buildOptionalButtonsWith: builder [

	| panelSpec |
	panelSpec := builder pluggablePanelSpec new.
	panelSpec children: OrderedCollection new.
	self optionalButtonPairs do:[:spec|
		| buttonSpec |
		buttonSpec := builder pluggableActionButtonSpec new.
		buttonSpec model: self.
		buttonSpec label: spec first.
		buttonSpec action: spec second.
		spec size > 2 ifTrue:[buttonSpec help: spec third].
		panelSpec children add: buttonSpec.
	].
	panelSpec layout: #horizontal. "buttons"
	^panelSpec
]

{ #category : #toolbuilder }
StringHolder >> buildWindowWith: builder [
	| windowSpec |
	windowSpec := builder pluggableWindowSpec new.
	windowSpec model: self.
	windowSpec label: #labelString.
	windowSpec children: OrderedCollection new.
	^windowSpec
]

{ #category : #toolbuilder }
StringHolder >> buildWindowWith: builder specs: specs [
	| windowSpec |
	windowSpec := self buildWindowWith: builder.
	specs do:[:assoc|
		| rect action widgetSpec |
		rect := assoc key.
		action := assoc value.
		widgetSpec := action value.
		widgetSpec ifNotNil:[
			widgetSpec frame: rect.
			windowSpec children add: widgetSpec]].
	^windowSpec
]

{ #category : #toolbuilder }
StringHolder >> buildWith: builder [
	| windowSpec |
	windowSpec := 	self buildWindowWith: builder specs: {
		(0@0corner: 1@1) -> [self buildCodePaneWith: builder].
	}.
	^builder build: windowSpec
]

{ #category : #accessing }
StringHolder >> classCommentIndicated [
	"Answer true iff we're viewing the class comment."
	^false
]

{ #category : #'user edits' }
StringHolder >> clearUserEditFlag [
	"Clear the hasUnacceptedEdits flag in all my dependent views."

	self changed: #clearUserEdits
]

{ #category : #accessing }
StringHolder >> contents [
	"Answer the contents that the receiver is holding--presumably a string."

	^contents
]

{ #category : #accessing }
StringHolder >> contents: textOrString [ 
	"Set textOrString to be the contents of the receiver."

	contents := textOrString "asString"
]

{ #category : #accessing }
StringHolder >> contentsSelection [
	"Return the interval of text in the code pane to select when I set the pane's contents"

	^ 1 to: 0  "null selection"
]

{ #category : #'initialize-release' }
StringHolder >> defaultContents [

	^''
]

{ #category : #evaluation }
StringHolder >> doItContext [
	"Answer the context in which a text selection can be evaluated."

	^nil
]

{ #category : #evaluation }
StringHolder >> doItReceiver [
	"Answer the object that should be informed of the result of evaluating a 
	text selection."

	^nil
]

{ #category : #'initialize-release' }
StringHolder >> initialize [
	"Initialize the state of the receiver with its default contents."

	contents := self defaultContents.

]

{ #category : #toolbuilder }
StringHolder >> labelString [
	^self class name
]

{ #category : #accessing }
StringHolder >> noteAcceptanceOfCodeFor: aSelector [
	"A method has possibly been submitted for the receiver with aSelector as its selector; If the receiver wishes to take soem action here is a chance for it to do so"

]

{ #category : #'user edits' }
StringHolder >> okToChange [

	self canDiscardEdits ifTrue: [^ true].
	self changed: #wantToChange.  "Solicit cancel from view"
	^ self canDiscardEdits

]

{ #category : #toolbuilder }
StringHolder >> optionalButtonPairs [
	"Answer a tuple (formerly pairs) defining buttons, in the format:
			button label
			selector to send
			help message"
	^#()
]

{ #category : #accessing }
StringHolder >> reformulateList [
	"If the receiver has a way of reformulating its message list, here is a chance for it to do so"
]

{ #category : #accessing }
StringHolder >> reformulateListNoting: newSelector [
	"A method has possibly been submitted for the receiver with newSelector as its selector; If the receiver has a way of reformulating its message list, here is a chance for it to do so"

	^ self reformulateList
]

{ #category : #accessing }
StringHolder >> selectedClassName [
	"I may know what class is currently selected"

	self selectedClass ifNotNil: [^ self selectedClass name].
	^ nil
]

{ #category : #accessing }
StringHolder >> selectedClassOrMetaClass [

	^ self selectedClass	"I don't know any better"
]

{ #category : #accessing }
StringHolder >> selectedMessageName [

	^ nil
]

{ #category : #accessing }
StringHolder >> textContents: aStringOrText [ 
	"Set aStringOrText to be the contents of the receiver."

	contents := aStringOrText
]
