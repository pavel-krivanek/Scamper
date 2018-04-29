rendering
addToFormatter: formatter
	| morph url |
	self src isNil ifTrue: [ ^self ].
	url := self src.
	url := url asZnUrl asUrlRelativeTo: self document url asZnUrl.
	morph := DownloadingImageMorph new.
	morph defaultExtent: self imageExtent.
	morph altText: self alt.
	morph url: url.
	
	formatter addIncompleteMorph: morph.