matching
validateChildren: aStream ofNode: aNode

	[expression validateChildren: aStream ofNode: aNode] whileTrue:[].
	^true