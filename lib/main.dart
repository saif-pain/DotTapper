import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const DotTapper());
}

class DotTapper extends StatelessWidget {
  const DotTapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DotTapper',
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum Difficulty { easy, medium, hard }

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  double dotX = 0.0;
  double dotY = 0.0;
  int timeLeft = 30;
  bool gameStarted = false;
  Timer? gameTimer;
  Random random = Random();
  Difficulty difficulty = Difficulty.easy;

  late double screenWidth;
  late double screenHeight;

  int get dotSpeed {
    switch (difficulty) {
      case Difficulty.easy:
        return 1000;
      case Difficulty.medium:
        return 600;
      case Difficulty.hard:
        return 400;
    }
  }

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 30;
      gameStarted = true;
    });

    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        stopGame();
      }
    });

    moveDot();
  }

  void moveDot() {
    if (!gameStarted) return;

    double maxX = screenWidth - 60;
    double maxY = screenHeight - 200;

    setState(() {
      dotX = random.nextDouble() * maxX;
      dotY = random.nextDouble() * maxY;
    });

    Future.delayed(Duration(milliseconds: dotSpeed), moveDot);
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

  void selectDifficulty(Difficulty selected) {
    setState(() => difficulty = selected);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("DotTapper"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              gameStarted ? "⏱ Time Left: $timeLeft" : "Tap to Start",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),
          if (gameStarted)
            Positioned(
              left: dotX,
              top: dotY,
              child: GestureDetector(
                onTap: tapDot,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(2, 4),
                      ),
                    ],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "🎯 Score: $score",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: startGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text(gameStarted ? "Restart" : "Start Game"),
                      ),
                      const SizedBox(width: 16),
                      if (gameStarted)
                        ElevatedButton(
                          onPressed: stopGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text("Stop"),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    children: [
                      const Text(
                        "🎮 Select Difficulty",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildDifficultyButton("Easy", Difficulty.easy),
                          buildDifficultyButton("Medium", Difficulty.medium),
                          buildDifficultyButton("Hard", Difficulty.hard),
                        ],
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

  Widget buildDifficultyButton(String label, Difficulty value) {
    final isSelected = difficulty == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          side: const BorderSide(color: Colors.blueAccent),
        ),
        onPressed: () => selectDifficulty(value),
        child: Text(label),
      ),
    );
  }
}
