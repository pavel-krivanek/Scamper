find-select
findReplaceService
	^ findReplaceService ifNil: [ self defaultFindReplaceServiceClass newFor: self ]