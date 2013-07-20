express = require('express')
http = require('http')
app = express();
server = http.createServer(app)


port = if process.env.PORT then process.env.PORT else 3000

app.use(express.static(__dirname + '/public'));
app.enable('trust proxy')

#commented out, as we are currently delivering the static index.html
#app.get('/', (req, res) ->
#  res.send('Hello World')
#)







server.listen(port)
console.log('Listening on port '+port);