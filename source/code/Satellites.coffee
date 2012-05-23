module "Satellites", [ "ModifiedPhysics" ], ( Physics ) ->
	nextEntityId = 0

	module =
		create: ( args ) ->
			body = Physics.createBody()
			body.position = args.position
			body.velocity = args.velocity

			entity =
				id: "satellite#{ nextEntityId += 1 }"
				components:
					"bodies": body
					"satellites": {}
