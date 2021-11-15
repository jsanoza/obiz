import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

import 'package:sample_app_request/common.dart';
import 'package:sample_app_request/feature/data/remote/models/note_model.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';
import 'package:sample_app_request/feature/presentation/cubit/notelist/note_cubit.dart';

import 'custom_widgets/custom_button.dart';
import 'custom_widgets/custom_dropdown.dart';
import 'custom_widgets/custom_text_input.dart';

class UpdateNotePage extends StatefulWidget {
  NoteEntity noteEntity;

  UpdateNotePage({
    Key? key,
    required this.noteEntity,
  }) : super(key: key);

  @override
  State<UpdateNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<UpdateNotePage> {
  final _noteController = TextEditingController();

  final _key = GlobalKey<ScaffoldState>();
  late NoteCubit noteCubit;
  var _hmSubject;
  var subjectList = [
    {"name": "0", "id": "0"},
    {"name": "1", "id": "1"},
    {"name": "2", "id": "2"},
    {"name": "3", "id": "3"},
    {"name": "4", "id": "4"},
    {"name": "5", "id": "5"},
    {"name": "6", "id": "6"},
    {"name": "7", "id": "7"},
    {"name": "8", "id": "8"},
    {"name": "9", "id": "9"},
    {"name": "10", "id": "10"},
  ];
  var nameTECs = <TextEditingController>[];
  var timeTECs = <TextEditingController>[];
  List<EditHistory> editHistory = [];
  List<String> lastEditedDt = [];
  List<List<String>> weekdaysHolder = [];
  var cards = <Card>[];
  var howmanyCards;
  List<Subject> listOfSub = [];
  List<String> weekdays = [];
  @override
  void initState() {
    // TODO: implement initState
    _noteController.text = widget.noteEntity.note ?? 'empty';
    _hmSubject = subjectList.first;
    noteCubit = BlocProvider.of<NoteCubit>(context);
    _hmSubject = subjectList[int.parse(widget.noteEntity.applyToHowManySubject.toString())];
    howmanyCards = int.parse(widget.noteEntity.applyToHowManySubject.toString());

    createCards();
    super.initState();
  }

  createCards() async {
    await Future.delayed(new Duration(milliseconds: 300));

    print(nameTECs);
    setState(() {
      addCardBaseOnChoice(howmanyCards);
    });
  }

  addNewCard(int howmany) {
    var nameController = TextEditingController();
    var timeController = TextEditingController();
    List<int> selectedDates = [];
    List<String> stringSelectedDates = [];
    var finalAdd = howmany - cards.length;
    setState(() {
      cards.add(createCard(nameController, timeController, selectedDates, stringSelectedDates));
    });
  }

  removeLastCard() {
    if (howmanyCards != cards.length) {
      cards.removeLast();
      nameTECs.removeLast();
      timeTECs.removeLast();
      weekdaysHolder.removeLast();
    }
  }

  addCardBaseOnChoice(int howmany) {
    widget.noteEntity.subject.forEach((element) {
      var nameController = TextEditingController();
      var timeController = TextEditingController();
      List<int> selectedDates = [];
      List<String> stringSelectedDates = [];

      nameController.text = element.subjectName.toString();
      timeController.text = element.subjectTime.toString();

      element.daysOftheWeek.forEach((element) {
        switch (element) {
          case "Monday":
            if (selectedDates.contains(0)) {
              selectedDates.remove(0);
              stringSelectedDates.remove("Monday");
            } else {
              selectedDates.add(0);
              stringSelectedDates.add("Monday");
            }
            break;
          case "Tuesday":
            if (selectedDates.contains(1)) {
              selectedDates.remove(1);
              stringSelectedDates.remove("Tuesday");
            } else {
              selectedDates.add(1);
              stringSelectedDates.add("Tuesday");
            }
            break;
          case "Wednesday":
            if (selectedDates.contains(2)) {
              selectedDates.remove(2);
              stringSelectedDates.remove("Wednesday");
            } else {
              selectedDates.add(2);
              stringSelectedDates.add("Wednesday");
            }
            break;
          case "Thursday":
            if (selectedDates.contains(3)) {
              selectedDates.remove(3);
              stringSelectedDates.remove("Thursday");
            } else {
              selectedDates.add(3);
              stringSelectedDates.add("Thursday");
            }
            break;
          case "Friday":
            if (selectedDates.contains(4)) {
              selectedDates.remove(4);
              stringSelectedDates.remove("Friday");
            } else {
              selectedDates.add(4);
              stringSelectedDates.add("Friday");
            }
            break;
          case "Saturday":
            if (selectedDates.contains(5)) {
              selectedDates.remove(5);
              stringSelectedDates.remove("Saturday");
            } else {
              selectedDates.add(5);
              stringSelectedDates.add("Saturday");
            }
            break;
        }
      });
      cards.add(createCard(nameController, timeController, selectedDates, stringSelectedDates));
    });
  }

  Card createCard(TextEditingController nc, TextEditingController tc, List<int> selected, List<String> stringSelectedDates) {
    var nameController = TextEditingController();
    var timeController = TextEditingController();
    List<String> updateSelectedDates = [];

    weekdaysHolder.add(updateSelectedDates);
    timeTECs.add(tc);
    nameTECs.add(nc);

    stringSelectedDates.forEach((element) {
      updateSelectedDates.add(element);
    });

    // nameController = nc;
    // timeController = tc;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28.0, top: 18),
                child: Text(
                  'Subject ${cards.length + 1}',
                  style: GoogleFonts.firaSansCondensed(
                    color: Colors.white,
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: ITextFieldInputBoxx(
                    hintText: "Type Subject Name...",
                    tooltipMessage: "Enter Subject Name",
                    controller: nc,
                    validator: null,
                    suffixIcon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: tc, // add this line.
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: "Time",
                        labelStyle: GoogleFonts.firaSansCondensed(
                          color: Colors.white,
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintStyle: GoogleFonts.firaSansCondensed(
                          color: Colors.white,
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      onTap: () async {
                        TimeOfDay time = TimeOfDay.now();
                        FocusScope.of(context).requestFocus(new FocusNode());

                        TimeOfDay? picked = await showTimePicker(context: context, initialTime: time);
                        if (picked != null && picked != time) {
                          tc.text = picked.format(context); // add this line.
                          setState(() {
                            print(tc.text);
                            time = picked;
                          });
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'cant be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GroupButton(
              spacing: 5,
              isRadio: false,
              direction: Axis.horizontal,
              selectedButtons: selected,
              onSelected: (index, isSelected) {
                switch (index) {
                  case 0:
                    if (updateSelectedDates.contains("Monday")) {
                      updateSelectedDates.remove("Monday");
                    } else {
                      updateSelectedDates.add("Monday");
                    }
                    break;
                  case 1:
                    if (updateSelectedDates.contains("Tuesday")) {
                      updateSelectedDates.remove("Tuesday");
                    } else {
                      updateSelectedDates.add("Tuesday");
                    }
                    break;
                  case 2:
                    if (updateSelectedDates.contains("Wednesday")) {
                      updateSelectedDates.remove("Wednesday");
                    } else {
                      updateSelectedDates.add("Wednesday");
                    }
                    break;
                  case 3:
                    if (updateSelectedDates.contains("Thursday")) {
                      updateSelectedDates.remove("Thursday");
                    } else {
                      updateSelectedDates.add("Thursday");
                    }
                    break;
                  case 4:
                    if (updateSelectedDates.contains("Friday")) {
                      updateSelectedDates.remove("Friday");
                    } else {
                      updateSelectedDates.add("Friday");
                    }
                    break;
                  case 5:
                    if (updateSelectedDates.contains("Saturday")) {
                      updateSelectedDates.remove("Saturday");
                    } else {
                      updateSelectedDates.add("Saturday");
                    }
                    break;
                }
                print(updateSelectedDates);
              },
              buttons: const ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
              buttonWidth: 40,
              selectedTextStyle: GoogleFonts.firaSansCondensed(
                color: Colors.white,
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              unselectedTextStyle: GoogleFonts.firaSansCondensed(
                color: Colors.black,
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              selectedColor: const Color.fromARGB(255, 25, 178, 238),
              unselectedColor: Colors.white,
              selectedBorderColor: const Color.fromARGB(255, 25, 178, 238),
              unselectedBorderColor: Colors.grey[500],
              borderRadius: BorderRadius.circular(5.0),
              selectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
              unselectedShadow: const <BoxShadow>[BoxShadow(color: Colors.transparent)],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Update Note',
          style: GoogleFonts.firaSansCondensed(
            color: Colors.white,
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'How many subjects?',
                    style: GoogleFonts.firaSansCondensed(
                      color: Colors.white,
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${cards.length}',
                    style: GoogleFonts.firaSansCondensed(
                      color: Colors.white,
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Scrollbar(
              child: Padding(
                padding: const EdgeInsets.only(left: 28.0, top: 18),
                child: TextFormField(
                  minLines: 10,
                  maxLines: 10,
                  controller: _noteController,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Type note here...'),
                ),
              ),
            ),
            SizedBox(
              width: Get.width,
              // height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: cards.length,
                  itemBuilder: (BuildContext context, int index) {
                    return cards[index];
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10, bottom: 30),
                  child: IButton.primary(
                    text: '+',
                    height: 46.0,
                    width: 56,
                    onTap: () {
                      setState(() {
                        addNewCard(1);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10, bottom: 30),
                  child: IButton.primary(
                    text: '-',
                    height: 46.0,
                    width: 56,
                    onTap: () {
                      setState(() {
                        removeLastCard();
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10, bottom: 30),
              child: IButton.primary(
                text: 'Edit',
                height: 46.0,
                width: MediaQuery.of(context).size.width,
                onTap: () {
                  _addNewNote();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewNote() {
    if (_noteController.text.isEmpty) {
      snackBarError('Type a note...', _key);
      return;
    }
    for (int i = 0; i < cards.length; i++) {
      var name = nameTECs[i].text;
      var time = timeTECs[i].text;
      weekdaysHolder[i].forEach((element) {
        weekdays.add(element);
      });
      listOfSub.add(Subject(daysOftheWeek: weekdays, subjectName: name, subjectTime: time));
      weekdays = [];
    }

    BlocProvider.of<NoteCubit>(context).updateNote(
      NoteEntity(
        note: _noteController.text,
        noteId: widget.noteEntity.noteId,
        timeStamp: widget.noteEntity.timeStamp,
        subject: listOfSub,
        editHistory: editHistory,
        lastEditedDt: lastEditedDt,
        creatorcolor: widget.noteEntity.creatorcolor,
        applyToHowManySubject: int.parse(_hmSubject['id']).toString(),
        uid: widget.noteEntity.uid,
      ),
    );
    Future.delayed(Duration(milliseconds: 400), () {
      Get.back();
    });
  }
}
