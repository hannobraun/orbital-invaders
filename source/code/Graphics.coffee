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

		delta = currentInput.wheel.deltaY
		if delta != 0
			publishModifyTimeDilation(
				"", 
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


	module
