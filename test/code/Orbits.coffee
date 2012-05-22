Orbits = load( "Orbits" )

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
