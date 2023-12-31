import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake/app/constants.dart';
import 'package:flutter_snake/app/game_controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Timer timer;

  final controller = GameController();

  Timer? startingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.reset();
    });
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        controller.updateGame();
      },
    );
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
          if (value is RawKeyDownEvent) {
            controller.onKeyPress(value.logicalKey);
          }
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
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        Opacity(
                          opacity: controller.gameState.isStarting ? 0.5 : 1,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: numberOfSquares,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: numberOfColumns,
                              mainAxisExtent: blockSize,
                            ),
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: controller,
                                builder: (context, child) {
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
                              );
                            },
                          ),
                        ),
                        if (controller.gameState.isStarting)
                          Center(
                            child: Text(
                              controller.secondsToStart.toString(),
                              style: const TextStyle(
                                fontSize: 140,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
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
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    final elapsed = controller.elapsedPlaytime;
                    return Row(
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
                              "${elapsed.inHours.toString().padLeft(2, "0")}:${(elapsed.inMinutes % 60).toString().padLeft(2, "0")}:${(elapsed.inSeconds % 60).toString().padLeft(2, "0")}",
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
                              controller.points.toString().padLeft(4, "0"),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
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
    if (index == controller.foodPosition) {
      return Colors.green;
    } else if (index == controller.snake.head) {
      return Colors.orange[800]!;
    } else if (controller.snake.positions.contains(index)) {
      return Colors.orange;
    }
    return Colors.grey[900]!;
  }
}
