module "Orbits", [ "Vec2" ], ( Vec2 ) ->
	module =
		createOrbit: ( endpointA, endpointB ) ->
			endpointAIsPeriapsis =
				Vec2.squaredLength( endpointA ) <=
				Vec2.squaredLength( endpointB )

			periapsis = null
			apoapsis  = null
			if endpointAIsPeriapsis
				periapsis = endpointA
				apoapsis  = endpointB
			else
				periapsis = endpointB
				apoapsis  = endpointA

			orbit =
				periapsis: periapsis
				apoapsis : apoapsis
