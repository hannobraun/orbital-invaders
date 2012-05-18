module "Orbits", [ "Vec2" ], ( Vec2 ) ->
	correctAuxiliaryEndpoint = ( auxiliaryEndpoint, significantEndpoint ) ->
		auxiliaryDistance = Vec2.length( auxiliaryEndpoint )

		auxiliaryEndpoint[ 0 ] = significantEndpoint[ 0 ]
		auxiliaryEndpoint[ 1 ] = significantEndpoint[ 1 ]

		Vec2.unit( auxiliaryEndpoint )
		Vec2.scale( auxiliaryEndpoint, -auxiliaryDistance )
		
	determineApses = ( auxiliaryEndpoint, significantEndpoint ) ->
		auxiliaryEndpointIsPeriapsis =
			Vec2.squaredLength( auxiliaryEndpoint ) <=
			Vec2.squaredLength( significantEndpoint )

		periapsis = null
		apoapsis  = null
		if auxiliaryEndpointIsPeriapsis
			periapsis = auxiliaryEndpoint
			apoapsis  = significantEndpoint
		else
			periapsis = significantEndpoint
			apoapsis  = auxiliaryEndpoint

		[ periapsis, apoapsis ]

	module =
		orbitFromEndpoints: ( auxiliaryEndpoint, significantEndpoint ) ->
			correctAuxiliaryEndpoint(
				auxiliaryEndpoint,
				significantEndpoint )

			[ periapsis, apoapsis ] = determineApses(
				auxiliaryEndpoint,
				significantEndpoint )

			orbit =
				periapsis: periapsis
				apoapsis : apoapsis
