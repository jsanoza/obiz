import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:sample_app_request/common.dart';
import 'package:sample_app_request/feature/data/remote/models/note_model.dart';
import 'package:sample_app_request/feature/date_formatter.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';
import 'package:sample_app_request/feature/presentation/cubit/notelist/note_cubit.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_dropdown.dart';
import 'package:sample_app_request/feature/presentation/pages/custom_widgets/custom_text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_widgets/custom_button.dart';
import 'home_page.dart';

class AddNewNotePage extends StatefulWidget {
  String uid;

  AddNewNotePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<AddNewNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {
  final _noteController = TextEditingController();
  final _key = GlobalKey<ScaffoldState>();

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
  var _hmSubject;
  var nameTECs = <TextEditingController>[];
  var timeTECs = <TextEditingController>[];
  var cards = <Card>[];
  List<List<String>> weekdaysHolder = [];
  List<String> weekdays = [];
  List<Subject> listOfSub = [];
  List<EditHistory> editHistory = [];
  List<String> lastEditedDt = [];
  var hello;
  @override
  void initState() {
    // TODO: implement initState
    _noteController.addListener(() {
      setState(() {
        print(_noteController.text);
      });
    });

    Future.delayed(Duration(milliseconds: 2500), () {
      getUserColor();
    });

    _hmSubject = subjectList.first;
    super.initState();
  }

  getUserColor() async {
    await SharedPreferences.getInstance().then((value) {
      hello = value.getString('creatorColor');

      print('this is color $hello from initstate');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Add Note',
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
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
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
                    CustomDropdownButton(
                      value: _hmSubject,
                      items: subjectList
                          .map((f) => DropdownMenuItem(
                                value: f,
                                child: Text(f["name"] ?? ''),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _hmSubject = value;
                          nameTECs = [];
                          timeTECs = [];
                          cards.clear();
                          addCardBaseOnChoice(int.parse(_hmSubject['id']));
                        });
                      },
                    ),
                  ],
                ),
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
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 10, bottom: 30),
              child: IButton.primary(
                text: 'Submit',
                height: 46.0,
                width: MediaQuery.of(context).size.width,
                onTap: () {
                  _addNewNote();
                  Get.back();
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
      snackBarError('Type a note..', _key);
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

    BlocProvider.of<NoteCubit>(context).addNote(
      NoteEntity(
        note: _noteController.text,
        timeStamp: Timestamp.now(),
        uid: widget.uid,
        subject: listOfSub,
        editHistory: editHistory,
        lastEditedDt: lastEditedDt,
        creatorcolor: hello,
        applyToHowManySubject: int.parse(_hmSubject['id']).toString(),
      ),
    );
  }

  addCardBaseOnChoice(int howmany) {
    for (var i = 0; i < howmany; i++) {
      cards.add(createCard());
    }
  }

  Card createCard() {
    var nameController = TextEditingController();
    var timeController = TextEditingController();
    List<String> selectedDate = [];
    nameTECs.add(nameController);
    timeTECs.add(timeController);
    weekdaysHolder.add(selectedDate);
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
                    controller: nameController,
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
                      controller: timeController, // add this line.
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
                          timeController.text = picked.format(context); // add this line.
                          setState(() {
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
              onSelected: (index, isSelected) {
                switch (index) {
                  case 0:
                    if (selectedDate.contains("Monday")) {
                      selectedDate.remove("Monday");
                    } else {
                      selectedDate.add("Monday");
                    }
                    break;
                  case 1:
                    if (selectedDate.contains("Tuesday")) {
                      selectedDate.remove("Tuesday");
                    } else {
                      selectedDate.add("Tuesday");
                    }
                    break;
                  case 2:
                    if (selectedDate.contains("Wednesday")) {
                      selectedDate.remove("Wednesday");
                    } else {
                      selectedDate.add("Wednesday");
                    }
                    break;
                  case 3:
                    if (selectedDate.contains("Thursday")) {
                      selectedDate.remove("Thursday");
                    } else {
                      selectedDate.add("Thursday");
                    }
                    break;
                  case 4:
                    if (selectedDate.contains("Friday")) {
                      selectedDate.remove("Friday");
                    } else {
                      selectedDate.add("Friday");
                    }
                    break;
                  case 5:
                    if (selectedDate.contains("Saturday")) {
                      selectedDate.remove("Saturday");
                    } else {
                      selectedDate.add("Saturday");
                    }
                    break;
                }
                print(selectedDate);
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
}
