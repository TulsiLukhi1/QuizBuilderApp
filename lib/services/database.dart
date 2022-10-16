import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
class DatabaseService{
  Future<void> addQuizData(Map<String,dynamic> quizData,String quizId) async{
    await FirebaseFirestore.instance.collection("Quiz").
    doc(quizId).set(quizData);
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() async{
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuestionData(String quizId) async{
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }
}