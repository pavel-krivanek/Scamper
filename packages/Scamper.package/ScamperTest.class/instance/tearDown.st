initialize-release
tearDown

	scamper ifNil: [ Transcript showln: 'scamper is nil!' ] ifNotNil: [ scamper delete ].
