import 'dart:math';

import 'package:chess_hill_climbing/model/my_offset.dart';
import 'package:chess_hill_climbing/model/queen.dart';

// Todo: total collisions on the board
int determine_h_cost(List<Queen> board, int size) {
  int collisions = 0;
  int max_index = board.length;
  for (var i = 0; i < max_index; i++) {
    if (board[i].state) {
      for (var x = 1; x < size; x++) {
        //* checking above current index
        if (i - size * x >= 0) {
          final north = i - size * x;

          //* direction north
          if (board[north].state) {
            collisions++;
          }
          //* direction north west
          if ((north - x) ~/ size == north ~/ size && north - x >= 0) {
            final northWest = north - x;
            if (board[northWest].state) {
              collisions++;
            }
          }
          //* direction north east
          if ((north + x) ~/ size == north ~/ size) {
            final northEast = north + x;
            if (board[northEast].state) {
              collisions++;
            }
          }
        }
        //*==============================
        //* checking below current index
        if (i + size * x < max_index) {
          final south = i + size * x;

          //* direction south
          if (board[south].state) {
            collisions++;
          }
          //* direction south west
          if ((south - x) ~/ size == south ~/ size) {
            final southWest = south - x;
            if (board[southWest].state) {
              collisions++;
            }
          }
          //* direction south east
          if ((south + x) ~/ size == south ~/ size && south + x < max_index) {
            final southEast = south + x;
            if (board[southEast].state) {
              collisions++;
            }
          }
        }
        //*==============================
        //* direction west
        if ((i - x) ~/ size == i ~/ size && i - x >= 0) {
          final west = i - x;
          if (board[west].state) {
            collisions++;
          }
        }
        //* direction east
        if ((i + x) ~/ size == i ~/ size && i + x < max_index) {
          final east = i + x;
          if (board[east].state) {
            collisions++;
          }
        }
      }
    }
  }

  return collisions ~/ 2;
}

List<Queen> generateRandomBoard(size) {
  List<Queen> generateBoard = [];
  for (var i = 0; i < size; i++) {
    final j = Random().nextInt(size - 1);
    List<Queen> newRow = List.generate(size, (index) => Queen());
    newRow[j].state = true;
    generateBoard.addAll(newRow);
  }
  return generateBoard;
}

List<Queen> findChild(List<Queen> board, int size, [sidewaysMove = false]) {
  List<Queen> child = [];
  int current_h_cost = determine_h_cost(board, size);
  Map<int, List<Queen>> same_cost_children = Map();

  for (var row = 0; row < size; row++) {
    for (var col = 0; col < size; col++) {
      List<Queen> tempBoard = board.sublist(0, row * size);

      List<Queen> newRow = List.generate(size, (index) => Queen());
      newRow[col].state = true;
      tempBoard.addAll(newRow);

      tempBoard.addAll(board.sublist((row + 1) * size));

      final temp_h_cost = determine_h_cost(tempBoard, size);

      if (sidewaysMove) {
        if (tempBoard != board) {
          if (temp_h_cost < current_h_cost) {
            child = tempBoard;
            current_h_cost = temp_h_cost;
          } else if (temp_h_cost == current_h_cost) {
            same_cost_children[same_cost_children.length] = tempBoard;
            final x = same_cost_children.length - 1 != 0
                ? Random().nextInt(same_cost_children.length - 1)
                : 0;
            child = same_cost_children[x]!;
          }
        }
      } else {
        if (tempBoard != board && temp_h_cost < current_h_cost) {
          child = tempBoard;
          current_h_cost = temp_h_cost;
        }
      }
    }
  }

  return child;
}

Stream<List<Queen>> steepest_hill_climbing(List<Queen> board, int size) async* {
  List<Queen> currentBoard = board;

  while (true) {
    final nextNode = findChild(currentBoard, size);

    if (nextNode.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield nextNode;
    }

    if (nextNode.isEmpty ||
        nextNode.isNotEmpty && determine_h_cost(nextNode, size) == 0) {
      break;
    }

    currentBoard = nextNode;
  }
}

Stream<List<Queen>> steepest_hill_climbing_sideways(
    List<Queen> board, int size) async* {
  List<Queen> currentBoard = board;

  int maxIterations = 200;

  while ((--maxIterations) != 0) {
    final nextNode = findChild(currentBoard, size, true);

    if (nextNode.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      yield nextNode;
    }

    if (nextNode.isEmpty ||
        nextNode.isNotEmpty && determine_h_cost(nextNode, size) == 0) {
      break;
    }

    currentBoard = nextNode;
  }
}

Stream<List<Queen>> steepest_hill_climbing_random(
    List<Queen> board, int size) async* {
  List<Queen> currentBoard = board;

  int countSameCost = 0;
  int lastCost = 0;
  int currentCost = 0;

  while (true) {
    List<Queen> nextNode = findChild(currentBoard, size, true);

    currentCost = determine_h_cost(nextNode, size);

    if (nextNode.isNotEmpty) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (lastCost != currentCost) {
        lastCost = currentCost;
        countSameCost = 0;
      } else {
        countSameCost = countSameCost > 9 ? 0 : countSameCost + 1;
      }
      yield nextNode;
    }

    if (nextNode.isEmpty || countSameCost == 10) {
      nextNode = generateRandomBoard(size);
    }

    if (determine_h_cost(nextNode, size) == 0) {
      break;
    }

    currentBoard = nextNode;
  }
}
