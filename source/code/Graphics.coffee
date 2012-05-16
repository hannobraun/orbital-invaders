module "Graphics", [ "Rendering", "Camera", "Vec2", "Events", "Input" ], ( Rendering, Camera, Vec2, Events, Input ) ->
	publishSelectOrbit = null

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
				periapsis = null
				apoapsis  = null

				startingPointIsPeriapsis =
					Vec2.squaredLength( orbitSelection.startingPoint ) <=
					Vec2.squaredLength( orbitSelection.currentPoint )

				if startingPointIsPeriapsis
					periapsis = orbitSelection.startingPoint
					apoapsis  = orbitSelection.currentPoint
				else
					periapsis = orbitSelection.currentPoint
					apoapsis  = orbitSelection.startingPoint

				publishSelectOrbit( {
					periapsis : periapsis
					apoapsis  : apoapsis } )

				orbitSelection.currentlySelecting = false

	appendPlanet = ( renderables ) ->
		renderable = Rendering.createRenderable( "filledCircle" )
		renderable.resource =
			color : "rgb(0,0,255)"
			radius: 25

		renderables.push( renderable )

	appendOrbitSelection = ( orbitSelection ) ->
		# nothing yet

	module =
		createRenderState: ->
			renderState =
				camera        : Camera.createCamera()
				renderables   : []
				guiSubscribers: Events.createSubscribers()
				orbitSelection:
					currentlySelecting: false
					startingPoint     : [ 0, 0 ]
					currentPoint      : [ 0, 0 ]

		initRenderState: ( renderState ) ->
			publishSelectOrbit = ( orbit ) ->
				Events.publish(
					renderState.guiSubscribers,
					"select orbit",
					null,
					orbit )

		updateRenderState: ( renderState, gameState, currentInput ) ->
			renderState.renderables.length = 0


			handleOrbitSelection(
				renderState.orbitSelection,
				currentInput )


			appendPlanet(
				renderState.renderables )
			appendOrbitSelection(
				renderState.orbitSelection )


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
