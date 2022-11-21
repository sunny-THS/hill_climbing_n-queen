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
  int firstH = 0;
  TextEditingController _editingBoardSizeController = TextEditingController();

  List<Queen>? listQueen = [
    Queen(state: true),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: true),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: true),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: true),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: true),
    Queen(state: false),
    Queen(state: true),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: true),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: true),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
    Queen(state: false),
  ];
  String _result = '';

  Hill? _hill = Hill.steepest_hill_climbing;

  final focusNode = FocusNode();

  bool _isButtonDisabled = false;

  int _step = 0;

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
                  // Text(
                  //     'h = ${determine_h_cost(listQueen ?? [], int.parse(_editingBoardSizeController.text))}'),
                  // const SizedBox(height: 10),
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
                              _result = '';
                              _isButtonDisabled = false;
                              _step = 0;
                              firstH = 0;
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

                                    if (firstH == 0)
                                      firstH = determine_h_cost(
                                          listQueen!,
                                          int.parse(_editingBoardSizeController
                                              .text));
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
                                          _step++;
                                        });
                                      }).onDone(() {
                                        setState(() {
                                          _result =
                                              'h = ${determine_h_cost(listQueen!, int.parse(_editingBoardSizeController.text))}\nstep = $_step';
                                          _isButtonDisabled = false;
                                          _step = 0;
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
                                          _step++;
                                        });
                                      }).onDone(() {
                                        setState(() {
                                          _result =
                                              'h = ${determine_h_cost(listQueen!, int.parse(_editingBoardSizeController.text))}\nstep = $_step';
                                          _isButtonDisabled = false;
                                          _step = 0;
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
                  firstH != 0 ? Text('First h: $firstH') : const SizedBox(),
                  const SizedBox(height: 14),
                  if (_result.isNotEmpty)
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Result:'),
                          Text('$_result'),
                        ],
                      ),
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
