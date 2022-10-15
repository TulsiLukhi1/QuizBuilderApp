import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizbuilder/helper/functions.dart';
import 'package:quizbuilder/views/home.dart';
import 'package:quizbuilder/views/signin.dart';
import 'firebase_options.dart';
import 'package:quizbuilder/views/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:
  DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool _isLoggedIn=false;
  @override
  void initState(){
    checkUserLoggedInState();
    super.initState();
  }

  checkUserLoggedInState() async {
    await HelperFunctions.getUserLoggedInDetails().then((value){
      setState((){
        _isLoggedIn = value!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
          visualDensity : VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.blue
      ),
      //if is logged in null provide false value
      home:  _isLoggedIn ? Home() : SignIn(),
    );
  }
}