import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart' as gx;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sample_app_request/app_constants.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';
import 'package:sample_app_request/feature/presentation/cubit/auth/auth_cubit.dart';
import 'package:sample_app_request/feature/presentation/cubit/notelist/note_cubit.dart';
import 'package:sample_app_request/feature/presentation/cubit/user/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'custom_widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  final String uid;

  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var hello;
  var hello2;
  bool isLoaded = false;
  late AutoScrollController controller;
  final scrollDirection = Axis.vertical;
  int counter = -1;
  static const maxCount = 100;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  var colorWidgets = <Widget>[];
  var hexColor;
  var choice;
  bool isChoice = false;
  Future changeColor(Color color) async {
    setState(() => pickerColor = color);
    log(color.toString());
    hexColor = pickerColor.toString().replaceAll("Color(0xff", "");
    hexColor = hexColor.replaceAll(")", "");
    hexColor = hexColor.replaceAll("MaterialColor(", "");
    hexColor = hexColor.replaceAll("primary value: ", "");
    await SharedPreferences.getInstance().then((value) {
      value.setString('creatorColor', hexColor.toString());
      print('this is color $hello from initstate');
    });
    await BlocProvider.of<UserCubit>(context).editColorCreator(UserEntity(color: hexColor));
    Future.delayed(Duration(milliseconds: 300), () {
      gx.Get.back();
    });
  }

  Future function() async {
    // Color currentColor = Colors.limeAccent;
    // List<Color> currentColors = [Colors.limeAccent, Colors.green];

    // void changeColor(Color color) => setState(() => currentColor = color);
    // void changeColors(List<Color> colors) => setState(() => currentColors = colors);
    await SharedPreferences.getInstance().then((value) {
      hello = value.getString('groupName');
      print('this is $hello from initstate');
      hello2 = value.getString('choice');
      setState(() {
        BlocProvider.of<NoteCubit>(context).getNotes(widget.uid, hello);
        isLoaded = true;
      });
    });

    if (hello == "") {
      showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 400),
        context: context,
        pageBuilder: (_, __, ___) {
          return Builder(builder: (context) {
            return Scaffold(
              body: Align(
                alignment: Alignment.center,
                child: Container(
                  child: SizedBox(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 28.0,
                              top: 28,
                            ),
                            child: Text(
                              "Select your group: ",
                              style: GoogleFonts.firaSansCondensed(
                                color: Colors.white,
                                textStyle: Theme.of(context).textTheme.headline4,
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0, bottom: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // var groupEntity = UserEntity(groupName: "Notes A");
                                BlocProvider.of<UserCubit>(context).addUserGroup(UserEntity(groupName: "NotesA"));
                                setState(() {
                                  hello = "NotesA";
                                  BlocProvider.of<NoteCubit>(context).getNotes(widget.uid, hello);
                                });
                                gx.Get.back();
                              },
                              child: Container(
                                // color: Colors.black,
                                height: 70,
                                width: 150,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(width: 2.0, color: Colors.white),
                                    bottom: BorderSide(width: 2.0, color: Colors.white),
                                    left: BorderSide(width: 2.0, color: Colors.white),
                                    right: BorderSide(width: 2.0, color: Colors.white),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "Group A",
                                    style: GoogleFonts.firaSansCondensed(
                                      color: Colors.white,
                                      textStyle: Theme.of(context).textTheme.headline4,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<UserCubit>(context).addUserGroup(UserEntity(groupName: "NotesB"));
                                setState(() {
                                  hello = "NotesB";
                                  BlocProvider.of<NoteCubit>(context).getNotes(widget.uid, hello);
                                });
                                gx.Get.back();
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(width: 2.0, color: Colors.white),
                                    bottom: BorderSide(width: 2.0, color: Colors.white),
                                    left: BorderSide(width: 2.0, color: Colors.white),
                                    right: BorderSide(width: 2.0, color: Colors.white),
                                  ),
                                ),
                                height: 70,
                                width: 150,
                                child: Center(
                                  child: Text(
                                    "Group B",
                                    style: GoogleFonts.firaSansCondensed(
                                      color: Colors.white,
                                      textStyle: Theme.of(context).textTheme.headline4,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
                  margin: const EdgeInsets.only(bottom: 50, left: 12, right: 12),
                  decoration: const BoxDecoration(
                    // color: Colors.white,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color.fromARGB(255, 25, 178, 238), Color.fromARGB(255, 21, 236, 229)],
                    ),
                    border: Border(
                      top: BorderSide(width: 12.0, color: Colors.white),
                      // bottom: BorderSide(width: 16.0, color: Colors.lightBlue.shade900),
                    ),
                    // borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          });
        },
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
            child: child,
          );
        },
      );
    }
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Monday':
        await SharedPreferences.getInstance().then((value) {
          hello2 = value.setString('choice', 'Monday');
        }).then((value) {
          gx.Get.offAll(HomePage(uid: widget.uid), transition: gx.Transition.noTransition);
        });
        break;
      case 'Tuesday':
        await SharedPreferences.getInstance().then((value) {
          hello2 = value.setString('choice', 'Tuesday');
        }).then((value) {
          gx.Get.offAll(HomePage(uid: widget.uid), transition: gx.Transition.noTransition);
        });
        break;
      case 'Wednesday':
        await SharedPreferences.getInstance().then((value) {
          hello2 = value.setString('choice', 'Wednesday');
        }).then((value) {
          gx.Get.offAll(HomePage(uid: widget.uid), transition: gx.Transition.noTransition);
        });
        break;
      case 'Thursday':
        await SharedPreferences.getInstance().then((value) {
          hello2 = value.setString('choice', 'Thursday');
        }).then((value) {
          gx.Get.offAll(HomePage(uid: widget.uid), transition: gx.Transition.noTransition);
        });
        break;
      case 'Friday':
        await SharedPreferences.getInstance().then((value) {
          hello2 = value.setString('choice', 'Friday');
        }).then((value) {
          gx.Get.offAll(HomePage(uid: widget.uid), transition: gx.Transition.noTransition);
        });
        break;
      case 'Saturday':
        await SharedPreferences.getInstance().then((value) {
          hello2 = value.setString('choice', 'Saturday');
        }).then((value) {
          gx.Get.offAll(HomePage(uid: widget.uid), transition: gx.Transition.noTransition);
        });
        break;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2500), () {
      function();
    });
    isChoice = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
            Text(
              hello == null ? "Notes Group" : "Notes Group : $hello",
              style: GoogleFonts.firaSansCondensed(
                color: Colors.white,
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    content: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Choose your color",
                              style: GoogleFonts.firaSansCondensed(
                                color: Colors.white,
                                textStyle: Theme.of(context).textTheme.headline4,
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            height: gx.Get.height,
                            width: gx.Get.width,
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: BlockPicker(
                                pickerColor: currentColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).then((value) {});
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.colorize_outlined, size: 22),
            ),
          ),
          GestureDetector(
            onTap: () {
              BlocProvider.of<AuthCubit>(context).loggedOut();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.logout_outlined, size: 22),
            ),
          ),
        ],
      ),
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (c, noteState) {
          if (noteState is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (noteState is NoteLoaded) {
            return isLoaded == false ? const Center(child: CircularProgressIndicator()) : _bodyWidget(noteState, hello2);
          } else if (noteState is NoteFailure) {
            return isLoaded == false ? const Center(child: CircularProgressIndicator()) : Center(child: _noNotesWidget());
          }
          return isLoaded == false ? const Center(child: CircularProgressIndicator()) : const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 25, 178, 238),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.pushNamed(context, PageConst.addNotePage, arguments: widget.uid);
          }),
    );
  }

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    var colorfinal;
    if (hexColor.length == 8) {
      colorfinal = Color(int.parse("0x$hexColor"));
    }
    return colorfinal;
  }

  Widget _bodyWidget(NoteLoaded noteLoaded, String choice) {
    log(choice);
    return noteLoaded.notes.isEmpty
        ? _noNotesWidget()
        : Column(
            children: [
              Container(
                height: gx.Get.height - 185,
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: noteLoaded.notes.length,
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (_, i) {
                    NoteEntity? noteEntity = noteLoaded.notes[i];
                    Color retrieveColor = getColorFromHex(noteEntity!.creatorcolor.toString());
                    // List<NoteEntity> hello = [];
                    // noteLoaded.notes[i]!.subject.forEach((element) {
                    //   var item = element.daysOftheWeek.firstWhere((i) => i.contains(choice));
                    //   // var index = noteLoaded.notes[i]!.subject.elementAt(int.parse(item));
                    //   log(item.toString());
                    // });
                    return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.updateNotePage, arguments: noteEntity);
                        },
                        onLongPress: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text('Delete'),
                                  content: const Text('Are you sure you want to delete?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          BlocProvider.of<NoteCubit>(context).deleteNote(noteEntity);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes')),
                                    TextButton(onPressed: () => Navigator.pop(context), child: Text('No'))
                                  ],
                                )),
                        child: Card(
                          child: noteEntity == null
                              ? const Text('null')
                              : Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [retrieveColor, retrieveColor],
                                    )),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            noteEntity.note!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.firaSansCondensed(
                                              color: Colors.white,
                                              textStyle: Theme.of(context).textTheme.headline4,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 25),
                                        Text(
                                          DateFormat('dd/MM/yyyy hh:mm:a').format(noteEntity.timeStamp!.toDate()),
                                          style: GoogleFonts.firaSansCondensed(
                                            color: Colors.white,
                                            textStyle: Theme.of(context).textTheme.headline4,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0, bottom: 8, top: 8),
                                              child: Text(
                                                "Editors: ${noteEntity.lastEditedDt.length.toString()}",
                                                style: GoogleFonts.firaSansCondensed(
                                                  color: Colors.white,
                                                  textStyle: Theme.of(context).textTheme.headline4,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w200,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 150,
                                                  child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: noteEntity.lastEditedDt.length,
                                                      itemBuilder: (_, i) {
                                                        Color retrieveColor2 = getColorFromHex(noteEntity.lastEditedDt[i].toString());
                                                        return Container(
                                                          height: 20,
                                                          width: 20,
                                                          decoration: BoxDecoration(
                                                              border: const Border(
                                                                top: BorderSide(width: 2.0, color: Colors.white),
                                                                bottom: BorderSide(width: 2.0, color: Colors.white),
                                                                left: BorderSide(width: 2.0, color: Colors.white),
                                                                right: BorderSide(width: 2.0, color: Colors.white),
                                                              ),
                                                              gradient: LinearGradient(
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                                colors: [retrieveColor2, retrieveColor2],
                                                              )),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                        ));
                  },
                ),
              ),
              // Expanded(
              //     child: Container(
              //   color: Colors.transparent,
              //   width: Get.width,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10, bottom: 30),
              //         child: IButton.primary(
              //           text: "Prev",
              //           height: 46.0,
              //           width: 120,
              //           onTap: () {
              //             // addNewCard(1);
              //           },
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10, bottom: 30),
              //         child: IButton.primary(
              //           text: "Next",
              //           height: 46.0,
              //           width: 100,
              //           onTap: () {
              //             setState(() {
              //               // removeLastCard();
              //             });
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // )),
            ],
          );
  }

  Widget _noNotesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [Icon(Icons.error_outline), Text('no notes')],
      ),
    );
  }
}
