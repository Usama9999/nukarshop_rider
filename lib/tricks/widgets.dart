import 'package:flutter/material.dart';


import 'configSize.dart';

class widgets {
  Widget button(BuildContext context, String text, int arrow) {
    return Container(
      alignment: Alignment.center,
      height: 6 * ConfigSize.heightMultiplier,
      width: 84.18 * ConfigSize.paddingWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0,2),
            blurRadius: 2,
            spreadRadius: 1
          )
        ]
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        new Text(
          text,
          style: TextStyle(
              color: Theme.of(context).selectedRowColor,
              fontSize: 3 * ConfigSize.textMultiplier),
        ),
        if (arrow == 1)
          Icon(
            Icons.arrow_forward,
            size: 3.76 * ConfigSize.heightMultiplier,
            color: Theme.of(context).selectedRowColor,
          )
      ]),
    );
  }

  InputDecoration decoration(String hint, BuildContext context) {
    return InputDecoration(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color:Theme.of(context).primaryColor,
            width: 2
        ),
        borderRadius: BorderRadius.circular(30),
      ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30)
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        hintText: hint,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 2.13 * ConfigSize.heightMultiplier, horizontal: 5.10*ConfigSize.paddingWidth));
  }
  void showLoginDialogue(BuildContext context)
  {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Bs kr do janab!",style: TextStyle(
            fontWeight: FontWeight.bold
        ),),
        content: Text("Mazy pury ho gay hai ab ap Login kry"),
        actions: <Widget>[
          GestureDetector(
            onTap:()
            {
              Navigator.of(context).pop();
            },
            child: new Container(
              child: new Text("Cancle",style: TextStyle(
                  color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold
              ),),
              height: 40,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey,
                      width: 1
                  ),
                  borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          GestureDetector(
            onTap: ()
            {
            },
            child: new Container(
              child: new Text("Login",style: TextStyle(
                  color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold
              ),),
              height: 40,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(

                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),

              ),
            ),
          )
        ],
      ),
    );
  }
  void showErrorDialogue(BuildContext context,var body)
  {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text('$body'),
        actions: <Widget>[
          GestureDetector(
            onTap:()
            {
              Navigator.of(context).pop();
            },
            child: new Container(
              child: new Text("ok",style: TextStyle(
                  color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold
              ),),
              height: 40,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0,2),
                        color: Colors.black26,
                        blurRadius: 3
                    )
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
