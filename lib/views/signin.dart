
import 'package:flutter/material.dart';
import 'package:quizbuilder/helper/functions.dart';
import 'package:quizbuilder/services/auth.dart';
import 'package:quizbuilder/views/signup.dart';
import 'package:quizbuilder/views/home.dart';
import 'package:quizbuilder/widgets/widgets.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _formKey = GlobalKey<FormState>();
  String email='',password='';
  AuthService authService =  new AuthService();
  bool _isLoading =false;

  SignIn() async {
    if(_formKey.currentState!.validate()){
      setState((){
        _isLoading = true;
      });
      await authService.signInEmailAndPass(email, password).then((val){
        if(val != null){
          setState((){
            _isLoading=false;
          });
          HelperFunctions.saveuserLoggedIndetails(isLoggedIn : true)
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
        child : Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          ),
        )
      ) :  Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Spacer(),
              TextFormField(
                validator:(String? val) {
                  if (val != null && val.isEmpty) {
                    return "Enter Email id";
                  }
                  return null;
                },
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
                // validator: (val){ return val! .isEmpty ? "Enter Password": null;},
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator:(String? val) {
                  if (val != null && val.isEmpty) {
                    return "Enter password";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Password"
                ),
                onChanged: (val){
                  password   = val;
                },
              ),
              SizedBox(height: 24,),
              GestureDetector(
                onTap: (){
                  SignIn();
                },
                child: purpleButton(context, "Sign In")
              ),
              SizedBox(height: 18,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an accout? ", style: TextStyle(fontSize: 15.5),),
                  GestureDetector(
                      onTap:(){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text("Sign Up ", style: TextStyle(fontSize: 15.5, decoration: TextDecoration.underline),)),
                ],
              ),
              SizedBox(height: 80,),
            ],
          ),
        ),
      ),
    );
  }
}