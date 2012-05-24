module "Graphics", [ "Rendering", "Camera", "Vec2", "Events", "ModifiedInput", "Orbits", "Gravitation" ], ( Rendering, Camera, Vec2, Events, Input, Orbits, Gravitation ) ->
	publishSelectOrbit        = null
	publishModifyTimeDilation = null

	module =
		createRenderState: ->
			renderState =
				camera        : Camera.createCamera()
				renderables   : []
				guiSubscribers: Events.createSubscribers()
				orbitSelection:
					currentlySelecting: false
					startingPoint     : null
					currentPoint      : null

		initRenderState: ( renderState ) ->
			publishSelectOrbit = ( orbit ) ->
				Events.publish(
					renderState.guiSubscribers,
					"select orbit",
					null,
					orbit )

			publishModifyTimeDilation = ( entityId, factorModification ) ->
				event =
					entityId: entityId
					factorModification: factorModification

				Events.publish(
					renderState.guiSubscribers,
					"modify time dilation",
					null,
					event )

		updateRenderState: ( renderState, gameState, currentInput ) ->
			renderState.renderables.length = 0


			handleOrbitSelection(
				renderState.orbitSelection,
				currentInput )
			handleTimeDilation(
				gameState.components.bodies,
				currentInput )


			appendPlanet(
				renderState.renderables )
			appendOrbitSelection(
				renderState.orbitSelection,
				renderState.renderables )
			appendSatellites(
				gameState.components.bodies,
				gameState.components.satellites,
				renderState.renderables )
			appendAliens(
				gameState.components.bodies,
				gameState.components.aliens,
				renderState.renderables )
			appendSatelliteTargets(
				gameState.components.satellites,
				gameState.components.bodies,
				renderState.renderables )
			appendStatus(
				gameState.game,
				renderState.renderables )


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )


	handleOrbitSelection = ( orbitSelection, currentInput ) ->
		if Input.isKeyDown( currentInput, "left mouse button" )
			if orbitSelection.currentlySelecting
				orbitSelection.currentPoint =
					Vec2.copy( currentInput.pointerPosition )
			else
				orbitSelection.currentlySelecting = true

				orbitSelection.startingPoint =
					Vec2.copy( currentInput.pointerPosition )
				orbitSelection.currentPoint =
					Vec2.copy( currentInput.pointerPosition )
		else
			if orbitSelection.currentlySelecting
				orbit = Orbits.orbitFromEndpoints(
					orbitSelection.startingPoint,
					orbitSelection.currentPoint,
					Gravitation.mu )

				publishSelectOrbit( orbit )

				orbitSelection.currentlySelecting = false

	handleTimeDilation = ( bodies, currentInput ) ->
		factor = 0.01
		selectionSize = 30

		delta = currentInput.wheel.deltaY
		if delta != 0
			for entityId, body of bodies
				mouseX = currentInput.pointerPosition[ 0 ]
				mouseY = currentInput.pointerPosition[ 1 ]

				mouseOverBody =
					body.position[ 0 ] - selectionSize / 2 <= mouseX and
					body.position[ 0 ] + selectionSize / 2 >= mouseX and
					body.position[ 1 ] - selectionSize / 2 <= mouseY and
					body.position[ 1 ] + selectionSize / 2 >= mouseY

				if mouseOverBody
					publishModifyTimeDilation(
						entityId, 
						delta * factor )

		currentInput.wheel.deltaX = 0
		currentInput.wheel.deltaY = 0

	appendPlanet = ( renderables ) ->
		renderable = Rendering.createRenderable( "filledCircle" )
		renderable.resource =
			color : "rgb(0,0,255)"
			radius: 25

		renderables.push( renderable )

	appendOrbitSelection = ( orbitSelection, renderables ) ->
		if orbitSelection.currentlySelecting
			orbit = Orbits.orbitFromEndpoints(
				orbitSelection.startingPoint,
				orbitSelection.currentPoint,
				Gravitation.mu )

			renderable = Rendering.createRenderable( "ellipse" )

			renderable.position    = orbit.focalToCenter
			renderable.orientation = Math.atan2(
				orbit.focalToCenter[ 1 ],
				orbit.focalToCenter[ 0 ] )

			renderable.resource =
				color: "rgb(255,255,255)"
				semiMajorAxis: orbit.semiMajorAxis
				semiMinorAxis: orbit.semiMinorAxis

			renderables.push( renderable )

	appendSatellites = ( bodies, satellites, renderables ) ->
		size = [ 10, 10 ]

		halfSize = Vec2.copy( size )
		Vec2.scale( halfSize, 0.5 )

		for entityId, satellite of satellites
			body = bodies[ entityId ]

			position = Vec2.copy( body.position )
			Vec2.subtract( position, halfSize )

			renderable = Rendering.createRenderable( "rectangle" )
			renderable.position = position
			renderable.resource =
				size: size

			renderables.push( renderable )

	appendAliens = ( bodies, aliens, renderables ) ->
		for entityId, alien of aliens
			body = bodies[ entityId ]

			renderable = Rendering.createRenderable( "filledCircle" )
			renderable.position = body.position
			renderable.resource =
				color : "rgb(0,255,0)"
				radius: 5

			renderables.push( renderable )

	appendSatelliteTargets = ( satellites, bodies, renderables ) ->
		for satelliteId, satellite of satellites
			satelliteBody = bodies[ satelliteId ]

			laserStrength = 1 / satellite.targets.length

			for targetId in satellite.targets
				targetBody = bodies[ targetId ]

				if targetBody?
					renderable = Rendering.createRenderable( "line" )
					renderable.resource =
						color: "rgba(255,255,255,#{ laserStrength })"
						start: satelliteBody.position
						end  : targetBody.position

					renderables.push( renderable )

	appendStatus = ( game, renderables ) ->
		populationLabel = Rendering.createRenderable( "text" )
		populationLabel.position = [ -300, -290 ]
		populationLabel.resource =
			string: "Population:"
			textColor: "rgb(255,255,255)"
			centered: [ false, false ]

		population = Rendering.createRenderable( "text" )
		population.position = [ -240, -290 ]
		population.resource =
			string: "#{ game.population } million"
			textColor: "rgb(255,255,255)"
			centered: [ false, false ]


		budgetLabel = Rendering.createRenderable( "text" )
		budgetLabel.position = [ -300, -270 ]
		budgetLabel.resource =
			string: "Budget:"
			textColor: "rgb(255,255,255)"
			centered: [ false, false ]

		budget = Rendering.createRenderable( "text" )
		budget.position = [ -240, -270 ]
		budget.resource =
			string: "$#{ game.budget }M"
			textColor: "rgb(255,255,255)"
			centered: [ false, false ]


		renderables.push( populationLabel )
		renderables.push( population )
		renderables.push( budgetLabel )
		renderables.push( budget )


	module
