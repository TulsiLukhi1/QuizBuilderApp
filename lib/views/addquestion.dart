import 'package:flutter/material.dart';
import 'package:quizbuilder/services/database.dart';
import 'package:quizbuilder/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {

  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String question = "", option1 = "", option2 = "", option3 = "", option4 = "";

  uploadQuizData() {

    if(_formKey.currentState!.validate()){

      setState(() {
        isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };

      print("${widget.quizId}");
      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";
        setState(() {
          isLoading = false;
        });

      }).catchError((e){
        print(e);
      });


    }else{
      print("error is happening ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black87
        ),

      ),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              TextFormField(
                validator: (val){ return val! .isEmpty ? "Enter Question": null;},
                decoration: InputDecoration(hintText: "Question"),
                onChanged: (val) {
                  question = val;
                },
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (val){ return val! .isEmpty ? "Enter option1": null;},
                decoration:
                InputDecoration(hintText: "Option1 (Correct Answer)"),
                onChanged: (val) {
                  option1 = val;
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                validator: (val){ return val! .isEmpty ? "Enter option2": null;},
                decoration: InputDecoration(hintText: "Option2"),
                onChanged: (val){
                  option2 = val;
                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                validator: (val){ return val! .isEmpty ? "Enter oprion3": null;},
                decoration: InputDecoration(hintText: "Option3"),
                onChanged: (val){
                  option3 = val;

                },
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                validator: (val){ return val! .isEmpty ? "Enter optoin4": null;},
                decoration: InputDecoration(hintText: "Option4"),
                onChanged: (val){
                  option4 = val;
                },
              ),
              SizedBox(
                height: 8,
              ),
              Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {

                      Navigator.pop(context);

                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Submit",
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      uploadQuizData();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        "Add Question",
                        style:
                        TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}