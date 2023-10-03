import 'package:flutter/material.dart';
import 'package:rider_app_nukarshop/screens/profile.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: new Text('Account',style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold
        ),),
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>Profile()));
            },
            child: Row(
              children: [
                new Icon(Icons.person,size: 25,color:Theme.of(context).primaryColor,),
                SizedBox(width: 10,),
                Expanded(child: new Text('Profile',style: Theme.of(context).textTheme.headline3,)),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              new Icon(Icons.notifications,size: 25,color:Theme.of(context).primaryColor,),
              SizedBox(width: 10,),
              Expanded(child: new Text('Notifications',style: Theme.of(context).textTheme.headline3,)),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              new Icon(Icons.payment,size: 25,color:Theme.of(context).primaryColor,),
              SizedBox(width: 10,),
              Expanded(child: new Text('Bank detail',style: Theme.of(context).textTheme.headline3,)),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            children: [
              new Icon(Icons.mail,size: 25,color:Theme.of(context).primaryColor,),
              SizedBox(width: 10,),
              Expanded(child: new Text('Support',style: Theme.of(context).textTheme.headline3,)),
            ],
          )
        ],
      ),
    );
  }
}
