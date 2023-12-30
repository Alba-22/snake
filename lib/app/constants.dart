const int numberOfColumns = 20;
const int numberOfRows = 30;
const int numberOfSquares = numberOfRows * numberOfColumns;
const int fieldPadding = 8;
List<int> snakeInitialPosition = List.generate(
  5,
  (index) => 210 + (index * numberOfColumns),
);

enum Direction { top, left, bottom, right, idle }
