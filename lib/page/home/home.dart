import 'package:chess_hill_climbing/model/queen.dart';
import 'package:chess_hill_climbing/utility/hill_climbing.dart';
import 'package:chess_hill_climbing/widget/board_chess.dart';
import 'package:chess_hill_climbing/widget/board_queen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _editingBoardSizeController = TextEditingController();

  List<Queen>? listQueen = null;
  String _result = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingBoardSizeController.text = '8';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Stack(
                  children: [
                    BoardChess(
                      size: int.parse(_editingBoardSizeController.text),
                    ),
                    BoardQueen(
                      listQueen: listQueen,
                      size: int.parse(_editingBoardSizeController.text),
                      fn: (val) {
                        listQueen = val;
                      },
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Board size'),
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          try {
                            if (1 > int.parse(val) || int.parse(val) > 20) {
                              return;
                            }
                          } catch (e) {
                            return;
                          }
                          setState(() {
                            listQueen = null;
                          });
                        }
                      },
                      controller: _editingBoardSizeController,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration.collapsed(hintText: 'Board size'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        steepest_hill_climbing(listQueen!,
                                int.parse(_editingBoardSizeController.text))
                            .listen((res) {
                          setState(() {
                            listQueen = res;
                          });
                        });
                      },
                      child: Text('Start'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (listQueen != null &&
                      determine_h_cost(listQueen!,
                              int.parse(_editingBoardSizeController.text)) ==
                          0)
                    Column(
                      children: [
                        Text('Result:'),
                        Container(
                          height: 30,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('$_result'),
                        ),
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
