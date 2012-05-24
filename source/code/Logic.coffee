module "Logic", [ "ModifiedInput", "Entities", "Vec2", "Events", "ModifiedPhysics", "ModifiedEulerIntegrator", "Satellites", "Gravitation", "Orbits", "Aliens", "Planets", "Director" ], ( Input, Entities, Vec2, Events, Physics, EulerIntegrator, Satellites, Gravitation, Orbits, Aliens, Planets, Director ) ->
	entityFactories =
		"satellite": Satellites.createKiller
		"missile"  : Aliens.createMissile

	# There are functions for creating and destroying entities in the Entities
	# module. We will mostly use shortcuts however. They are declared here and
	# defined further down in initGameState.
	createEntity  = null
	destroyEntity = null


	module =
		createGameState: ->
			gameState =
				components: {}
				game:
					over      : false
					won       : null
					population: 500
					budget    : 900

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

			Events.subscribe guiSubscribers, "select orbit", [ Events.anyTopic ], ( orbit ) ->
				Satellites.launchSatellite(
					orbit,
					gameState.game,
					createEntity )

			Events.subscribe guiSubscribers, "modify time dilation", [ Events.anyTopic ], ( event ) ->
				Satellites.modifyTimeDilation(
					event.entityId,
					event.offset,
					gameState.components.bodies,
					gameState.components.satellites )


		updateGameState: ( gameState, currentInput, timeInS, passedTimeInS ) ->
			unless gameState.startTime?
				gameState.startTime = timeInS

			Gravitation.applyGravitation(
				gameState.components.bodies )
			Physics.update(
				gameState.components.bodies,
				passedTimeInS,
				EulerIntegrator.integrate )
			Satellites.handleNearbyAliens(
				gameState.components.satellites,
				gameState.components.aliens,
				gameState.components.bodies )
			Satellites.handleTargets(
				gameState.components.satellites,
				gameState.components.aliens,
				passedTimeInS )
			Aliens.handleAlienDeaths(
				gameState.components.aliens,
				destroyEntity )
			Planets.checkAlienCollisions(
				gameState.components.aliens,
				gameState.components.satellites,
				gameState.components.bodies,
				gameState.game,
				destroyEntity )
			Director.direct(
				timeInS - gameState.startTime,
				gameState.game,
				gameState.components.aliens,
				createEntity )
