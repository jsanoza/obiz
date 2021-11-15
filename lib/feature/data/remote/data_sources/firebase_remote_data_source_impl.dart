// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample_app_request/feature/data/remote/data_sources/firebase_remote_data_source.dart';
import 'package:sample_app_request/feature/data/remote/models/note_model.dart';
import 'package:sample_app_request/feature/data/remote/models/user_model.dart';
import 'package:sample_app_request/feature/domain/entities/note_entity.dart';
import 'package:sample_app_request/feature/domain/entities/user_entity.dart';
import 'package:sample_app_request/feature/domain/repositories/firebase_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;
  var uuid = Uuid();
  FirebaseRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future getCreateCurrentUser(UserEntity userEntity) async {
    final userCollRef = firestore.collection('users');
    final uid = await getCurrentUid();
    final group = await getCreateCurrentUserGroup();
    print("group : $group");
    userCollRef.doc(uid).get().then((value) {
      final newUser = UserModel(uid: uid, groupName: userEntity.groupName, email: userEntity.email, name: userEntity.name).toDocument();
      if (!value.exists) {
        userCollRef.doc(uid).set(newUser);
      }
    });
  }

  @override
  Future<String> getCurrentUid() async {
    return auth.currentUser!.uid;
  }

  @override
  Future<bool> isSignedIn() async => auth.currentUser?.uid != null;

  @override
  Future<void> googleAuth() async {
    final usersCollection = firestore.collection("users");
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await account!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final information = (await auth.signInWithCredential(credential)).user;

      usersCollection.doc(auth.currentUser!.uid).get().then((user) async {
        if (!user.exists) {
          var uid = auth.currentUser!.uid;
          var newUser = UserModel(
            name: information!.displayName!,
            email: information.email!,
            uid: information.uid,
            groupName: '',
            color: '19c8f2',
          ).toDocument();

          usersCollection.doc(uid).set(newUser);
        }
      }).then((value) async {
        print("New User Created Successfully");
        await getCreateCurrentUserGroup().then((value) {
          print("group : $value");
          SharedPreferences.getInstance().then((SharedPreferences sp) {
            sp.setString('groupName', value);
          });
        });
        await SharedPreferences.getInstance().then((value) {
          value.setString('choice', 'all');
        });
        await getCreateCurrentUserColor().then((value) {
          // var group;
          print("color : $value");
          SharedPreferences.getInstance().then((SharedPreferences sp) {
            sp.setString('creatorColor', value);
          });
        });
      }).catchError((e) {
        print("getInitializeCreateCurrentUser ${e.toString()}");
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> getCreateCurrentUserColor() async {
    final userCollRef = firestore.collection('users');
    final uid = await getCurrentUid();
    String color;
    return userCollRef.doc(uid).get().then((value) {
      color = value['color'];
      return color;
    });
  }

  Future<String> getCreateCurrentUserGroup() async {
    final userCollRef = firestore.collection('users');
    final uid = await getCurrentUid();
    String groupName;
    return userCollRef.doc(uid).get().then((value) {
      groupName = value['groupName'];
      return groupName;
    });
  }

  @override
  Future signOut() {
    return auth.signOut();
  }

  @override
  Future addNewNote(NoteEntity noteEntity) async {
    print("this is noteentity: ${noteEntity}");
    String randomuuid = uuid.v4();
    final group = await getCreateCurrentUserGroup();
    print("group : $group");

    final newNote = NoteModel(
      uid: noteEntity.uid,
      applyToHowManySubject: noteEntity.applyToHowManySubject,
      editHistory: noteEntity.editHistory,
      lastEditedDt: noteEntity.lastEditedDt,
      note: noteEntity.note,
      noteId: randomuuid,
      subject: noteEntity.subject,
      timeStamp: noteEntity.timeStamp,
      creatorcolor: noteEntity.creatorcolor,
    ).toMap();
    final noteCollect = firestore.collection('notes');
    noteCollect.doc(group).set({
      "notesList": FieldValue.arrayUnion([newNote])
    }, SetOptions(merge: true)).then((value) {
      print("added successfully");
    }).catchError(
      // ignore: invalid_return_type_for_catch_error
      (error) => print('Add failed: $error'),
    );
  }

  @override
  Future<void> addUserGroup(UserEntity userEntity) async {
    print(userEntity);
    final usersCollection = firestore.collection("users");
    usersCollection.doc(auth.currentUser!.uid).get().then((user) async {
      if (user.exists) {
        usersCollection.doc(auth.currentUser!.uid).update({"groupName": userEntity.groupName});
      }
    });
  }

  @override
  Future<void> deleteNewNote(NoteEntity noteEntity) async {
    final group = await getCreateCurrentUserGroup();
    List newList = [];
    List<NoteModel> noteModelList = [];
    final noteCollRef = firestore.collection('notes').doc(group);
    return noteCollRef.get().then((value) {
      var _result = value.data();
      if (_result != null) {
        List mapList = _result['notesList'];
        var item = mapList.firstWhere((i) => i["noteId"] == noteEntity.noteId && i["uid"] == auth.currentUser!.uid);
        var index = mapList.indexOf(item);

        _result['notesList'].forEach((element) {
          noteModelList.add(NoteModel.fromSnapshot(element));
        });

        noteModelList.removeAt(index);

        noteModelList.forEach((elementx) {
          var newNotex = NoteModel(
            uid: elementx.uid,
            noteId: elementx.noteId,
            note: elementx.note,
            timeStamp: elementx.timeStamp,
            applyToHowManySubject: elementx.applyToHowManySubject,
            editHistory: elementx.editHistory,
            lastEditedDt: elementx.lastEditedDt,
            subject: elementx.subject,
            creatorcolor: elementx.creatorcolor,
          ).toMap();
          newList.add(newNotex);
        });

        noteCollRef.set({"notesList": FieldValue.arrayUnion(newList)}).then((value) {
          print("added successfully");
        }).catchError(
          // ignore: invalid_return_type_for_catch_error
          (error) => print('Add failed: $error'),
        );
      }
    });
  }

  @override
  Stream<List<NoteEntity?>> getNotes(String uid, String group) {
    // TODO: implement getNotes
    return firestore.collection('notes').doc(group).snapshots().map((ds) {
      var mapData = ds.data();
      List<NoteModel> newsModelList = [];
      print(" this is data :${ds.data()}");
      if (mapData != null) {
        List mapList = mapData['notesList'];
        // ignore: avoid_function_literals_in_foreach_calls
        mapList.forEach((element) {
          newsModelList.add(NoteModel.fromSnapshot(element));
        });
      }
      return newsModelList;
    });
  }

  @override
  Future<void> signIn(UserEntity userEntity) {
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(UserEntity userEntity) {
    throw UnimplementedError();
  }

  @override
  Future updateNote(NoteEntity noteEntity) async {
    final uid = await getCurrentUid();
    List<String> lastEditedDt = [];
    List<EditHistory> editHistory = [];
    var editorColor = await getCreateCurrentUserColor();
    final group = await getCreateCurrentUserGroup();
    List newList = [];
    List<NoteModel> noteModelList = [];
    final noteCollRef = firestore.collection('notes').doc(group);
    return noteCollRef.get().then((value) {
      var _result = value.data();
      if (_result != null) {
        List mapList = _result['notesList'];
        var item = mapList.firstWhere((i) => i["noteId"] == noteEntity.noteId);
        var index = mapList.indexOf(item);
        _result['notesList'].forEach((element) {
          noteModelList.add(NoteModel.fromSnapshot(element));
        });

        noteModelList.forEach((elementx) {
          var newNotex = NoteModel(
            uid: elementx.uid,
            noteId: elementx.noteId,
            note: elementx.note,
            timeStamp: elementx.timeStamp,
            applyToHowManySubject: elementx.applyToHowManySubject,
            editHistory: elementx.editHistory,
            lastEditedDt: elementx.lastEditedDt,
            subject: elementx.subject,
            creatorcolor: elementx.creatorcolor,
          ).toMap();

          if (elementx.noteId == noteEntity.noteId) {
            elementx.editHistory.forEach((element) {
              if (!element.editedBy.contains(uid)) {
                editHistory.add(EditHistory(editedBy: element.editedBy, editedTime: element.editedTime));
              }
            });

            elementx.lastEditedDt.forEach((element) {
              lastEditedDt.add(element);
            });

            if (!elementx.lastEditedDt.contains(editorColor)) {
              lastEditedDt.add(editorColor);
            }
          }
          newList.add(newNotex);
        });

        editHistory.add(EditHistory(editedBy: uid, editedTime: Timestamp.now().toString()));
        final newNote = NoteModel(
          uid: noteEntity.uid,
          noteId: noteEntity.noteId,
          note: noteEntity.note,
          timeStamp: noteEntity.timeStamp,
          applyToHowManySubject: noteEntity.applyToHowManySubject,
          editHistory: editHistory,
          subject: noteEntity.subject,
          lastEditedDt: lastEditedDt,
          creatorcolor: noteEntity.creatorcolor,
        ).toMap();

        newList[index] = newNote;
        noteCollRef.set({"notesList": FieldValue.arrayUnion(newList)}).then((value) {
          print("added successfully");
        }).catchError(
          // ignore: invalid_return_type_for_catch_error
          (error) => print('Add failed: $error'),
        );
      }
    });
  }

  @override
  Future<void> editColorCreator(UserEntity userEntity) async {
    final usersCollection = firestore.collection("users");
    var oldColor;
    var mapUser;
    List<String> lastEditedDt = [];
    usersCollection.doc(auth.currentUser!.uid).get().then((user) async {
      oldColor = user.data();
      mapUser = oldColor['color'];
      if (user.exists) {
        usersCollection.doc(auth.currentUser!.uid).update({"color": userEntity.color});
      }
    }).then((value) async {
      final group = await getCreateCurrentUserGroup();
      List newList = [];
      List<NoteModel> noteModelList = [];
      final noteCollRef = firestore.collection('notes').doc(group);
      return noteCollRef.get().then((value) {
        var _result = value.data();
        if (_result != null) {
          _result['notesList'].forEach((element) {
            noteModelList.add(NoteModel.fromSnapshot(element));
          });

          noteModelList.forEach((element) {
            var color;

            if (element.uid == auth.currentUser!.uid) {
              color = userEntity.color;
            } else {
              color = element.creatorcolor;
            }

            // if (element.lastEditedDt.isEmpty) {
            //   var index = element.editHistory.indexWhere((element) => element.editedBy == auth.currentUser!.uid);
            //   log(index.toString());
            // } else {
            //   var index = element.editHistory.indexWhere((element) => element.editedBy == auth.currentUser!.uid);
            //   if (index > 0) {
            //     element.lastEditedDt[index] = userEntity.color.toString();
            //   }
            // }
            if (element.editHistory.isNotEmpty) {
              var index = element.editHistory.indexWhere((element) => element.editedBy == auth.currentUser!.uid);
              log(index.toString());
              if (index >= 0) {
                element.lastEditedDt[index] = userEntity.color.toString();
              }
            }

            var newNotex = NoteModel(
              uid: element.uid,
              noteId: element.noteId,
              note: element.note,
              timeStamp: element.timeStamp,
              applyToHowManySubject: element.applyToHowManySubject,
              editHistory: element.editHistory,
              lastEditedDt: element.lastEditedDt,
              subject: element.subject,
              creatorcolor: color,
            ).toMap();

            newList.add(newNotex);
          });

          noteCollRef.set({"notesList": FieldValue.arrayUnion(newList)}).then((value) {
            print("added successfully");
          }).catchError(
            // ignore: invalid_return_type_for_catch_error
            (error) => print('Add failed: $error'),
          );
        }
        log(mapUser.toString());
      });
    });
  }
}
