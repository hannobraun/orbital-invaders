module "Logic", [ "Input", "Entities", "Vec2", "Events", "Physics", "EulerIntegrator", "Satellites", "Gravitation" ], ( Input, Entities, Vec2, Events, Physics, EulerIntegrator, Satellites, Gravitation ) ->
	entityFactories =
		"satellite": Satellites.create

	# There are functions for creating and destroying entities in the Entities
	# module. We will mostly use shortcuts however. They are declared here and
	# defined further down in initGameState.
	createEntity  = null
	destroyEntity = null

	addSelectOrbitHandler = ( guiSubscribers ) ->
		Events.subscribe guiSubscribers, "select orbit", [ Events.anyTopic ], ( orbit ) ->
			console.log( orbit )


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

			addSelectOrbitHandler( guiSubscribers )


			createEntity( "satellite", {
				position: [ 100, 100 ]
				velocity: [ -10, 10 ] } )

		updateGameState: ( gameState, currentInput, timeInS, passedTimeInS ) ->
			Physics.update(
				gameState.components.bodies,
				passedTimeInS,
				EulerIntegrator.integrate )
			Gravitation.applyGravitation(
				gameState.components.bodies )
