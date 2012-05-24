module "Director", [], ->
	script =
		nextEventIndex: 0
		events: [
			{
				timeInS: 0.0
				event:
					type  : "spawn missile"
					number: 1 }
			{
				timeInS: 10.0
				event:
					type  : "spawn missile"
					number: 2 }
			{
				timeInS: 20.0
				event:
					type  : "spawn missile"
					number: 4 }
			{
				timeInS: 30.0
				event:
					type  : "spawn missile"
					number: 10 } ]


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
					console.log( "1!" )
					for i in [1..nextEvent.event.number]
						console.log( "2!" )
						createEntity( "missile" )

					script.nextEventIndex += 1
			else if length( aliens ) == 0
				game.over = true
				game.won  = game.health > 0
