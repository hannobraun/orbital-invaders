define "Graphics", [ "Rendering", "Camera", "Vec2" ], ( Rendering, Camera, Vec2 ) ->
	module =
		createRenderState: ->
			renderState =
				camera: Camera.createCamera()
				renderables: []

		updateRenderState: ( renderState, gameState ) ->
			renderState.renderables.length = 0




			Camera.transformRenderables(
				renderState.camera,
				renderState.renderables )
