Class {
	#name : #CSSBorderStyleValue,
	#superclass : #CSSValue,
	#category : #'HTML-Core-CSS'
}

{ #category : #accessing }
CSSBorderStyleValue >> isValid [

^#( 'none'
	'hidden'
	'dotted'
	'dashed'
	'solid'
	'double'
	'groove'
	'ridge'
	'inset'
	'outset') includes: self valueString trimBoth

]
