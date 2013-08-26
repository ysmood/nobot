express = require 'express'
_ = require 'underscore'

fs = require 'fs'
path = require 'path'

config = require './config.json'

class Nobot
	constructor: ->
		@save_pid()

		@app = express()

		@bots = {}
		@load_bots(config.bots_dir)

		@init_routes()

	save_pid: ->
		# Help stop the server by the PID later.
		fs.writeFileSync(
			'log/.pid',
			process.pid
		)

	start: ->
		@app.listen(config.port)

		console.log "Start at port " + config.port

	load_bots: (bots_dir) ->
		ps = fs.readdirSync(bots_dir)

		ps = _.select(
			ps,
			(elem) -> elem.match(/(\.js)$/)
		).map((elem)->
			elem.match(/(.+)\.js$/)[1]
		)

		for p in ps
			@bots[p] = require(
				path.resolve(bots_dir, p)
			)
			console.log "Bot #{p} loaded."

	init_routes: ->
		# Every bot should expose a 'get' method to return the basic resource.

		@app.get('/:bot', (req, res) =>
			bot = @bots[req.params.bot]

			bot.get(
				(ret) ->
					res.send(ret)
				req.query
			)
		)


nobot = new Nobot
nobot.start()
