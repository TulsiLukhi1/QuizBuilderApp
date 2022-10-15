import 'package:flutter/material.dart';

Widget appBar(BuildContext context){
  return Center(
      child : RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 22),
          children: <TextSpan>[
            TextSpan(text: 'Quiz', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey)),
            TextSpan(text: 'Builder', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple)),
          ],
        ),
      )
  ) ;
}


Widget purpleButton(  BuildContext context,String label){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(30)
    ),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width - 48,
    child: Text(label, style: TextStyle(color: Colors.white,fontSize: 16),),
  );
}



Widget purpleButton2(  BuildContext context,String label){
  return Container(
    padding: EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(30)
    ),
    alignment: Alignment.center,
    width: MediaQuery.of(context).size.width/2 - 36,
    child: Text(label, style: TextStyle(color: Colors.white,fontSize: 16),),
  );
}


