module "Gravitation", [ "Vec2" ], ( Vec2 ) ->
	G  = 5e4
	mu = G
	
	module =
		G : G
		mu: mu

		applyGravitation: ( bodies, G ) ->
			for entityId, body of bodies
				squaredDistance = Vec2.squaredLength( body.position )
				forceMagnitude = G * body.mass / squaredDistance

				force = Vec2.copy( body.position )
				Vec2.scale( force, -1 )
				Vec2.normalize( force )
				Vec2.scale( force, forceMagnitude )
				body.forces.push( force )
