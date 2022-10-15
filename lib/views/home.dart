import 'package:flutter/material.dart';
import 'package:quizbuilder/views/create_quiz.dart';
import 'package:quizbuilder/widgets/widgets.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,

      ),
      body: Container(
        child: Column(children: [

        ],),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder:  (context)=>CreateQuiz()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
