module "ModifiedPhysics", [ "Vec2" ], ( Vec2 ) ->
	module =
		parameters:
			collisionResponse:
				k: 10000
				b: 0

		createBody: ->
			body =
				position    : [ 0, 0 ]
				velocity    : [ 0, 0 ]
				acceleration: [ 0, 0 ]

				orientation    : 0
				angularVelocity: 0

				forces: []
				mass  : 1

				timeDilation: 1

		integrateOrientation: ( bodies, passedTimeInS ) ->
			for entityId, body of bodies
				body.orientation += body.angularVelocity * passedTimeInS

		update: ( bodies, passedTimeInS, integrate ) ->
			integrate( bodies, passedTimeInS )
			module.integrateOrientation( bodies, passedTimeInS )
