module "Satellites", [ "ModifiedPhysics", "Vec2" ], ( Physics, Vec2 ) ->
	nextEntityId = 0

	timeDilationMinDistance = 50
	killerRange = 45

	module =
		createKiller: ( args ) ->
			body = Physics.createBody()
			body.position = args.position
			body.velocity = args.velocity

			entity =
				id: "satellite#{ nextEntityId += 1 }"
				components:
					"bodies": body
					"satellites": {}

		handleNearbyAliens: ( satellites, aliens, bodies ) ->
			targets = []

			for satelliteId, satellite of satellites
				for alienId, alien of aliens
					satelliteBody = bodies[ satelliteId ]
					alienBody     = bodies[ alienId     ]

					satelliteToAlien = Vec2.copy( satelliteBody.position )
					Vec2.subtract( satelliteToAlien, alienBody.position )
					squaredDistance = Vec2.squaredLength( satelliteToAlien )

					timeDilationHasToReset =
						squaredDistance <=
						timeDilationMinDistance*timeDilationMinDistance

					if timeDilationHasToReset
						satelliteBody.timeDilation = 1.0
