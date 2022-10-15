import 'package:flutter/material.dart';
import 'package:quizbuilder/services/auth.dart';
import 'package:quizbuilder/views/signin.dart';
import 'package:quizbuilder/widgets/widgets.dart';
import 'package:quizbuilder/views/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formKey = GlobalKey<FormState>();
  String name='',email='',password='';

  AuthService authService =  new AuthService();
  bool _isLoading =false;

  bool isLoading=false;
  SignUp()   async{
    if(_formKey.currentState!.validate()){

      setState((){
        _isLoading = true;
      });
       authService.signUpWithEmailAndPassword(email, password).then((val){
        if(val != null){
          setState((){
            _isLoading=false;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Home()));
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

      ),
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple ),
          ),
        ),
      ) :Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Spacer(),
              TextFormField(
                validator: (val){ return val! .isEmpty ? "Enter Name": null;},
                decoration: InputDecoration(
                    hintText: "Name"
                ),
                onChanged: (val){
                  name = val;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                validator: (val){ return val! .isEmpty ? "Enter EmailId": null;},
                decoration: InputDecoration(
                    hintText: "Email"
                ),
                onChanged: (val){
                  email = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (val){ return val! .isEmpty ? "Enter Password": null;},
                decoration: InputDecoration(
                    hintText: "Password"
                ),
                onChanged: (val){
                  password = val;
                },
              ),
              SizedBox(height: 24,),
              GestureDetector(
                onTap: (){
                  SignUp();
                },
                child: purpleButton(context, "Sign Up"),
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an accout? ", style: TextStyle(fontSize: 15.5),),
                  GestureDetector(
                      onTap:(){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text("Sign In ", style: TextStyle(fontSize: 15.5, decoration: TextDecoration.underline),)),
                ],
              ),
              SizedBox(height: 80,),
            ],
          ),
        ),
      ),
    );;
  }
}
