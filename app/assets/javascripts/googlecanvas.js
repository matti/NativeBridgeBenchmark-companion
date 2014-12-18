window.requestAnimFrame = (function(callback) {
  return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame ||
  function(callback) {
    window.setTimeout(callback, 1000 / 60);
  };
})();

function initBalls() {
  balls = [];

  var blue = '#3A5BCD';
  var red = '#EF2B36';
  var yellow = '#FFC636';
  var green = '#02A817';

  // G
  balls.push(new Ball(73, 63, 0, 0, blue));
  balls.push(new Ball(58, 53, 0, 0, blue));
  balls.push(new Ball(43, 52, 0, 0, blue));
  balls.push(new Ball(30, 53, 0, 0, blue));
  balls.push(new Ball(17, 58, 0, 0, blue));
  balls.push(new Ball(10, 70, 0, 0, blue));
  balls.push(new Ball(2, 82, 0, 0, blue));
  balls.push(new Ball(4, 96, 0, 0, blue));
  balls.push(new Ball(5, 107, 0, 0, blue));
  balls.push(new Ball(10, 120, 0, 0, blue));
  balls.push(new Ball(24, 130, 0, 0, blue));
  balls.push(new Ball(39, 136, 0, 0, blue));
  balls.push(new Ball(52, 136, 0, 0, blue));
  balls.push(new Ball(66, 136, 0, 0, blue));
  balls.push(new Ball(74, 127, 0, 0, blue));
  balls.push(new Ball(79, 110, 0, 0, blue));
  balls.push(new Ball(66, 109, 0, 0, blue));
  balls.push(new Ball(56, 110, 0, 0, blue));

  // O
  balls.push(new Ball(110, 81, 0, 0, red));
  balls.push(new Ball(97, 91, 0, 0, red));
  balls.push(new Ball(96, 103, 0, 0, red));
  balls.push(new Ball(100, 116, 0, 0, red));
  balls.push(new Ball(109, 127, 0, 0, red));
  balls.push(new Ball(123, 130, 0, 0, red));
  balls.push(new Ball(137, 127, 0, 0, red));
  balls.push(new Ball(144, 114, 0, 0, red));
  balls.push(new Ball(142, 98, 0, 0, red));
  balls.push(new Ball(137, 86, 0, 0, red));
  balls.push(new Ball(125, 81, 0, 0, red));

  // O
  var oOffset = 67-100;
  balls.push(new Ball(oOffset + 210, 81, 0, 0, yellow));
  balls.push(new Ball(oOffset + 197, 91, 0, 0, yellow));
  balls.push(new Ball(oOffset + 196, 103, 0, 0, yellow));
  balls.push(new Ball(oOffset + 200, 116, 0, 0, yellow));
  balls.push(new Ball(oOffset + 209, 127, 0, 0, yellow));
  balls.push(new Ball(oOffset + 223, 130, 0, 0, yellow));
  balls.push(new Ball(oOffset + 237, 127, 0, 0, yellow));
  balls.push(new Ball(oOffset + 244, 114, 0, 0, yellow));
  balls.push(new Ball(oOffset + 242, 98, 0, 0, yellow));
  balls.push(new Ball(oOffset + 237, 86, 0, 0, yellow));
  balls.push(new Ball(oOffset + 225, 81, 0, 0, yellow));

  // G
  balls.push(new Ball(270, 80, 0, 0, blue));
  balls.push(new Ball(258, 79, 0, 0, blue));
  balls.push(new Ball(246, 79, 0, 0, blue));
  balls.push(new Ball(235, 84, 0, 0, blue));
  balls.push(new Ball(230, 98, 0, 0, blue));
  balls.push(new Ball(234, 111, 0, 0, blue));
  balls.push(new Ball(248, 116, 0, 0, blue));
  balls.push(new Ball(262, 109, 0, 0, blue));
  balls.push(new Ball(262, 94, 0, 0, blue));
  balls.push(new Ball(255, 128, 0, 0, blue));
  balls.push(new Ball(240, 135, 0, 0, blue));
  balls.push(new Ball(227, 142, 0, 0, blue));
  balls.push(new Ball(225, 155, 0, 0, blue));
  balls.push(new Ball(239, 165, 0, 0, blue));
  balls.push(new Ball(252, 166, 0, 0, blue));
  balls.push(new Ball(267, 161, 0, 0, blue));
  balls.push(new Ball(271, 149, 0, 0, blue));
  balls.push(new Ball(266, 137, 0, 0, blue));

  return balls;
}
function getMousePos(canvas, evt) {
  // get canvas position
  var obj = canvas;
  var top = 0;
  var left = 0;
  while(obj.tagName != 'BODY') {
    top += obj.offsetTop;
    left += obj.offsetLeft;
    obj = obj.offsetParent;
  }

  // return relative mouse position
  var mouseX = evt.touches[0].posX - left + window.pageXOffset;
  var mouseY = evt.touches[0].posY - top + window.pageYOffset;
  return {
    x: mouseX,
    y: mouseY
  };
}
function updateBalls(canvas, balls, timeDiff, mousePos) {
  var context = canvas.getContext('2d');
  var collisionDamper = 0.3;
  var floorFriction = 0.0005 * timeDiff;
  var mouseForceMultiplier = 1 * timeDiff;
  var restoreForce = 0.002 * timeDiff;

  for(var n = 0; n < balls.length; n++) {
    var ball = balls[n];
    // set ball position based on velocity
    ball.y += ball.vy;
    ball.x += ball.vx;

    // restore forces
    if(ball.x > ball.origX) {
      ball.vx -= restoreForce;
    }
    else {
      ball.vx += restoreForce;
    }
    if(ball.y > ball.origY) {
      ball.vy -= restoreForce;
    }
    else {
      ball.vy += restoreForce;
    }

    // mouse forces
    var mouseX = mousePos.x;
    var mouseY = mousePos.y;

    var distX = ball.x - mouseX;
    var distY = ball.y - mouseY;

    var radius = Math.sqrt(Math.pow(distX, 2) + Math.pow(distY, 2));

    var totalDist = Math.abs(distX) + Math.abs(distY);

    var forceX = (Math.abs(distX) / totalDist) * (1 / radius) * mouseForceMultiplier;
    var forceY = (Math.abs(distY) / totalDist) * (1 / radius) * mouseForceMultiplier;

    if(distX > 0) {// mouse is left of ball
      ball.vx += forceX;
    }
    else {
      ball.vx -= forceX;
    }
    if(distY > 0) {// mouse is on top of ball
      ball.vy += forceY;
    }
    else {
      ball.vy -= forceY;
    }

    // floor friction
    if(ball.vx > 0) {
      ball.vx -= floorFriction;
    }
    else if(ball.vx < 0) {
      ball.vx += floorFriction;
    }
    if(ball.vy > 0) {
      ball.vy -= floorFriction;
    }
    else if(ball.vy < 0) {
      ball.vy += floorFriction;
    }

    // floor condition
    if(ball.y > (canvas.height - ball.radius)) {
      ball.y = canvas.height - ball.radius - 2;
      ball.vy *= -1;
      ball.vy *= (1 - collisionDamper);
    }

    // ceiling condition
    if(ball.y < (ball.radius)) {
      ball.y = ball.radius + 2;
      ball.vy *= -1;
      ball.vy *= (1 - collisionDamper);
    }

    // right wall condition
    if(ball.x > (canvas.width - ball.radius)) {
      ball.x = canvas.width - ball.radius - 2;
      ball.vx *= -1;
      ball.vx *= (1 - collisionDamper);
    }

    // left wall condition
    if(ball.x < (ball.radius)) {
      ball.x = ball.radius + 2;
      ball.vx *= -1;
      ball.vx *= (1 - collisionDamper);
    }
  }
}
function Ball(x, y, vx, vy, color) {
  this.x = x;
  this.y = y;
  this.vx = vx;
  this.vy = vy;
  this.color = color;
  this.origX = x;
  this.origY = y;
  this.radius = 10;
}
function animate(canvas, balls, lastTime, mousePos) {
  window.stats.begin()

  var context = canvas.getContext('2d');

  // update
  var date = new Date();
  var time = date.getTime();
  var timeDiff = time - lastTime;
  updateBalls(canvas, balls, timeDiff, mousePos);
  lastTime = time;

  // clear
  context.clearRect(0, 0, canvas.width, canvas.height);

  // render
  for(var n = 0; n < balls.length; n++) {
    var ball = balls[n];
    context.beginPath();
    context.arc(ball.x, ball.y, ball.radius, 0, 2 * Math.PI, false);
    context.fillStyle = ball.color;
    context.fill();
  }

  window.COULD_NOT_ANIMATE_EVEN_ONCE = false
  window.stats.end()
  // request new frame
  requestAnimFrame(function() {
    animate(canvas, balls, lastTime, mousePos);
  });
}
var canvas = document.getElementById('myCanvas');
var balls = initBalls();
var date = new Date();
var time = date.getTime();
/*
 * set mouse position really far away
 * so the mouse forces are nearly obsolete
 */
var mousePos = {
  x: 9999,
  y: 9999
};

canvas.addEventListener('touchmove', function(evt) {
  var pos = getMousePos(canvas, evt);
  mousePos.x = evt.touches[0].pageX // pos.x;
  mousePos.y = evt.touches[0].pageY // pos.y;
});

canvas.addEventListener('touchend', function(evt) {
  mousePos.x = 9999;
  mousePos.y = 9999;
});

document.addEventListener("DOMContentLoaded", function() {
    //animate(canvas, balls, time, mousePos);
})
