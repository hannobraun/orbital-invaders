module "Satellites", [ "ModifiedPhysics", "Vec2", "Orbits", "Gravitation" ], ( Physics, Vec2, Orbits, Gravitation ) ->
	nextEntityId = 0

	timeDilationMinDistance = 50

	killerRange      = 45
	killerDamagePerS = 1

	module =
		createKiller: ( args ) ->
			body = Physics.createBody()
			body.position = args.position
			body.velocity = args.velocity

			entity =
				id: "satellite#{ nextEntityId += 1 }"
				components:
					"bodies": body
					"satellites":
						targets: []

		launchSatellite: ( orbit, game, createEntity ) ->
			[ position, velocity ] = Orbits.stateVectorsAtPeriapsis(
				orbit,
				Gravitation.mu )

			createEntity( "satellite", {
				position: position
				velocity: velocity } )

		modifyTimeDilation: ( satelliteId, offset, bodies, satellites ) ->
			if satellites[ satelliteId ]?
				body = bodies[ satelliteId ]

				body.timeDilation += offset

				body.timeDilation = Math.max( 0.5, body.timeDilation )
				body.timeDilation = Math.min( 3.0, body.timeDilation )

		handleNearbyAliens: ( satellites, aliens, bodies ) ->
			for satelliteId, satellite of satellites
				satellite.targets.length = 0

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

					alienWithinReach =
						squaredDistance <= killerRange*killerRange

					if alienWithinReach
						satellite.targets.push( alienId )

		handleTargets: ( satellites, aliens, passedTimeInS ) ->
			for satelliteId, satellite of satellites
				for targetId in satellite.targets
					alien = aliens[ targetId ]
					alien.health -=
						killerDamagePerS * passedTimeInS /
						satellite.targets.length
