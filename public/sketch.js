var radius = 80;
var socket;

function setup()
{
  createCanvas(640, 480);
  background(80);

  socket = io.connect('http://localhost:3000');
  socket.on('mouse', newDrawing);
}

function newDrawing(data)
{
  noStroke();
  fill(240,0, 240, 120);
  ellipse(data.x, data.y, radius, radius);
}

function draw()
{}

function mouseDragged()
{
  noStroke();
  fill(240, 120);
  ellipse(mouseX, mouseY, radius, radius);

  var data = {
    x: mouseX,
    y: mouseY
  };
  socket.emit('mouse', data);
}
