// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizbuilder/views/create_quiz.dart';
import 'package:quizbuilder/views/play_quiz.dart';
import 'package:quizbuilder/widgets/widgets.dart';

import '../services/database.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    late Stream quizStream;
    DatabaseService databaseService = new DatabaseService();
    Widget quizList(){

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: StreamBuilder(
          stream: quizStream,
          builder: ( context, snapshot) {

            return snapshot.data == null ? Container() :
                ListView.builder(
                  itemCount:( snapshot.data! as QuerySnapshot).docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return QuizTile(
                        imgUrl: ( snapshot.data! as QuerySnapshot).docs[index]["quizImageurl"],
                        title: ( snapshot.data! as QuerySnapshot).docs[index]["quizTitle"],
                        desc: ( snapshot.data! as QuerySnapshot).docs[index]["quizDesc"],
                        quizId: ( snapshot.data! as QuerySnapshot).docs[index]["quizId"],
                    );
                  },
                );
          },

        ),
      );
    }


    @override
    void initState() {
      databaseService.getQuizData().then((value) {
        quizStream = value;
        setState(() {});
      });
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,

      ),
      body: quizList(),
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

class QuizTile extends StatelessWidget {
  final String imgUrl,title,desc;
  final String quizId;
  QuizTile({required this.imgUrl,required this.title,required this.desc, required this.quizId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>PlayQuiz(quizId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        height: 150 ,
        margin: EdgeInsets.only(bottom: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imgUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,

              ),
              Container(
                color: Colors.black26,
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      SizedBox(height: 4,),
                      Text(
                          desc,
                          style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

