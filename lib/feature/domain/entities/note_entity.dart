import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:sample_app_request/feature/data/remote/models/note_model.dart';

// class NoteEntity extends Equatable {
//   final String? noteId;
//   final String? note;
//   final Timestamp? timeStamp;
//   final String? uid;
//   // final SubjectEntity? subjectEntity;
//   final SubjectModel? subjectModel;

//   const NoteEntity({
//     this.noteId,
//     this.note,
//     this.timeStamp,
//     this.uid,
//     // this.subjectEntity,
//     this.subjectModel,
//   });

//   @override
//   // TODO: implement props
//   List<Object?> get props => [
//         note,
//         noteId,
//         timeStamp,
//         uid,
//         // subjectEntity,
//         subjectModel,
//       ];
// }

class NoteEntity extends Equatable {
  final String? applyToHowManySubject;
  final String? note;
  final String? noteId;
  final Timestamp? timeStamp;
  final String? uid;
  final String? creatorcolor;
  final List<EditHistory> editHistory;
  final List<String> lastEditedDt;
  final List<Subject> subject;

  const NoteEntity({
    this.applyToHowManySubject,
    this.note,
    this.noteId,
    this.timeStamp,
    this.uid,
    this.creatorcolor,
    required this.editHistory,
    required this.lastEditedDt,
    required this.subject,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        applyToHowManySubject,
        note,
        noteId,
        timeStamp,
        uid,
        creatorcolor,
        editHistory,
        lastEditedDt,
        subject,
      ];
}



// class SubjectEntity extends Equatable {
//   final String? m;
//   final String? t;
//   final String? w;
//   final String? th;
//   final String? f;
//   final String? s;
//   final String? subjectName;
//   const SubjectEntity({
//     this.m,
//     this.t,
//     this.w,
//     this.th,
//     this.f,
//     this.s,
//     this.subjectName,
//   });

//   @override
//   // TODO: implement props
//   List<Object?> get props => [
//         m,
//         t,
//         w,
//         th,
//         f,
//         s,
//         subjectName,
//       ];
// }
