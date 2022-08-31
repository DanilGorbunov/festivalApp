import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ball.dart';
import 'button.dart';
import 'missile.dart';
import 'player.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { LEFT, RIGHT }

class _HomePageState extends State<HomePage> {

  static double playerX = 0;

  double missileX = playerX;
  // double missileY = 1;
  double missileHeight = 10;
  bool midShot = false;

  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = direction.LEFT;

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60;

    Timer.periodic(Duration(milliseconds: 10), (timer) {

      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      setState(() {
        ballY = heightToPosition(height);
      });



      if (ballX - 0.005 < -1) {
        ballDirection = direction.RIGHT;
      } else if (ballX + 0.005 > 1) {
        ballDirection = direction.LEFT;
      }

      if (ballDirection == direction.LEFT) {
        setState(() {
          ballX -= 0.005;
          });
       } else if (ballDirection == direction.RIGHT) {
        setState(() {
          ballX += 0.005;
        });
      }

      if (playerDies()) {
        timer.cancel();
        _showDialogs();
      }

      time += 0.1;
      });
    }

    void _showDialogs() {
      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey,
          title: Text('You dead bro!',
          style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }


  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
        // nothing
      } else {
        playerX -= 0.1;
      }
     if (!midShot) {
       missileX = playerX;
     }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        // nothing
      } else {
        playerX += 0.1;
      }
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void fireMissile() {
 if (midShot == false){
 Timer.periodic(Duration(milliseconds: 20), (timer) {
    midShot = true;

    setState(() {
      missileHeight += 10;
    });

    if(missileHeight > MediaQuery.of(context).size.height * 3/4 ) {
      resetMissile();
      timer.cancel();
     // midShot = false;
    }
    if (ballY > heightToPosition(missileHeight)
        && (ballX - missileX).abs() < 0.03) {
      resetMissile();
      ballX = 5;
      timer.cancel();
    }
    });
   }
  }

  double heightToPosition (double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10;
    midShot = false;
  }

  bool playerDies() {
    if((ballX-playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }






  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
        if(event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
          children: [
            Expanded(
              flex: 3,
                child: Container(
                  color: Colors.pink[100],
                  child: Center(
                    child: Stack(
                      children: [
                          MyBall(
                            ballX: ballX,
                            ballY: ballY,
                          ),
                          MyMissile(
                            height: missileHeight,
                            missileX: missileX,
                          ),
                          MyPlayer(
                            playerX: playerX,
                          ),
                      ],
                    ),
                  )
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      icon: Icons.play_arrow,
                      function: startGame,
                    ),
                    MyButton(
                      icon: Icons.arrow_back,
                      function: moveLeft,
                    ),
                    MyButton(
                      icon: Icons.arrow_upward,
                      function: fireMissile,
                    ),
                    MyButton(
                      icon: Icons.arrow_forward,
                      function: moveRight,
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
    );

  }
}
