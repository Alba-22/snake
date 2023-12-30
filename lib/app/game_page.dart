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
          foodPosition = random.nextInt(numberOfSquares);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width - (fieldPadding * 2);
    final fieldHeight = (MediaQuery.of(context).size.height * 0.9) - (fieldPadding * 2);

    final blockSizeFromHeight = (fieldHeight / numberOfRows);
    final blockSizeFromWidth = (fieldWidth / numberOfColumns);

    final blockSize = min(blockSizeFromHeight, blockSizeFromWidth);

    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (value) {
          setState(() {
            if (value.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
              currentDirection = Direction.top;
              gameState = GameState.playing;
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
              currentDirection = Direction.bottom;
              gameState = GameState.playing;
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              currentDirection = Direction.right;
              gameState = GameState.playing;
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              currentDirection = Direction.left;
              gameState = GameState.playing;
            } else if (value.isKeyPressed(LogicalKeyboardKey.space)) {
              if (gameState == GameState.idle) {
                gameState = GameState.playing;
              } else if (gameState == GameState.playing) {
                gameState = GameState.idle;
              }
            } else if (value.isKeyPressed(LogicalKeyboardKey.keyR)) {
              snake = Snake();
              gameState = GameState.idle;
            }
          });
        },
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).padding.top,
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
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.red,
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
