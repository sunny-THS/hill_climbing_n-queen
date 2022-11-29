import 'package:flutter/material.dart';

class BoardChess extends StatefulWidget {
  const BoardChess({super.key, required this.size});
  final int size;

  @override
  State<BoardChess> createState() => _BoardChessState();
}

class _BoardChessState extends State<BoardChess> {
  bool isZiczac = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: widget.size * widget.size,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.size,
        ),
        itemBuilder: (context, index) {
          bool isZiczacBox;
          if (index % widget.size == 0 && widget.size % 2 == 0) {
            isZiczac = !isZiczac;
          }

          isZiczacBox = isZiczac ? index % 2 != 0 : index % 2 == 0;

          return Container(
            // child: Text('$index'),
            color: isZiczacBox ? Color(0xFF7d411c) : Color(0xffe0d0b3),
          );
        },
      ),
    );
  }
}
