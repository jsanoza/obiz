import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';

// class NoteModel extends NoteEntity{
//   NoteModel({
//     required this.applyToHowManySubject,
//     required this.note,
//     required this.noteId,
//     required this.timeStamp,
//     required this.uid,
//     required this.editHistory,
//     required this.lastEditedDt,
//     required this.subject,
//   });

//   String applyToHowManySubject;
//   String note;
//   int noteId;
//   Timestamp timeStamp;
//   String uid;
//   List<EditHistory> editHistory;
//   List<String> lastEditedDt;
//   List<Subject> subject;
// }

// class EditHistory {
//   EditHistory({
//     required this.editedBy,
//     required this.editedTime,
//   });

//   int editedBy;
//   int editedTime;
// }

// class Subject {
//   Subject({
//     required this.subjectName,
//     required this.daysOftheWeek,
//   });

//   String subjectName;
//   List<String> daysOftheWeek;
// }

class NoteModel extends NoteEntity {
  NoteModel({
    required this.applyToHowManySubject,
    required this.note,
    required this.noteId,
    required this.timeStamp,
    required this.uid,
    required this.editHistory,
    required this.lastEditedDt,
    required this.subject,
    required this.creatorcolor,
  }) : super(
          applyToHowManySubject: applyToHowManySubject,
          note: note,
          noteId: noteId,
          timeStamp: timeStamp,
          uid: uid,
          editHistory: editHistory,
          lastEditedDt: lastEditedDt,
          subject: subject,
          creatorcolor: creatorcolor,
        );

  String? applyToHowManySubject;
  String? note;
  String? noteId;
  Timestamp? timeStamp;
  String? uid;
  List<EditHistory> editHistory;
  List<String> lastEditedDt;
  List<Subject> subject;
  String? creatorcolor;

  // factory NoteModel.fromMap(Map<String, dynamic> json) => NoteModel(
  //       applyToHowManySubject: json["applyToHowManySubject"] == null ? null : json["applyToHowManySubject"],
  //       note: json["note"] == null ? null : json["note"],
  //       noteId: json["noteId"] == null ? null : json["noteId"],
  //       timeStamp: json["timeStamp"] == null ? null : json["timeStamp"],
  //       uid: json["uid"] == null ? null : json["uid"],
  //       editHistory: json["editHistory"] == null ? null : List<EditHistory>.from(json["editHistory"].map((x) => EditHistory.fromMap(x))),
  //       lastEditedDt: json["lastEditedDt"] == null ? null : List<String>.from(json["lastEditedDt"].map((x) => x)),
  //       subject: json["subject"] == null ? null : List<Subject>.from(json["subject"].map((x) => Subject.fromMap(x))),
  //     );

  factory NoteModel.fromSnapshot(Map<String, dynamic> json) {
    // print('noteMap: ${NoteModel}');
    return NoteModel(
      applyToHowManySubject: json['applyToHowManySubject'],
      note: json['note'],
      timeStamp: json['timeStamp'],
      uid: json['uid'],
      noteId: json['noteId'],
      creatorcolor: json['creatorcolor'],
      //       editHistory = json['editHistory'] != null ? new EditHistory.fromJson(json['rating']) : null;
      // comments = json['comments'] != null ? new Comments.fromJson(json['comments']) : null;
      // images = json['images'] != null ? new Images.fromJson(json['images']) : null;
      editHistory: List.from(json['editHistory']).map((item) => EditHistory.fromMap(item)).toList(),
      lastEditedDt: List<String>.from(json["lastEditedDt"].map((x) => x)),
      subject: List.from(json['subject']).map((item) => Subject.fromMap(item)).toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        "applyToHowManySubject": applyToHowManySubject == null ? null : applyToHowManySubject,
        "note": note == null ? null : note,
        "noteId": noteId == null ? null : noteId,
        "timeStamp": timeStamp == null ? null : timeStamp,
        "uid": uid == null ? null : uid,
        "creatorcolor": creatorcolor == null ? null : creatorcolor,
        "editHistory": editHistory == null ? null : List.from(editHistory.map((x) => x.toMap())),
        "lastEditedDt": lastEditedDt == null ? null : List.from(lastEditedDt.map((x) => x)),
        "subject": subject == null ? null : List.from(subject.map((x) => x.toMap())),
      };

  toDocument() {}
}

class EditHistory {
  EditHistory({
    required this.editedBy,
    required this.editedTime,
  });

  String editedBy;
  String editedTime;

  factory EditHistory.fromMap(Map<String, dynamic> json) => EditHistory(
        editedBy: json["editedBy"],
        editedTime: json["editedTime"],
      );

  Map<String, dynamic> toMap() => {
        "editedBy": editedBy == null ? null : editedBy,
        "editedTime": editedTime == null ? null : editedTime,
        // final Map<String, dynamic> data = new Map<String, dynamic>();
        // data['editedBy'] = this.editedBy;
        // data['editedTime'] = this.editedTime;
        // return data;
        // return {
        //     // "editedBy": editedBy,
        //     // "editedTime": editedTime,
        //   };
      };
}

class Subject {
  Subject({
    required this.subjectName,
    required this.daysOftheWeek,
    required this.subjectTime,
  });

  String subjectName;
  String subjectTime;
  List<String> daysOftheWeek;

  factory Subject.fromMap(Map<String, dynamic> json) => Subject(
        subjectName: json["subjectName"],
        daysOftheWeek: List<String>.from(json["daysOftheWeek"].map((x) => x)),
        subjectTime: json["subjectTime"],
      );

  Map<String, dynamic> toMap() => {
        "subjectName": subjectName,
        "daysOftheWeek": List<dynamic>.from(daysOftheWeek.map((x) => x)),
        "subjectTime": subjectTime,
      };
}



// class NoteModel extends NoteEntity {
//   String? noteId;
//   String? note;
//   Timestamp? timeStamp;
//   String? uid;
//   SubjectModel? subjectModel;
//   NoteModel({
//     this.noteId,
//     this.note,
//     this.timeStamp,
//     this.uid,
//     this.subjectModel,
//   }) : super(
//           noteId: noteId,
//           note: note,
//           timeStamp: timeStamp,
//           uid: uid,
//           subjectModel: subjectModel,
//         );

//   factory NoteModel.fromSnapshot(Map<String, dynamic> json) {
//     // print('noteMap: ${NoteModel}');
//     return NoteModel(
//       noteId: json['noteId'],
//       note: json['note'],
//       timeStamp: json['timeStamp'],
//       uid: json['uid'],
//       subjectModel: json['subjectModel'],
//     );
//   }

//   Map<String, dynamic> toDocument() {
//     // final noteMap = <String, dynamic>{
//     //   'noteId': noteId,
//     //   'note': note,
//     //   'timeStamp': timeStamp,
//     //   'uid': uid,
//     // };
//     final Map<String, dynamic> data = <String, dynamic>{};

//     data['noteId'] = noteId;
//     data['note'] = note;
//     data['timeStamp'] = timeStamp;
//     data['uid'] = uid;
//     if (subjectModel != null) {
//       data['subjectModel'] = subjectModel!.toDocument();
//     }
//     // print('noteMap: ${noteMap}');
//     return data;
//   }
// }

// class SubjectModel {
//   List<String>? weekdays;
//   String? subjectName;
//   SubjectModel({
//     this.weekdays,
//     this.subjectName,
//   });

//   factory SubjectModel.fromSnapshot(Map<String, dynamic> doc) {
//     // print('noteMap: ${NoteModel}');
//     return SubjectModel(
//       weekdays: doc['weekdays'],
//       subjectName: doc['subjectName'],
//     );
//   }

//   Map<String, dynamic> toDocument() {
//     final subjectMap = <String, dynamic>{
//       'weekdays': weekdays,
//       'subjectName': subjectName,
//     };
//     return subjectMap;
//   }
// }
