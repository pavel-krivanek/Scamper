"
I represent the result of an asynchronous message.  Once the message is processed, I will be resolved to a value.  I am typically instantiated by invocations of #futureSend:at:args: (and not by #futureDo:atArgs:).

See class-comment of FutureNode.

I also implement the Promises/A+ Javascript specification. This allows you to chain my instances to perform arbitrarily complex asynchronous tasks with error handling baked in.

A Promise may be in one of three possible states: #pending, #fulfilled or #rejected. A Promise may move from #pending -> #fulfilled, or from #pending -> #rejected. No other state changes may occur. Once #fulfilled or #rejected, a Promise's value must change.
"
Class {
	#name : #Promise,
	#superclass : #Object,
	#instVars : [
		'onError',
		'value',
		'resolvers',
		'mutex',
		'state',
		'error',
		'rejectors',
		'rejecters'
	],
	#category : 'Scamper-Compatibility'
}

{ #category : #'instance creation' }
Promise class >> ifRejected: aBlock [
	^ Promise basicNew initializeWithIfRejected: aBlock.
]

{ #category : #'instance creation' }
Promise class >> unit: anObject [
	"Return a resolved Promise. #new is the other half of Promise's unit function; #new returns an unresolved Promise."
	^ Promise basicNew initializeWithResolvedValue: anObject.
]

{ #category : #accessing }
Promise >> error [
	^ error.
]

{ #category : #private }
Promise >> evaluateRejecter: rejecterBlock [
	^ rejecterBlock cull: error.
]

{ #category : #private }
Promise >> evaluateResolver: resolverBlock [
	^ resolverBlock cull: value.
]

{ #category : #monad }
Promise >> ifRejected: errBlock [
	^ self then: [:ignored | "Do nothing"] ifRejected: errBlock.
]

{ #category : #initialize }
Promise >> initialize [
	state := #pending.
	resolvers := #().
	rejecters := #().
	mutex := Mutex new.
]

{ #category : #initialize }
Promise >> initializeWithIfRejected: aBlock [
	self initialize.
	rejecters := {aBlock}.
]

{ #category : #initialize }
Promise >> initializeWithResolvedValue: anObject [
	self initialize.
	self resolveWith: anObject.
]

{ #category : #testing }
Promise >> isPromise [
	^ true.
]

{ #category : #testing }
Promise >> isRejected [
	^ state == #rejected.
]

{ #category : #testing }
Promise >> isResolved [
	^ state == #fulfilled.
]

{ #category : #printing }
Promise >> printOn: aStream [
	aStream nextPutAll: 'a Promise'.
	self isResolved ifTrue: [
		aStream
			nextPutAll: '(resolved: ';
			nextPutAll: value printString;
			nextPutAll: ')'].
	self isRejected ifTrue: [
		aStream
			nextPutAll: '(rejected: ';
			nextPutAll: error printString;
			nextPutAll: ')'].
]

{ #category : #resolving }
Promise >> rejectWith: anObject [
	"Reject this promise."
	mutex critical: [
		(state == #fulfilled) ifTrue: [self error: 'Promise was already resolved'].
		(state == #rejected) ifTrue: [self error: 'Promise was already rejected'].
		error := anObject.
		state := #rejected.
		rejecters do: [:r | self evaluateRejecter: r]].
]

{ #category : #resolving }
Promise >> resolveWith: arg [
	"Resolve this promise"
	mutex critical: [
		(state == #fulfilled) ifTrue: [self error: 'Promise was already resolved'].
		(state == #rejected) ifTrue: [self error: 'Promise was already resolved'].
		value := arg.
		state := #fulfilled.
		resolvers do: [:r |
			self evaluateResolver: r]].
]

{ #category : #monad }
Promise >> then: resolvedBlock [
	^ self then: resolvedBlock ifRejected: [:ignored | "Do nothing"].
]

{ #category : #monad }
Promise >> then: resolvedBlock ifRejected: errBlock [
	"Return a Promise that, if it resolves, runs the resolvedBlock. If resolution throws an Exception, it runs the errBlock."
	| p |
	p := Promise new.
	self whenResolved: [:v |
		[p resolveWith: (resolvedBlock value: v)]
			on: Error do: [:e | p rejectWith: e]].
	self whenRejected: [:e | p rejectWith: (errBlock value: e)].
	^ p.
]

{ #category : #accessing }
Promise >> value [
	^value
]

{ #category : #waiting }
Promise >> wait [
	"Wait unconditionally for this promise to resolve."
	| sema |
	sema := Semaphore new.
	self whenResolved:[sema signal].
	sema wait.
	^value
]

{ #category : #waiting }
Promise >> waitTimeoutMSecs: msecs [
	"Wait for at most the given number of milliseconds for this promise to resolve. Answer true if it is resolved, false otherwise."
	| sema delay |
	sema := Semaphore new.
	self whenResolved: [sema signal].
	delay := Delay timeoutSemaphore: sema afterMSecs: msecs.
	[sema wait] ensure: [delay unschedule].
	^ self isResolved.
]

{ #category : #waiting }
Promise >> waitTimeoutSeconds: seconds [
	"Wait for at most the given number of seconds for this promise to resolve. Answer true if it is resolved, false otherwise."
	^self waitTimeoutMSecs: seconds*1000
]

{ #category : #resolving }
Promise >> whenRejected: aBlock [
	"Evaluate aBlock when I am rejected"
	aBlock numArgs <= 1 ifFalse: [self error: 'Must be 0- or 1-argument block'].
	^ mutex critical: [
		rejecters := rejecters copyWith: aBlock.
		self isRejected ifTrue:[self evaluateRejecter: aBlock].
	]
]

{ #category : #resolving }
Promise >> whenResolved: aBlock [
	"Evaluate aBlock when I am resolved"
	aBlock numArgs <= 1 ifFalse:[self error: 'Must be 0- or 1-argument block'].
	^ mutex critical: [
		resolvers := resolvers copyWith: aBlock.
		self isResolved ifTrue:[self evaluateResolver: aBlock].
	]
]
