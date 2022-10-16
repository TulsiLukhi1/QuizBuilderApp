import 'package:cloud_firestore/cloud_firestore.dart';
class DatabaseService{
  Future<void> addQuizData(Map<String,dynamic> quizData,String quizId) async{
    await FirebaseFirestore.instance.collection("Quiz").
    doc(quizId).set(quizData);
  }

  // Future<void> addQuizData(Map quizData, String quizId) async {
  //   await FirebaseFirestore.instance
  //       .collection("Quiz")
  //       .doc(quizId)
  //       .set(quizData)
  //       .catchError((e) {
  //     print(e);
  //   });
  // }


  // Future<void> addQuestionData(Map<String,dynamic> questionData,String quizId)async {
  //   await FirebaseFirestore.instance.collection("Quiz")
  //       .doc(quizId).collection("QNA")
  //       .add(questionData);
  // }

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
}