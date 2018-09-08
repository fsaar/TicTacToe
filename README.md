![](https://img.shields.io/badge/Swift-4.2-orange.svg)
[![Travis Build Status](https://travis-ci.org/fsaar/TicTacToe.svg?branch=master)](https://travis-ci.org/fsaar/TicTacToe)
[![Bitrise Build Status](https://app.bitrise.io/app/c950f49b3ee5795f/status.svg?token=5MpiXv8NPFeKGcieFpXdHA&branch=master)](https://www.bitrise.io/app/c950f49b3ee5795f)
[![Code Climate](https://codeclimate.com/github/fsaar/TicTacToe/badges/gpa.svg)](https://codeclimate.com/github/fsaar/TicTacToe)
[![codebeat badge](https://codebeat.co/badges/686bbc0f-9f28-434c-bcfd-0c7e39becda0)](https://codebeat.co/projects/github-com-fsaar-tictactoe-master)

# TicTacToe 
[![TicTacToe](https://static1.squarespace.com/static/56e48990f699bb97173ad03c/t/59d114ee6f4ca3b208720044/1506874664263](https://www.allaboutswift.com/dev/2016/9/11/an-exercise-in-swift))


An implementation of TicTacToe, in which the iphone client talks to a server API to retrieve / update highscore. Server is located at http://127.0.0.1:8090 and supports 4 types of request:

	- GET /highscore.<html/json>: to provide a html/json formatted list of current highscore
	- POST /highscore.json: to update highscore with a new entry
								
Post request has 3 elements: name, moves necessary to win and time needed e.g. {"name": "RED", "moves":5,"time": 0.6193609237670898}. 

To play the game just build & run. Xcode project is configured to start server automatically. Server's presence can be verified with http://127.0.0.1:8090/highscore.html in a browser. Posts can be verified via 

`
curl --header "Content-Type: application/json" --request POST -d '{"name": "RED", "moves":5,"time": 0.6193609237670898}'  http://127.0.0.1:8090/highscore.json
`




