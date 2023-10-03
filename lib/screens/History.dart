import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rider_app_nukarshop/models/Order%20History.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}


class _HistoryState extends State<History> {

  List<OrderHistory> Todayorders =[];
  List<OrderHistory> yesturday =[];
  List<OrderHistory> thisweek =[];
  List<OrderHistory> prevweek =[];
  List<OrderHistory> month =[];

  var hasDataToday =false;
  var hasDataYesterday= false;
  var hasDataThisWeek= false;
  var hasDataPrevWeek =false;
  var hasDataThismonth= false;

  var isloadingToday = false;
  var isLoadingYesterday = false;
  var isLoadingthisWeek = false;
  var isLoadingPrevweek = false;
  var isLoadingThismonth = false;

  var ToshowToday = false;
  var ToshowYesterday = false;
  var ToshowthisWekk = false;
  var ToshowPrevweek = false;
  var ToshowMonth = false;
  void Todaysrders() async
  {
    if(this.mounted)
    setState(() {
      isloadingToday = true;
    });
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id  = await storage.read(key: 'id');
    var queryParameters = {
      'rider_id': '$id',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/orderDeliverByRiderToday'),
      body: queryParameters,
    );
    var result = response.body;

    Todayorders = orderHistoryFromJson(result);
    if(Todayorders.length>0)
      {
        setState(() {
          hasDataToday = true;
          isloadingToday = false;
        });
      }
    else
      {
        setState(() {
          hasDataToday = false;
          isloadingToday = false;
        });
      }
  }
  void yesterday() async
  {
    if(this.mounted)
      setState(() {
        isLoadingYesterday = true;
      });
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id  = await storage.read(key: 'id');
    var queryParameters = {
      'rider_id': '$id',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/orderDeliverByRiderYesterDay'),
      body: queryParameters,
    );
    var result = response.body;
    print(result);
    yesturday = orderHistoryFromJson(result);
    if(yesturday.length>0)
    {
      setState(() {
        hasDataYesterday = true;
        isLoadingYesterday = false;
      });
    }
    else
    {
      setState(() {
        hasDataYesterday = false;
        isLoadingYesterday = false;
      });
    }
  }
  void ThisWeek() async
  {
    if(this.mounted)
      setState(() {
        isLoadingthisWeek= true;
      });
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id  = await storage.read(key: 'id');
    var queryParameters = {
      'rider_id': '$id',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/orderDeliverByRiderThisWeek'),
      body: queryParameters,
    );
    var result = response.body;

    thisweek = orderHistoryFromJson(result);
    if(Todayorders.length>0)
    {
      setState(() {
        hasDataThisWeek = true;
        isLoadingthisWeek = false;
      });
    }
    else
    {
      setState(() {
        hasDataThisWeek = false;
        isLoadingthisWeek = false;
      });
    }
  }
  void Prevweek() async
  {
    if(this.mounted)
      setState(() {
        isLoadingPrevweek = true;
      });
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id  = await storage.read(key: 'id');
    var queryParameters = {
      'rider_id': '$id',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/orderDeliverByRiderPrevWeek'),
      body: queryParameters,
    );
    var result = response.body;

    prevweek = orderHistoryFromJson(result);
    if(Todayorders.length>0)
    {
      setState(() {
        hasDataPrevWeek = true;
        isLoadingPrevweek = false;
      });
    }
    else
    {
      setState(() {
        hasDataPrevWeek = false;
        isLoadingPrevweek = false;
      });
    }
  }

  void ThisMonth() async
  {
    if(this.mounted)
      setState(() {
        isLoadingThismonth = true;
      });
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id  = await storage.read(key: 'id');
    var queryParameters = {
      'rider_id': '$id',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/orderDeliverByRiderThisMonth'),
      body: queryParameters,
    );
    var result = response.body;

     month = orderHistoryFromJson(result);
    if(Todayorders.length>0)
    {
      setState(() {
        hasDataThismonth = true;
        isLoadingThismonth = false;
      });
    }
    else
    {
      setState(() {
        hasDataThismonth =false;
        isLoadingThismonth =false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme
            .of(context)
            .primaryColor),
        title: new Text('History',style: TextStyle(
            color: Colors.black,fontWeight: FontWeight.bold
        ),),
      ),

      body:ListView(
        children: [
          InkWell(
            onTap: ()
            {
              Todaysrders();
              setState(() {
                ToshowToday = ToshowToday == true?false:true;
              });
            },
            child: Card(
              child: ListTile(
                title: Text('Today',style: Theme.of(context).textTheme.headline1,),
              ),
            ),
          ),
          ToshowToday == true?isloadingToday == false?hasDataToday == true?Builders(Todayorders):Text('no record'):Center(child: CircularProgressIndicator(),):SizedBox(height: 1,),
          InkWell(
            onTap: ()
            {
              yesterday();
              setState(() {
                ToshowYesterday = ToshowYesterday == true?false:true;
              });
            },
            child: Card(
              child: ListTile(
                title: Text('Yesterday',style: Theme.of(context).textTheme.headline1),
              ),
            ),
          ),
          ToshowYesterday == true?isLoadingYesterday == false?hasDataYesterday== true?Builders(yesturday):Center(child: Text('no records')):Center(child: CircularProgressIndicator(),):SizedBox(height:1,),
          InkWell(
            onTap: ()
            {
              ThisWeek();
              setState(() {
                ToshowthisWekk =  ToshowthisWekk == true?false:true;
              });
            },
            child: Card(
              child: ListTile(
                title: Text('This Week',style: Theme.of(context).textTheme.headline1),
              ),
            ),
          ),
          ToshowthisWekk == true?isLoadingthisWeek == false?hasDataThisWeek==true?Builders(thisweek):Center(child: Text('no reocrd')):Center(child: CircularProgressIndicator(),):SizedBox(height: 1,),
          InkWell(
            onTap: ()
            {
              Prevweek();
              setState(() {
                ToshowPrevweek =  ToshowPrevweek == true?false:true;
              });
            },
            child: Card(
              child: ListTile(
                title: Text('Previous week',style: Theme.of(context).textTheme.headline1),
              ),
            ),
          ),
          ToshowPrevweek == true?isLoadingPrevweek == false?hasDataPrevWeek== true?Builders(prevweek):Center(child: Text('no record')):Center(child: CircularProgressIndicator(),):SizedBox(height: 1,),
          InkWell(
            onTap: ()
            {
              ThisMonth();
              setState(() {
                ToshowMonth =  ToshowMonth == true?false:true;
              });
            },
            child: Card(
              child: ListTile(
                title: Text('This Month',style: Theme.of(context).textTheme.headline1),
              ),
            ),
          ),
          ToshowMonth == true?isLoadingThismonth == false?hasDataThismonth==true?Builders(month):Center(child: Text('no records')):Center(child: CircularProgressIndicator(),):SizedBox(height: 1,),
        ],
            ));

  }
  Widget Builders(List<OrderHistory> orders)
  {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context,index)
        {
          var order = orders[index];
          return Card(
            child: ListTile(
              title: new Text('${order.shopName}',style: Theme.of(context).textTheme.headline5),
              subtitle: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 58.67*ConfigSize.widthMultiplier,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Text('Order #${order.orderId}',style: Theme.of(context).textTheme.headline2),
                          SizedBox(height: 1,),
                          new Text('Delivery on ${order.riderDeliverdAt}',style: Theme.of(context).textTheme.headline2
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 25.51*ConfigSize.widthMultiplier,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        new Text('Rs. ${order.netTotal}',style: TextStyle(
                            fontSize: 3.82*ConfigSize.widthMultiplier,
                            color: Theme.of(context).primaryColor
                        )),
                        SizedBox(height: 1,),
                        new Text('Profit: ${order.riderCharges}',style: TextStyle(
                            fontSize: 3.4*ConfigSize.widthMultiplier,
                            color:Colors.red
                        ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  // void showHistory()
  // {
  //   Todaysrders();
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: isloading == false?Container(
  //         height: 500,
  //         child: ListView.builder(
  //             itemCount: orders.length,
  //             itemBuilder: (context,index)
  //             {
  //               var order = orders[index];
  //               return Card(
  //                 child: ListTile(
  //                   title: new Text('${order.shopName}',style: Theme.of(context).textTheme.headline5),
  //                   subtitle: Row(
  //                     children: [
  //                       Expanded(
  //                         child: Container(
  //                           width: 230,
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               new Text('${order.orderId}',style: Theme.of(context).textTheme.headline2),
  //                               SizedBox(height: 1,),
  //                               new Text('Delivery on ${order.riderDeliverdAt}',style: Theme.of(context).textTheme.headline2
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 100,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.end,
  //                           children: [
  //                             new Text('Rs. ${order.netTotal}',style: TextStyle(
  //                                 fontSize: 15,
  //                                 color: Theme.of(context).primaryColor
  //                             )),
  //                             SizedBox(height: 1,),
  //                             new Text('Profit: ${order.riderCharges}',style: TextStyle(
  //                                 fontSize: 12,
  //                                 color:Colors.red
  //                             ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             }),
  //       ):Center(child: CircularProgressIndicator(),),
  //       actions: <Widget>[
  //         GestureDetector(
  //           onTap:()
  //           {
  //             Navigator.of(context).pop();
  //           },
  //           child: new Container(
  //             child: new Text("ok",style: TextStyle(
  //                 color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold
  //             ),),
  //             height: 40,
  //             width: 100,
  //             alignment: Alignment.center,
  //             decoration: BoxDecoration(
  //                 color: Theme.of(context).primaryColor,
  //                 borderRadius: BorderRadius.circular(15),
  //                 boxShadow: [
  //                   BoxShadow(
  //                       offset: Offset(0,2),
  //                       color: Colors.black26,
  //                       blurRadius: 3
  //                   )
  //                 ]
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
