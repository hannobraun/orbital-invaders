module "Planets", [ "Vec2" ], ( Vec2 ) ->
	nextEntityId = 0

	planetRadius = 25

	module =
		checkAlienCollisions: ( aliens, bodies, game, destroyEntity ) ->
			for entityId, alien of aliens
				body = bodies[ entityId ]

				collidesWithPlanet =
					Vec2.squaredLength( body.position ) <=
					planetRadius*planetRadius

				if collidesWithPlanet
					destroyEntity( entityId )
					game.population -= alien.damage
