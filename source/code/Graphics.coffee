module "Graphics", [ "Rendering", "Camera", "Vec2", "Events", "Input", "Orbits" ], ( Rendering, Camera, Vec2, Events, Input, Orbits ) ->
	publishSelectOrbit = null

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

		updateRenderState: ( renderState, gameState, currentInput ) ->
			renderState.renderables.length = 0


			handleOrbitSelection(
				renderState.orbitSelection,
				currentInput )


			appendPlanet(
				renderState.renderables )
			appendOrbitSelection(
				renderState.orbitSelection,
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
					orbitSelection.currentPoint )

				publishSelectOrbit( orbit )

				orbitSelection.currentlySelecting = false

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
				orbitSelection.currentPoint )

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





	module
