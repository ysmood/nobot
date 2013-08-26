# A web bot plugin to grab anime playbill from http://bt.ktxp.com/playbill.php

_ = require 'underscore'
request = require 'request'
cheerio = require 'cheerio'
cache = require 'memory-cache'

grab_url = 'http://bt.ktxp.com/playbill.php'
playbill = null

parse = (body) ->
	# Parse playbill.
	#
	# weekly: object
	# 	date: int of current timestamp
	# 	playbill: array of daily playbill

	# daily: object
	# 	date: string
	# 	playbill: An array of string


	date = new Date()
	date.setHours(0, 0, 0, 0)
	weekly = {
		date: date.toUTCString()
		playbill: []
	}

	$ = cheerio.load(body)

	$('.container dl').each(->
		daily = {}
		$this = $(this)

		daily.date = $this.find('dt').text().slice(0, 3)

		daily.playbill = _.map(
			$this.find('dd a'),
			(elem) ->
				$(elem).text()
		)

		weekly.playbill.push daily
	)

	weekly

get = (done, query) ->
	# If cached, return directly.
	if playbill
		done(playbill)
		return

	request(
		grab_url
		(err, res, body) ->
			if not err
				try
					playbill = parse(body)
					done(playbill)
					console.log "Anime playbill grabbed from #{grab_url}."

					# A simple memory cache for the list.
					# Cache for an hour.
					setTimeout(
						-> playbill = null
						1000 * 60 * 60
					)
				catch e
					console.error e
			else
				console.error err
	)

# Expose the required interface.
exports.get = get
