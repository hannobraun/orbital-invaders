module "Planets", [ "Vec2" ], ( Vec2 ) ->
	nextEntityId = 0

	planetRadius = 25


	collidesWithPlanet = ( body ) ->
		Vec2.squaredLength( body.position ) <=
			planetRadius*planetRadius


	module =
		checkAlienCollisions: ( aliens, bodies, game, destroyEntity ) ->
			for entityId, alien of aliens
				body = bodies[ entityId ]

				if collidesWithPlanet( body )
					destroyEntity( entityId )
					game.population -= alien.damage
					game.population = Math.max( 0, game.population )

					if game.population == 0
						game.over = true
						game.won  = false
