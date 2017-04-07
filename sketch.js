var v=0.1;
var n_max = 10;
var angle_parts = 8;
var x_pos;
var y_pos;

function setup(){
    createCanvas(windowWidth,windowHeight);
    background(255);
    x_pos = width/2;
    y_pos = height/2;
}
function draw(){
    background(255, 20);
    stroke(80, 100);
    strokeWeight(1);
    translate(x_pos,y_pos);

    for(var x=1; x<=angle_parts; x++){
        rotate(2*PI/angle_parts);
        for(var i=0; i < n_max; i++){
            noFill();
            var green = map(i, 0, n_max, 0, 255);
            //stroke(0,green, 255*v)
            ellipse(x1(), y1(), x2(), y2());
            line(x1(),y1(),x2(),y2());
            //stroke(0, green, 220*v);
            point(x1()-10, y1()-10);
            for(var y=0; y < 4; y++){
                point(x2()+10*y, y2()+10*y);
            }

        }
    }
    v+=0.02;

}


function x1(){
    return cos(v)*20;
}
function y1(){
    return sin(-v)*20 + cos(v);
}
function x2(){
    return 60+cos(2*v)*50;
}
function y2(){
    return 200+cos(-5*v)*10;
}
