import 'package:chess_hill_climbing/model/queen.dart';
import 'package:chess_hill_climbing/utility/hill_climbing.dart';
import 'package:chess_hill_climbing/widget/board_chess.dart';
import 'package:chess_hill_climbing/widget/board_queen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

enum Hill { steepest_hill_climbing, steepest_hill_climbing_sideways }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _editingBoardSizeController = TextEditingController();

  List<Queen>? listQueen = null;
  String _result = '';

  Hill? _hill = Hill.steepest_hill_climbing;

  final focusNode = FocusNode();

  bool _isButtonDisabled = false;

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
                      focusNode: focusNode,
                      decoration:
                          InputDecoration.collapsed(hintText: 'Board size'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    title: Text('steepest hill climbing'),
                    leading: Radio<Hill>(
                      groupValue: _hill,
                      value: Hill.steepest_hill_climbing,
                      onChanged: (value) {
                        setState(() {
                          _hill = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('steepest hill climbing sideways'),
                    leading: Radio<Hill>(
                      groupValue: _hill,
                      value: Hill.steepest_hill_climbing_sideways,
                      onChanged: (value) {
                        setState(() {
                          _hill = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          onPressed: () {
                            focusNode.requestFocus();
                            setState(() {
                              listQueen = null;
                              _hill = Hill.steepest_hill_climbing;
                              _isButtonDisabled = false;
                            });
                          },
                          child: Text('Restart'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _isButtonDisabled
                              ? null
                              : () {
                                  setState(() {
                                    _isButtonDisabled = true;
                                  });
                                  switch (_hill) {
                                    case Hill.steepest_hill_climbing:
                                      steepest_hill_climbing(
                                              listQueen!,
                                              int.parse(
                                                  _editingBoardSizeController
                                                      .text))
                                          .listen((res) {
                                        setState(() {
                                          listQueen = res;
                                        });
                                      }).onDone(() {
                                        setState(() {
                                          _isButtonDisabled = false;
                                        });
                                      });
                                      break;
                                    case Hill.steepest_hill_climbing_sideways:
                                      steepest_hill_climbing_sideways(
                                              listQueen!,
                                              int.parse(
                                                  _editingBoardSizeController
                                                      .text))
                                          .listen((res) {
                                        setState(() {
                                          listQueen = res;
                                        });
                                      }).onDone(() {
                                        setState(() {
                                          _isButtonDisabled = false;
                                        });
                                      });
                                      break;
                                    default:
                                  }
                                },
                          child: Text('Start'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (listQueen != null &&
                      determine_h_cost(listQueen!,
                              int.parse(_editingBoardSizeController.text)) ==
                          0)
                    Column(
                      children: [
                        Text(_isButtonDisabled ? '...' : 'Result:'),
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
