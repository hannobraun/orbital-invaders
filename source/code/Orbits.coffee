module "Orbits", [ "Vec2" ], ( Vec2 ) ->
	module =
		orbitFromEndpoints: ( auxiliaryEndpoint, significantEndpoint, mu ) ->
			correctAuxiliaryEndpoint(
				auxiliaryEndpoint,
				significantEndpoint )

			[ periapsis, apoapsis ] = determineApses(
				auxiliaryEndpoint,
				significantEndpoint )

			periapsisDistance = Vec2.length( periapsis )
			apoapsisDistance  = Vec2.length( apoapsis )

			eccentricity  = computeEccentricity(
				periapsisDistance,
				apoapsisDistance )

			semiMajorAxis = computeSemiMajorAxis(
				periapsisDistance,
				eccentricity )
			semiMinorAxis = computeSemiMinorAxis( semiMajorAxis, eccentricity )
			focalToCenter = computeFocalToCenter(
				periapsis,
				eccentricity,
				semiMajorAxis,
				semiMinorAxis,
				mu )

			orbit =
				semiMajorAxis: semiMajorAxis
				semiMinorAxis: semiMinorAxis
				focalToCenter: focalToCenter

		stateVectorsAtPeriapsis: ( orbit, mu ) ->
			position = Vec2.copy( orbit.focalToCenter )
			Vec2.normalize( position )
			Vec2.scale( position, -orbit.semiMajorAxis )
			Vec2.add( position, orbit.focalToCenter )

			periapsisDistance = Vec2.length( position )
			apoapsisDistance  =
				orbit.semiMajorAxis*2 - Vec2.length( position )

			eccentricity = computeEccentricity(
				periapsisDistance,
				apoapsisDistance )

			velocity = computeVelocityAtPeriapsis(
				position,
				eccentricity,
				orbit.semiMajorAxis,
				mu )

			[ position, velocity ]


	correctAuxiliaryEndpoint = ( auxiliaryEndpoint, significantEndpoint ) ->
		auxiliaryDistance = Vec2.length( auxiliaryEndpoint )

		auxiliaryEndpoint[ 0 ] = significantEndpoint[ 0 ]
		auxiliaryEndpoint[ 1 ] = significantEndpoint[ 1 ]

		Vec2.normalize( auxiliaryEndpoint )
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

	computeEccentricity = ( periapsisDistance, apoapsisDistance ) ->
		dPe = periapsisDistance
		dAp = apoapsisDistance

		( dAp - dPe ) / ( dAp + dPe )

	computeSemiMajorAxis = ( periapsisDistance, eccentricity ) ->
		periapsisDistance / ( 1 - eccentricity )

	computeSemiMinorAxis = ( semiMajorAxis, eccentricity ) ->
		semiMajorAxis * Math.sqrt( 1 - eccentricity*eccentricity )

	computeFocalToCenter = ( periapsis, eccentricity, semiMajorAxis, semiMinorAxis, mu ) ->
		velocityAtPeriapsis = computeVelocityAtPeriapsis(
			periapsis,
			eccentricity,
			semiMajorAxis,
			mu )
		eccentricityVector = computeEccentricityVectorFromStateVectors(
			periapsis,
			velocityAtPeriapsis,
			mu )
		focalDistance = computeFocalDistance( semiMajorAxis, semiMinorAxis )

		focalToCenter = Vec2.copy( eccentricityVector )
		Vec2.normalize( focalToCenter )
		Vec2.scale( focalToCenter, -focalDistance )

		focalToCenter

	computeVelocityAtPeriapsis = ( periapsis, eccentricity, semiMajorAxis, mu ) ->
		speed = Math.sqrt(
			( ( 1 + eccentricity ) * mu ) /
			( ( 1 - eccentricity ) * semiMajorAxis ) )

		velocity = Vec2.copy( periapsis )
		velocity = [ -velocity[ 1 ], velocity[ 0 ] ]
		Vec2.normalize( velocity )
		Vec2.scale( velocity, speed )

		velocity

	computeEccentricityVectorFromStateVectors = ( position, velocity, mu ) ->
		distance = Vec2.length( position )
		speed    = Vec2.length( velocity )

		eccentricityVector = Vec2.copy( position )
		Vec2.scale( eccentricityVector, speed*speed / mu )
		tmp = Vec2.copy( velocity )
		Vec2.scale( tmp, Vec2.dot( position, velocity ) / mu )
		Vec2.subtract( eccentricityVector, tmp )
		tmp = Vec2.copy( position )
		Vec2.scale( tmp, 1 / distance )
		Vec2.subtract( eccentricityVector, tmp )

		eccentricityVector

	computeFocalDistance = ( semiMajorAxis, semiMinorAxis ) ->
		a = semiMajorAxis
		b = semiMinorAxis
		
		Math.sqrt( a*a - b*b )
		
	module
