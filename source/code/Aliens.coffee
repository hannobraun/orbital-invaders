module "Aliens", [ "ModifiedPhysics", "Vec2" ], ( Physics, Vec2 ) ->
	nextEntityId = 0

	initialHealth =
		"missile": 5

	module =
		createMissile: ( args ) ->
			angle    = Math.random() * Math.PI * 2
			distance = 500
			speed    = 10

			position = [
				distance * Math.sin( angle )
				distance * Math.cos( angle ) ]

			velocity = Vec2.copy( position )
			Vec2.normalize( velocity )
			Vec2.scale( velocity, -speed )

			body = Physics.createBody()
			body.position = position
			body.velocity = velocity

			entity =
				id: "missile#{ nextEntityId += 1 }"
				components:
					"bodies": body
					"aliens":
						health: initialHealth[ "missile" ]
