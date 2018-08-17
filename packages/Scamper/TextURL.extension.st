Extension { #name : #TextURL }

{ #category : #'*Scamper' }
TextURL >> actOnClick: anEvent for: anObject in: paragraph editor: editor [
		
	(anObject isKindOf: Morph) ifTrue: [
			| m |
			m := anObject.
			[ m ~= nil ] whileTrue: [
				(m isWebBrowser) ifTrue: [
					m  jumpToUrl: url.
					^true ].
				(m hasProperty: #webBrowserView) ifTrue: [
					m model jumpToUrl: url.
					^true ].
				m := m owner. ]
		].

]
