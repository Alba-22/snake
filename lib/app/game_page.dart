import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake/app/constants.dart';
import 'package:flutter_snake/app/snake.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Snake snake = Snake();

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        update();
      },
    );
  }

  Direction currentDirection = Direction.idle;

  // GameLoop
  void update() {
    setState(() {
      switch (currentDirection) {
        case Direction.top:
          snake.switchToTop(false);
        case Direction.bottom:
          snake.switchToBottom(false);
        case Direction.right:
          snake.switchToRight(false);
        case Direction.left:
          snake.switchToLeft(false);
        default:
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
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
              currentDirection = Direction.bottom;
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
              currentDirection = Direction.right;
            } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
              currentDirection = Direction.left;
            } else if (value.isKeyPressed(LogicalKeyboardKey.space)) {
              currentDirection = Direction.idle;
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
                          color: snake.positions.contains(index) ? Colors.orange : Colors.grey[900],
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: TextStyle(
                              color: snake.positions.contains(index)
                                  ? Colors.black
                                  : Colors.grey.withOpacity(0.5),
                              fontSize: 9,
                            ),
                          ),
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
}
