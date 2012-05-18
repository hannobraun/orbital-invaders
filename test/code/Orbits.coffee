Orbits = load( "Orbits" )

describe "Orbits", ->
	describe "orbitFromEndpoints", ->
		it "should create an orbit from two endpoints", ->
			endpointA = [ -10, 0  ]
			endpointB = [  20, 0 ]

			orbitA = Orbits.orbitFromEndpoints( endpointA, endpointB )
			orbitB = Orbits.orbitFromEndpoints( endpointB, endpointA )

			expect( orbitA ).to.eql( {
				periapsis: endpointA
				apoapsis : endpointB } )
			expect( orbitB ).to.eql( orbitA )

		it "should correct the first endpoint, if it doesn't match with the second", ->
			significantEndpoint = [ 20, 0 ]

			orbitA = Orbits.orbitFromEndpoints( [  0, -10 ], significantEndpoint )
			orbitB = Orbits.orbitFromEndpoints( [ 10,   0 ], significantEndpoint )

			expect( orbitA ).to.eql( {
				periapsis: [ -10, 0 ]
				apoapsis : significantEndpoint } )
			expect( orbitB ).to.eql( orbitA )
