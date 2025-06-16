import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(TapTheDotGame());
}

class TapTheDotGame extends StatelessWidget {
  const TapTheDotGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DotTapper',
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  double dotX = 0.0;
  double dotY = 0.0;
  int timeLeft = 30;
  Timer? gameTimer;
  bool gameStarted = false;
  Random random = Random();

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      gameStarted = true;
    });

    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          gameStarted = false;
          gameTimer?.cancel();
        }
      });
    });

    moveDot();
  }

  void moveDot() {
    if (!gameStarted) return;
    setState(() {
      dotX = random.nextDouble();
      dotY = random.nextDouble();
    });
    Future.delayed(Duration(milliseconds: 800), moveDot);
  }

  void tapDot() {
    if (!gameStarted) return;
    setState(() {
      score++;
    });
  }

  void stopGame() {
    setState(() {
      gameStarted = false;
      gameTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text("Tap the Dot"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              gameStarted ? "Time Left: $timeLeft" : "Tap to Start",
              style: TextStyle(fontSize: 24),
            ),
          ),
          if (gameStarted)
            Positioned(
              left: dotX * (MediaQuery.of(context).size.width - 60),
              top: dotY * (MediaQuery.of(context).size.height - 160),
              child: GestureDetector(
                onTap: tapDot,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Score: $score",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: startGame,
                        child: Text(gameStarted ? "Restart" : "Start Game"),
                      ),
                      SizedBox(width: 16),
                      if (gameStarted)
                        ElevatedButton(
                          onPressed: stopGame,
                          style: ElevatedButton.styleFrom(),
                          child: Text("Stop Game"),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
