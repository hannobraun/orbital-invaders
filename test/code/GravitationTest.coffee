module "GravitationTest", [ "Gravitation", "Physics" ], ( Gravitation, Physics ) ->
	describe "Gravitation", ->
		it "should apply gravity forces to the bodies", ->
			G = 2

			body = Physics.createBody()
			body.position = [ -2, 0 ]
			body.mass     = 3

			Gravitation.applyGravitation( [ body ], G )

			expect( body.forces[ 0 ] ).to.eql( [ 1.5, 0 ] )

load( "GravitationTest" )
