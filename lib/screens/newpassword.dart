import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'package:rider_app_nukarshop/tricks/widgets.dart';import 'NameScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Password extends StatefulWidget {
  int id;
  Password(this.id);

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {

  var _obscure = true;
  var passwordController = new TextEditingController();
  var isLoading = false;
  Future<bool> setPassword(String code) async
  {
    setState(() {
      isLoading = true;
    });
    var queryParameters = {
      'id': '${widget.id}',
      'password': '$code'
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/setNewPassword'),
      body: queryParameters,
    );
    var check = await json.decode(response.body);
    print(check);
    return check;
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
        child: isLoading == false?Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.76*ConfigSize.heightMultiplier,horizontal:7.65*ConfigSize.paddingWidth),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    new Text("Enter new password",style: Theme.of(context).textTheme.headline1,
    overflow: TextOverflow.clip,
    textAlign: TextAlign.center,),
    SizedBox(height: 6.28*ConfigSize.heightMultiplier,),
    new Form(
    key: _formKey,
    child: new Column(
    children: [
    Container(
    width: 84.18 * ConfigSize.paddingWidth,
    child: TextFormField(
      controller: passwordController,
      obscureText: _obscure,
    decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
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
        suffix: GestureDetector(
            onTap: ()
            {
              setState(() {
                _obscure = _obscure == false? true:false;
              });
            },
            child: _obscure == true?Text('Show'):Text('Hide')),
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        hintText: 'password',
        filled: true,
        contentPadding: EdgeInsets.symmetric(
            vertical: 2.13 * ConfigSize.heightMultiplier, horizontal: 5.10*ConfigSize.paddingWidth)),
    validator: (value) {
    if (value!.isEmpty || value.length <8)
    return "must be 8 character long";
    },
    ),

    ),

    ],
    )

    ),
    SizedBox(height: 2.51*ConfigSize.heightMultiplier,),
    GestureDetector(
    onTap: () async {
    if(_formKey.currentState!.validate())
    {
      var checked = await setPassword(passwordController.text);
      if(checked == true) {
        setState(() {
          isLoading = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (
            _) => NameScreen(widget.id)));
      }
      else
      {
        setState(() {
          isLoading = false;
        });

      }
    }
    },
    child: widgets().button(context, "Continue",0)),
    SizedBox(height: 3*ConfigSize.heightMultiplier,),

    ],
    ),
    ),
    ):Center(
          child: CircularProgressIndicator(),
        ),
    ));
  }
}
