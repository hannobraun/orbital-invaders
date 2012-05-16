Orbits = load( "Orbits" )

describe "Orbits", ->
	describe "createOrbit", ->
		it "should create an orbit from two endpoints", ->
			endpointA = [ -10, 0  ]
			endpointB = [   0, 20 ]

			orbitA = Orbits.createOrbit( endpointA, endpointB )
			orbitB = Orbits.createOrbit( endpointB, endpointA )

			expect( orbitA ).to.eql( {
				periapsis: endpointA
				apoapsis : endpointB } )
			expect( orbitB ).to.eql( orbitA )
