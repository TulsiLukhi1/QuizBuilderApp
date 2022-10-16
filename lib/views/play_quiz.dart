import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizbuilder/views/result.dart';

import '../models/question_model.dart';
import '../services/database.dart';
import '../widgets/quiz_play_wideget.dart';
import '../widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  PlayQuiz(this.quizId);
  @override
  State<PlayQuiz> createState() => _PlayQuizState();
}


int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;

late Stream infoStream;
class _PlayQuizState extends State<PlayQuiz> {
  DatabaseService databaseService  = new DatabaseService();
  late QuerySnapshot questionSnapshot;
  bool _isLoading=true;

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question =  questionSnapshot.get("question");

    /// shuffling the options"
    List<String> options = [
      questionSnapshot.get("option1"),
      questionSnapshot.get("option2"),
      questionSnapshot.get("option3"),
      questionSnapshot.get("option4")
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.get("option1");
    questionModel.answered = false;

    print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }


  @override
  void initState() {
    databaseService.getQuestionData(widget.quizId).then((value){

      questionSnapshot = value;
      _notAttempted = questionSnapshot.docs.length;
      _correct = 0;
      _incorrect = 0;
      _isLoading = false;
      total = questionSnapshot.docs.length;
      setState(() {

      });
      print("init don $total ${widget.quizId} ");
    });
    if(infoStream == null){
      infoStream = Stream<List<int>>.periodic(
          Duration(milliseconds: 100), (x){
        print("this is x $x");
        return [_correct, _incorrect] ;
      });
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   infoStream = null;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),

      ),
      body: _isLoading ? Container(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
      ) : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              InfoHeader(
                length: questionSnapshot.docs.length,
              ),
              SizedBox(
                height: 10,
              ),
              questionSnapshot == null
                  ? Container(
                child: Center(child: Text("No Data"),),
              ): ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: questionSnapshot.docs.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return QuizPlayTile(
                      questionModel: getQuestionModelFromDatasnapshot(
                          questionSnapshot.docs[index]),
                      index: index,
                    );
                  })

            ],
          ),
        ),




      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder:  (context)=>
              Results(
                correct : _correct,
                incorrect: _incorrect,
                total: total,
                notattempted: _notAttempted,
              )
          ));
        },
        child: Icon(Icons.check),
      ),
    );
  }
}


class InfoHeader extends StatefulWidget {
  final int length;

  InfoHeader({required this.length});

  @override
  _InfoHeaderState createState() => _InfoHeaderState();
}

class _InfoHeaderState extends State<InfoHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: infoStream,
        builder: (context, snapshot){
          return snapshot.hasData ? Container(
            height: 40,
            margin: EdgeInsets.only(left: 14),
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: <Widget>[
                NoOfQuestionTile(
                  text: "Total",
                  number: widget.length,
                ),
                NoOfQuestionTile(
                  text: "Correct",
                  number: _correct,
                ),
                NoOfQuestionTile(
                  text: "Incorrect",
                  number: _incorrect,
                ),
                NoOfQuestionTile(
                  text: "NotAttempted",
                  number: _notAttempted,
                ),
              ],
            ),
          ) : Container();
        }
    );
  }
}


class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;

  QuizPlayTile({required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: 20
            ),
            child: Text(
              "Q${widget.index + 1} ${widget.questionModel.question}",
              style:
              TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {

                /// condition for correct answer
                if (widget.questionModel.option1 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    /// true set because we don't want user to attempt that question again
                    _correct = _correct + 1;
                    ///answer was correct so _correct will increase
                    _notAttempted = _notAttempted - 1;
                    ///notAttempted question count will decrease
                  });
                  /// otherwise incorrect answer
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option1;
                    widget.questionModel.answered = true;
                    /// true set because we don't want user to attempt that question again
                    _incorrect = _incorrect + 1;
                    /// answer is incorrect so incorrect coutn increase
                    _notAttempted = _notAttempted - 1;
                    /// not attempted count wll decrease in both case
                  });
                }
              }
            },
            child: OptionTile(
              option: "A",
              description: "${widget.questionModel.option1}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option2 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option2;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: "${widget.questionModel.option2}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option3 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option3;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: "${widget.questionModel.option3}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.questionModel.answered) {
                ///correct
                if (widget.questionModel.option4 ==
                    widget.questionModel.correctOption) {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _correct = _correct + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.questionModel.option4;
                    widget.questionModel.answered = true;
                    _incorrect = _incorrect + 1;
                    _notAttempted = _notAttempted - 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: "${widget.questionModel.option4}",
              correctAnswer: widget.questionModel.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
