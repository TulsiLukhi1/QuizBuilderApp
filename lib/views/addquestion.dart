import 'package:flutter/material.dart';
import 'package:quizbuilder/services/database.dart';

import '../widgets/widgets.dart';


class AddQuestion extends StatefulWidget {
  final String quizId ;
  AddQuestion({required this.quizId});


  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  String question="",option1="",option2="",option3="",option4="";
  bool _isLoading = false;
  DatabaseService databaseService = new DatabaseService();
  uploadQuestionData() async{

    if(_formKey.currentState!.validate()){

      setState((){
        _isLoading=true;
      });
      Map<String,dynamic> questionMap = {
        "question" : question,
        "option1":option1,
        "option2":option2,
        "option3":option3,
        "option4":option4,
      };
      await databaseService.addQuestionData(questionMap, widget.quizId)
      .then((value){
        setState(){
          _isLoading=false;
        }
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
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple ),
          ),
        ),
      ) : Container(
        padding: EdgeInsets.symmetric(horizontal: 24 ),
        child: Column(
          children: [
            TextFormField(
              validator: (val){ return val! .isEmpty ? "Enter Question": null;},
              decoration: InputDecoration(
                  hintText: "Question"
              ),
              onChanged: (val){
                question = val;
              },
            ),
            SizedBox(
              height: 6,
            ),
            TextFormField(
              validator: (val){ return val! .isEmpty ? "Enter Option1": null;},
              decoration: InputDecoration(
                  hintText: "Option1(Correct Answer)"
              ),
              onChanged: (val){
                option1 = val;
              },
            ),
            SizedBox(
              height: 6,
            ),
            TextFormField(
              validator: (val){ return val! .isEmpty ? "Enter Option2": null;},
              decoration: InputDecoration(
                  hintText: "Option2"
              ),
              onChanged: (val){
                option2 = val;
              },
            ),

            TextFormField(
              validator: (val){ return val! .isEmpty ? "Enter Option3": null;},
              decoration: InputDecoration(
                  hintText: "Option3"
              ),
              onChanged: (val){
                option3 = val;
              },
            ),
            SizedBox(
              height: 6,
            ),
            TextFormField(
              validator: (val){ return val! .isEmpty ? "Enter Option4": null;},
              decoration: InputDecoration(
                  hintText: "Option4"
              ),
              onChanged: (val){
                option4 = val;
              },
            ),
            Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                    child: purpleButton2(context, "Submit")
                ),
                SizedBox(width: 24,),
                GestureDetector(
                  onTap: (){
                    uploadQuestionData();
                  },
                    child: purpleButton2(context, "Add Question"),
                )
              ],
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
