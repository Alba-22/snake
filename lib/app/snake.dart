import 'constants.dart';

class Snake {
  final List<int> _position;
  Direction _currentDirection;

  Snake()
      : _position = [...snakeInitialPosition],
        _currentDirection = Direction.bottom;

  int get size => _position.length;

  List<int> get positions => _position;

  int get head => positions.last;

  bool get collidedItself {
    final tileSet = _position.toSet();
    return tileSet.length != _position.length;
  }

  void switchToTop(bool ate) {
    if (_currentDirection != Direction.bottom) {
      _goTop();
      _currentDirection = Direction.top;
    } else {
      _goBottom();
      _currentDirection = Direction.bottom;
    }
    _checkAte(ate);
  }

  void switchToBottom(bool ate) {
    if (_currentDirection != Direction.top) {
      _goBottom();
      _currentDirection = Direction.bottom;
    } else {
      _goTop();
      _currentDirection = Direction.top;
    }
    _checkAte(ate);
  }

  void switchToRight(bool ate) {
    if (_currentDirection != Direction.left) {
      _goRight();
      _currentDirection = Direction.right;
    } else {
      _goLeft();
      _currentDirection = Direction.left;
    }
    _checkAte(ate);
  }

  void switchToLeft(bool ate) {
    if (_currentDirection != Direction.right) {
      _goLeft();
      _currentDirection = Direction.left;
    } else {
      _goRight();
      _currentDirection = Direction.right;
    }
    _checkAte(ate);
  }

  void _checkAte(bool ate) {
    if (!ate) {
      _position.removeAt(0);
    }
  }

  void _goTop() {
    if (_position.last < numberOfColumns) {
      _position.add((_position.last - numberOfColumns) + numberOfSquares);
    } else {
      _position.add(_position.last - numberOfColumns);
    }
  }

  void _goBottom() {
    if (_position.last > numberOfSquares - numberOfColumns) {
      _position.add((_position.last + numberOfColumns) - numberOfSquares);
    } else {
      _position.add(_position.last + numberOfColumns);
    }
  }

  void _goRight() {
    if ((_position.last + 1) % numberOfColumns == 0) {
      _position.add(_position.last + 1 - numberOfColumns);
    } else {
      _position.add(_position.last + 1);
    }
  }

  void _goLeft() {
    if (_position.last % numberOfColumns == 0) {
      _position.add(_position.last - 1 + numberOfColumns);
    } else {
      _position.add(_position.last - 1);
    }
  }
}
