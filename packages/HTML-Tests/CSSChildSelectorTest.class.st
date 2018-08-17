Class {
	#name : #CSSChildSelectorTest,
	#superclass : #TestCase,
	#category : #'HTML-Tests-CSS'
}

{ #category : #testing }
CSSChildSelectorTest >> test01NodeWithoutParentShouldntRaiseErrors [
	| selector |
	selector := CSSSelector fromString: 'a>*'.
	self shouldnt: [selector matches: HtmlDocument new] raise: Error
]
