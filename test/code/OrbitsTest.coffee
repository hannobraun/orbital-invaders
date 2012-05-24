module "OrbitsTest", [ "Orbits" ], ( Orbits ) ->
	describe "Orbits", ->
		mu = 2

		describe "orbitFromEndpoints", ->
			it "should create an orbit from two endpoints", ->
				endpointA = [ -10, 0 ]
				endpointB = [  20, 0 ]

				orbitA = Orbits.orbitFromEndpoints(
					endpointA,
					endpointB,
					mu )
				orbitB = Orbits.orbitFromEndpoints(
					endpointB,
					endpointA,
					mu )

				tolerance = 0.01
				expectedSemiMinorAxis = 10 * Math.sqrt( 2 )

				expect( orbitA.periapsis ).to.eql( endpointA )
				expect( orbitA.apoapsis ).to.eql( endpointB )
				expect( orbitA.semiMajorAxis ).to.be.within(
					15 - tolerance,
					15 + tolerance )
				expect( orbitA.semiMinorAxis ).to.be.within(
					expectedSemiMinorAxis - tolerance,
					expectedSemiMinorAxis + tolerance )
				expect( orbitA.focalToCenter[ 0 ] ).to.be.within(
					5 - tolerance,
					5 + tolerance )
				expect( orbitA.focalToCenter[ 1 ] ).to.be.within(
					0 - tolerance,
					0 + tolerance )
				expect( orbitB ).to.eql( orbitA )

			it "should correct the first endpoint, if it doesn't match with the second", ->
				significantEndpoint = [ 20, 0 ]

				orbitA = Orbits.orbitFromEndpoints(
					[  0, -10 ],
					significantEndpoint,
					mu )
				orbitB = Orbits.orbitFromEndpoints(
					[ 10,   0 ],
					significantEndpoint,
					mu )

				tolerance = 0.01
				expectedSemiMinorAxis = 10 * Math.sqrt( 2 )

				expect( orbitA.periapsis ).to.eql( [ -10, 0 ] )
				expect( orbitA.apoapsis ).to.eql( significantEndpoint )
				expect( orbitA.semiMajorAxis ).to.be.within(
					15 - tolerance,
					15 + tolerance )
				expect( orbitA.semiMinorAxis ).to.be.within(
					expectedSemiMinorAxis - tolerance,
					expectedSemiMinorAxis + tolerance )
				expect( orbitA.focalToCenter[ 0 ] ).to.be.within(
					5 - tolerance,
					5 + tolerance )
				expect( orbitA.focalToCenter[ 1 ] ).to.be.within(
					0 - tolerance,
					0 + tolerance )
				expect( orbitB ).to.eql( orbitA )

		describe "stateVectorsAtPeriapsis", ->
			it "should return the state vectors at the periapsis", ->
				orbit =
					semiMajorAxis: 15
					semiMinorAxis: 5
					focalToCenter: [ 5, 0 ]

				[ position, velocity ] = Orbits.stateVectorsAtPeriapsis(
					orbit,
					mu )

				tolerance = 0.01
				expectedSpeed = 2 / Math.sqrt( 15 )

				expect( position ).to.eql( [ -10, 0 ] )
				expect( velocity[ 0 ] ).to.equal( 0 )
				expect( velocity[ 1 ] ).to.be.within(
					-expectedSpeed - tolerance,
					-expectedSpeed + tolerance )

			it "should work for circular orbits", ->
				orbit =
					semiMajorAxis: 10
					semiMinorAxis: 10
					focalToCenter: [ 0, 0 ]

				[ position, velocity ] = Orbits.stateVectorsAtPeriapsis(
					orbit,
					mu )

				tolerance = 0.01
				expectedSpeed = 1 / Math.sqrt( 5 )

				expect( position ).to.eql( [ -10, 0 ] )
				expect( velocity[ 0 ] ).to.equal( 0 )
				expect( velocity[ 1 ] ).to.be.within(
					-expectedSpeed - tolerance,
					-expectedSpeed + tolerance )

load( "OrbitsTest" )
