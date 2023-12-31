import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake/app/constants.dart';
import 'package:flutter_snake/app/snake.dart';

enum GameState {
  idle,
  starting,
  playing,
  paused,
  gameOver;

  bool get isPaused => this == paused;

  bool get isOver => this == gameOver;

  bool get isPlaying => this == playing;

  bool get isIdle => this == idle;

  bool get isStarting => this == starting;
}

class GameController extends ChangeNotifier {
  int _points = 0;
  final _stopwatch = Stopwatch();
  GameState _gameState = GameState.idle;
  Snake _snake = Snake();
  Direction _currentDirection = Direction.bottom;
  late int _foodPosition;

  int _secondsToStart = 3;

  GameController() {
    _foodPosition = _getRandomPosition;
  }

  void _play() {
    _stopwatch.start();
    _gameState = GameState.playing;
    notifyListeners();
  }

  void _pause() {
    _stopwatch.stop();
    _gameState = GameState.paused;
    notifyListeners();
  }

  Future<void> reset() async {
    _stopwatch.reset();
    _stopwatch.stop();
    _snake = Snake();
    _gameState = GameState.starting;
    _currentDirection = Direction.bottom;
    _points = 0;
    _foodPosition = _getRandomPosition;
    _secondsToStart = 3;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _secondsToStart--;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _secondsToStart--;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _secondsToStart--;
    notifyListeners();
    _play();
  }

  void _gameOver() {
    _gameState = GameState.gameOver;
    _stopwatch.stop();
    notifyListeners();
  }

  void updateGame() {
    if (_gameState.isOver) {
      return;
    }
    if (_snake.collidedItself) {
      _gameOver();
      return;
    }
    if (_gameState.isPlaying) {
      final ate = _snake.head == _foodPosition;

      switch (_currentDirection) {
        case Direction.top:
          _snake.switchToTop(ate);
        case Direction.bottom:
          _snake.switchToBottom(ate);
        case Direction.right:
          _snake.switchToRight(ate);
        case Direction.left:
          _snake.switchToLeft(ate);
      }
      if (ate) {
        _points++;
        _foodPosition = _getRandomPosition;
      }
      notifyListeners();
    }
  }

  void onKeyPress(LogicalKeyboardKey key) {
    if (gameState.isStarting) {
      return;
    }
    switch (key) {
      case LogicalKeyboardKey.arrowUp:
        if (_gameState.isPlaying) {
          _currentDirection = Direction.top;
        }
        if (!_stopwatch.isRunning) {
          _stopwatch.start();
        }
      case LogicalKeyboardKey.arrowDown:
        if (_gameState.isPlaying) {
          _currentDirection = Direction.bottom;
        }

        if (!_stopwatch.isRunning) {
          _stopwatch.start();
        }
      case LogicalKeyboardKey.arrowRight:
        if (_gameState.isPlaying) {
          _currentDirection = Direction.right;
        }
        if (!_stopwatch.isRunning) {
          _stopwatch.start();
        }
      case LogicalKeyboardKey.arrowLeft:
        if (_gameState.isPlaying) {
          _currentDirection = Direction.left;
        }
        if (!_stopwatch.isRunning) {
          _stopwatch.start();
        }
      case LogicalKeyboardKey.space:
        if (_gameState.isPlaying) {
          _pause();
        } else if (_gameState.isPaused || _gameState.isIdle) {
          _play();
        }
      case LogicalKeyboardKey.keyR:
        reset();
    }
    notifyListeners();
  }

  int get _getRandomPosition {
    int randomPosition = Random().nextInt(numberOfSquares);
    while (snake.positions.contains(randomPosition)) {
      randomPosition = Random().nextInt(numberOfSquares);
    }
    return randomPosition;
  }

  int get points => _points;

  Duration get elapsedPlaytime => _stopwatch.elapsed;

  GameState get gameState => _gameState;

  Snake get snake => _snake;

  int get foodPosition => _foodPosition;

  int get secondsToStart => _secondsToStart;
}
