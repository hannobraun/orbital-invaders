module "Logic", [ "ModifiedInput", "Entities", "Vec2", "Events", "ModifiedPhysics", "ModifiedEulerIntegrator", "Satellites", "Gravitation", "Orbits", "Aliens", "Planets" ], ( Input, Entities, Vec2, Events, Physics, EulerIntegrator, Satellites, Gravitation, Orbits, Aliens, Planets ) ->
	entityFactories =
		"satellite": Satellites.createKiller
		"missile"  : Aliens.createMissile

	# There are functions for creating and destroying entities in the Entities
	# module. We will mostly use shortcuts however. They are declared here and
	# defined further down in initGameState.
	createEntity  = null
	destroyEntity = null

	addSelectOrbitHandler = ( guiSubscribers ) ->
		Events.subscribe guiSubscribers, "select orbit", [ Events.anyTopic ], ( orbit ) ->
			[ position, velocity ] = Orbits.stateVectorsAtPeriapsis(
				orbit,
				Gravitation.mu )

			createEntity( "satellite", {
				position: position
				velocity: velocity } )

	addModifyTimeDilationHandler = ( guiSubscribers, gameState ) ->
		Events.subscribe guiSubscribers, "modify time dilation", [ Events.anyTopic ], ( event ) ->
			bodies     = gameState.components.bodies
			satellites = gameState.components.satellites

			body = bodies[ event.entityId ]

			if satellites[ event.entityId ]?
				body.timeDilation += event.factorModification

				body.timeDilation = Math.max( 0.5, body.timeDilation )
				body.timeDilation = Math.min( 3.0, body.timeDilation )


	module =
		createGameState: ->
			gameState =
				components: {}

		initGameState: ( gameState, guiSubscribers ) ->
			# These are the shortcuts we will use for creating and destroying
			# entities.
			createEntity = ( type, args ) ->
				Entities.createEntity(
					entityFactories,
					gameState.components,
					type,
					args )
			destroyEntity = ( entityId ) ->
				Entities.destroyEntity(
					gameState.components,
					entityId )

			addSelectOrbitHandler(
				guiSubscribers )
			addModifyTimeDilationHandler(
				guiSubscribers,
				gameState )

			for i in [1..10]
				createEntity( "missile" )

		updateGameState: ( gameState, currentInput, timeInS, passedTimeInS ) ->
			Physics.update(
				gameState.components.bodies,
				passedTimeInS,
				EulerIntegrator.integrate )
			Gravitation.applyGravitation(
				gameState.components.bodies )
			Planets.checkAlienCollisions(
				gameState.components.aliens,
				gameState.components.bodies,
				destroyEntity )
