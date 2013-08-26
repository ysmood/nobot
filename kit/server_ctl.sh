compile () {
	# Compile scripts.
	coffee='node_modules/.bin/coffee'
	$coffee -c .
}

if [[ $1 = 'start' ]]; then
	compile

	# Start server on product mode.
	NODE_ENV=production nohup node app.js >> log/app.log 2>&1 &

elif [[ $1 = 'stop' ]]; then
	pid=$(cat .pid)
	kill $pid

elif [[ $1 = 'debug' ]]; then
	compile

	node --debug=7024 app.js
fi