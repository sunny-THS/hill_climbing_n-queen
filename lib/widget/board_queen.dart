import 'dart:math';

import 'package:chess_hill_climbing/model/my_offset.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../model/queen.dart';

class BoardQueen extends StatefulWidget {
  BoardQueen({super.key, required this.size, required this.fn, this.listQueen});
  final int size;
  List<Queen>? listQueen;
  Function fn;

  @override
  State<BoardQueen> createState() => _BoardQueenState();
}

class _BoardQueenState extends State<BoardQueen> {
  final List<Queen> _listQueen = [];

  @override
  Widget build(BuildContext context) {
    generateRandomBoard();
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: widget.size * widget.size,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.size,
        ),
        itemBuilder: (context, index) {
          return _listQueen[index].state ? WhiteQueen() : const SizedBox();
        },
      ),
    );
  }

  void generateRandomBoard() {
    try {
      _listQueen.clear();
      _listQueen.addAll(widget.listQueen!);
    } catch (e) {
      _listQueen.clear();
      for (var i = 0; i < widget.size; i++) {
        final j = widget.size <= 1 ? 0 : Random().nextInt(widget.size - 1);
        final row = List.generate(widget.size, (index) => Queen());
        row[j].state = true;
        _listQueen.addAll(row);
      }
    } finally {
      widget.fn(List<Queen>.generate(
          _listQueen.length, (index) => _listQueen[index]));
    }
  }
}
