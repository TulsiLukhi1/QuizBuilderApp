
import 'package:flutter/material.dart';
import 'package:quizbuilder/services/database.dart';
import 'package:quizbuilder/views/addquestion.dart';
import 'package:random_string/random_string.dart';
import '../widgets/widgets.dart';
class CreateQuiz extends StatefulWidget {
  const CreateQuiz({Key? key}) : super(key: key);

  @override
  State<CreateQuiz> createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  String quizImageUrl="",quizTitle="",quizDescription="",quizId="";
  bool  _isLoading =false;
  DatabaseService databaseService = new DatabaseService();
  createQuizOnline() async{
    if(_formKey.currentState!.validate()){
      setState((){
        _isLoading = true;
      });
      quizId= randomAlphaNumeric(16);
      Map<String,dynamic>  quizMap = {
        "quizId" : quizId,
        "quizImageurl" :quizImageUrl ,
        "quizTitle" : quizTitle,
        "quizDesc" : quizDescription,
      };

      await databaseService.addQuizData(quizMap,quizId).then((value) => {
        setState((){
          _isLoading=false;
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>AddQuestion(quizId)));
        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black87
        ),

      ),
      body:  _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple ),
          ),
        ),
      ) : Form(
        key: _formKey,
        child: Container(
            padding : EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            TextFormField(
              validator: (val){ return val! .isEmpty ? "Enter Quiz Url": null;},
              decoration: InputDecoration(

                hintText: "Quiz Image url",
              ),
              onChanged: (val){
                quizImageUrl = val;
              },
            ),
            SizedBox(height: 6,),

            TextFormField(
              validator: (val){ return val! .isEmpty ? "Enter Quiz Title": null;},
              decoration: InputDecoration(
                hintText: "Quiz Title",

              ),
              onChanged: (val){
                quizTitle = val;
              },
            ),
            SizedBox(height: 6,),

            TextFormField(
              validator: (val){ return val! .isEmpty ? "Enter Quiz Description": null;},
              decoration: InputDecoration(
                hintText: "Quiz Description",

              ),
              onChanged: (val){
                quizDescription = val;
              },
            ),
            SizedBox(height: 6,),

            Spacer(),

            GestureDetector(
              onTap: (){
                createQuizOnline();
              },
                child: purpleButton(context, "Create Quiz")),
            SizedBox(height: 80,),
          ],),
        ),
      ),
    );
  }
}
