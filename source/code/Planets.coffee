module "Planets", [ "Vec2" ], ( Vec2 ) ->
	nextEntityId = 0

	planetRadius = 25


	collidesWithPlanet = ( body ) ->
		Vec2.squaredLength( body.position ) <=
			planetRadius*planetRadius


	module =
		checkAlienCollisions: ( aliens, satellites, bodies, game, destroyEntity ) ->
			for alienId, alien of aliens
				body = bodies[ alienId ]

				if collidesWithPlanet( body )
					destroyEntity( alienId )
					game.population -= alien.damage
					game.population = Math.max( 0, game.population )

					if game.population == 0
						game.over = true
						game.won  = false

			for satelliteId, satellite of satellites
				body = bodies[ satelliteId ]

				if collidesWithPlanet( body )
					destroyEntity( satelliteId )
