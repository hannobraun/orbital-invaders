module "Director", [], ->
	script =
		nextEventIndex: 0
		events: [
			{
				timeInS: 0.0
				type   : "spawn missile"
				times  : 1 }
			{
				timeInS: 10.0
				type   : "spawn missile"
				times  : 2 }
			{
				timeInS: 20.0
				type   : "spawn missile"
				times  : 4 }
			{
				timeInS: 30.0
				type   : "spawn missile"
				times  : 10 } ]


	length = ( map ) ->
		numberOfElements = 0
		for key, value of map
			numberOfElements += 1

		numberOfElements


	module =
		direct: ( timeInS, game, aliens, createEntity ) ->
			nextEvent = script.events[ script.nextEventIndex ]

			if nextEvent?
				if timeInS >= nextEvent.timeInS
					for i in [1..nextEvent.times]
						switch nextEvent.type
							when "spawn missile"
								createEntity( "missile" )

					script.nextEventIndex += 1
			else if length( aliens ) == 0
				game.over = true
				game.won  = game.population > 0
