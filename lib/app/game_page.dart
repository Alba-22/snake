import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_snake/app/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    final fieldWidth = MediaQuery.of(context).size.width - (Constant.fieldPadding * 2);
    final fieldHeight = (MediaQuery.of(context).size.height * 0.9) - (Constant.fieldPadding * 2);

    final blockSizeFromHeight = (fieldHeight / Constant.numberOfRows);
    final blockSizeFromWidth = (fieldWidth / Constant.numberOfColumns);

    final blockSize = min(blockSizeFromHeight, blockSizeFromWidth);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
          ),
          Container(
            margin: EdgeInsets.all(Constant.fieldPadding.toDouble()),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: min(fieldWidth.toDouble(), 500),
                maxHeight: fieldHeight.toDouble(),
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Constant.numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Constant.numberOfColumns,
                  mainAxisExtent: blockSize,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    height: blockSize,
                    width: blockSize,
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == Constant.numberOfSquares - 1
                            ? Colors.orange
                            : Colors.grey[900],
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
    );
  }
}
