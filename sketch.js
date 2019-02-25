var angle = 0.0;

function setup(){
    createCanvas(windowWidth*0.99,windowHeight/2);
    background(255);
    angle = 0.0;
    background(255);
    stroke(80,120);
    translate(0, height/3*2);
    for (var z = 0; z < 30; z++){
      var div = random(100.0);
      var offset = random(60.0);
      var amp = random(40.0);
      for (var x = 0; x < width; x++){
        var y = offset + (sin(angle)*amp);
        point(x,y);
        angle += PI/div;
      }
    }
}
/*function draw(){
  background(255);
  stroke(80,120);
  translate(0, height/2);
  for (var z = 0; z < 30; z++){
    var div = random(100.0);
    var offset = random(60.0);
    var amp = random(40.0);
    for (var x = 0; x < width*98/100; x++){
      var y = offset + (sin(angle)*amp);
      point(x,y);
      angle += PI/div;
    }
  }
}*/
