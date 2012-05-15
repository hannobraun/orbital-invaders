define "Graphics", [ "Rendering", "Camera", "Vec2" ], ( Rendering, Camera, Vec2 ) ->
	appendPlanet = ( renderables ) ->
		renderable = Rendering.createRenderable( "filledCircle" )
		renderable.resource =
			color : "rgb(0,0,255)"
			radius: 25

		renderables.push( renderable )

	module =
		createRenderState: ->
			renderState =
				camera: Camera.createCamera()
				renderables: []

		updateRenderState: ( renderState, gameState ) ->
			renderState.renderables.length = 0


			appendPlanet(
				renderState.renderables )


			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
