var express = require('express');
var app=express();
var server=app.listen(3000);

app.use(express.static('public'));
console.log('Node.js server up & running!');

var io = require('socket.io')(server);
io.sockets.on('connection', newConnection);

function newConnection(socket)
{
  console.log(socket.id);
  socket.on('mouse',
  function(data)
  {
    socket.broadcast.emit('mouse', data);

  }
);
}
