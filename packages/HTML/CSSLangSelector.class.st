Class {
	#name : #CSSLangSelector,
	#superclass : #CSSPseudoClassSelector,
	#category : 'HTML-CSS'
}

{ #category : #accessing }
CSSLangSelector >> language [
	"Answer the value of language"

	^ self arguments
]
