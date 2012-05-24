module "Planets", [ "Vec2" ], ( Vec2 ) ->
	nextEntityId = 0


	collidesWithPlanet = ( body, planetRadius ) ->
		Vec2.squaredLength( body.position ) <=
			planetRadius*planetRadius


	module =
		planetRadius: 25

		checkAlienCollisions: ( aliens, satellites, bodies, game, destroyEntity ) ->
			for alienId, alien of aliens
				body = bodies[ alienId ]

				if collidesWithPlanet( body, module.planetRadius )
					destroyEntity( alienId )
					game.population -= alien.damage
					game.population = Math.max( 0, game.population )

					if game.population == 0
						game.over = true
						game.won  = false

			for satelliteId, satellite of satellites
				body = bodies[ satelliteId ]

				if collidesWithPlanet( body, module.planetRadius )
					destroyEntity( satelliteId )
