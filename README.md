# Overview

A tiny node web bot service platform.
It supplies a simply interface to generate web bot service.
Write you bot into the bots folder,
then the system will automatically load your bot and run the service for you.

# Build & Control

### Requirement

0. Unix-like system.
0. Node.js installed.

### Configuration

The options in the `config.json` file.

* `port`

  Which port listened to.

* `bots_dir`

  The root directory of the bots. Implement your own bots here.

### Build

  0. Install the node dependencies: `npm install`

### Control

- Launch the server on product mode: `npm start`
- Stop the server: `npm stop`
- Restart the server: `npm restart`

# Debug

- Launch the server on development mode: `npm run-script debug`

# API

Every bot should be a standard node module,
here are the required method that a bot should expose.
There's already an example bot in the `bots` folder.

- `get(done, params)`: *function*

  - `done(ret, err)`: *function*

     the callback of the get function.
     If string is null, the server will return the err info as string and
     set http status to 500.

      - `ret`: *any*

         the return object of the bot.

      - `err`: *any*

         error info.

  - `params`: *object*, a express.js request.query object.
    It contains all http query information.


# License

BSD-2-Clause

Jul 2013 ys
