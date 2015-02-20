# Tap! Server

## Getting Started
Here are the steps you need to set up the server locally.
Please note that following steps assume that you are working on a UNIX machine.
Doing this on Windows is masochism, just use a Linux VM.

 1. Install Node.js
You can download it [on the official website](http://nodejs.org).

Alternatively, on Ubuntu:
```
$ curl -sL https://deb.nodesource.com/setup | sudo bash -
$ sudo apt-get install nodejs
```
 2. `cd` to the `/server` directory of **Tap** project
```
$ cd <tap_repo>/server
```

 3. Run the following
```
$ sudo -H npm i -g gulp mocha
```

 4. Install dependencies
```
$ npm i
```

 5. Start the server
```
$ npm start
```

## API Documentation
With the server started, you can read the documentation at this url:
```
http://localhost:3000/docs
```
