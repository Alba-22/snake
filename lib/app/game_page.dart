import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake/app/constants.dart';
import 'package:flutter_snake/app/snake.dart';

enum GameState {
  idle,
  playing,
  gameOver,
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Snake snake = Snake();

  GameState gameState = GameState.idle;

  late Timer timer;

  final random = Random();
  late int foodPosition;

  final stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    foodPosition = random.nextInt(numberOfSquares);

    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (gameState != GameState.gameOver) {
          update();
        }
      },
    );
  }

  int points = 0;

  Direction currentDirection = Direction.bottom;

  // GameLoop
  void update() {
    setState(() {
      if (snake.collidedItself) {
        gameState = GameState.gameOver;
        return;
      }
      if (gameState == GameState.playing) {
        final ate = snake.head == foodPosition;

        switch (currentDirection) {
          case Direction.top:
            snake.switchToTop(ate);
          case Direction.bottom:
            snake.switchToBottom(ate);
          case Direction.right:
            snake.switchToRight(ate);
          case Direction.left:
            snake.switchToLeft(ate);
          default:
        }
        if (ate) {
          points++;
          foodPosition = random.nextInt(numberOfSquares);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width - (fieldPadding * 2);
    final fieldHeight = (MediaQuery.of(context).size.height * 0.8) - (fieldPadding * 2);

    final blockSizeFromHeight = (fieldHeight / numberOfRows);
    final blockSizeFromWidth = (fieldWidth / numberOfColumns);

    final blockSize = min(blockSizeFromHeight, blockSizeFromWidth);

    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (value) {
          setState(() {
            if (value.isKeyPressed(LogicalKeyboardKey.arrowUp) && gameState == GameState.playing) {
              currentDirection = Direction.top;
              gameState = GameState.playing;
              if (!stopwatch.isRunning) {
                stopwatch.start();
              }
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowDown) &&
                gameState == GameState.playing) {
              currentDirection = Direction.bottom;
              gameState = GameState.playing;
              if (!stopwatch.isRunning) {
                stopwatch.start();
              }
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight) &&
                gameState == GameState.playing) {
              currentDirection = Direction.right;
              gameState = GameState.playing;
              if (!stopwatch.isRunning) {
                stopwatch.start();
              }
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft) &&
                gameState == GameState.playing) {
              currentDirection = Direction.left;
              gameState = GameState.playing;
              if (!stopwatch.isRunning) {
                stopwatch.start();
              }
            } else if (value.isKeyPressed(LogicalKeyboardKey.space)) {
              if (gameState == GameState.idle) {
                stopwatch.start();
                gameState = GameState.playing;
              } else if (gameState == GameState.playing) {
                stopwatch.stop();
                gameState = GameState.idle;
              }
            } else if (value.isKeyPressed(LogicalKeyboardKey.keyR)) {
              stopwatch.reset();
              stopwatch.stop();
              snake = Snake();
              gameState = GameState.idle;
              points = 0;
              foodPosition = random.nextInt(numberOfSquares);
            }
          });
        },
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: min(fieldWidth.toDouble(), 500),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    "SNAKE GAME",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(fieldPadding.toDouble()),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: min(fieldWidth.toDouble(), 500),
                  maxHeight: fieldHeight.toDouble(),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numberOfSquares,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberOfColumns,
                    mainAxisExtent: blockSize,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      height: blockSize,
                      width: blockSize,
                      padding: const EdgeInsets.all(1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: squareColor(index),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: min(fieldWidth.toDouble(), 500),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tempo de Jogo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${stopwatch.elapsed.inHours.toString().padLeft(2, "0")}:${(stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, "0")}:${(stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, "0")}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Pontuação",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          points.toString().padLeft(4, "0"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ],
        ),
      ),
    );
  }

  Color squareColor(int index) {
    if (index == foodPosition) {
      return Colors.green;
    } else if (index == snake.head) {
      return Colors.deepOrange;
    } else if (snake.positions.contains(index)) {
      return Colors.orange;
    }
    return Colors.grey[900]!;
  }
}
