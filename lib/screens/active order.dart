import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:rider_app_nukarshop/models/activeordres.dart';
import 'package:rider_app_nukarshop/tricks/configSize.dart';
import 'package:rider_app_nukarshop/tricks/widgets.dart';
import 'OrdersDetails Screens.dart';
class ActiveOrders extends StatefulWidget {
  @override
  _AvaiableOrdersState createState() => _AvaiableOrdersState();
}

class _AvaiableOrdersState extends State<ActiveOrders> {
  var isLoading = false;
  var hasData = false;
  List<ActiveOreders> activeorders = [];
  Future<void> getActiveOrders() async
  {
    if(this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    FlutterSecureStorage storage = FlutterSecureStorage();
    var id  = await storage.read(key: 'id');
    var queryParameters = {
      'rider_id': '$id',
    };
    http.Response response = await http.post(
      Uri.parse('https://nukarshop.pk/api/activeOrdersOfRider'),
      body: queryParameters,
    );
    String list = response.body;
    activeorders = activeOredersFromJson(list);
    if (activeorders.length > 0) {
      if(this.mounted)
      {
        setState(() {
          hasData = true;
          isLoading = false;
        });
      }
    }
    else
    {
      if(this.mounted)
      {
        setState(() {
          hasData = false;
          isLoading = false;
        });
      }
    }
  }
  @override
  void initState() {
    getActiveOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == false?hasData == true?ListView(
        padding: EdgeInsets.symmetric(vertical: 1.88*ConfigSize.heightMultiplier,horizontal: 3.82*ConfigSize.widthMultiplier),
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: activeorders.length,
              itemBuilder: (context,items){
                var perOrder = activeorders[items];
                return Column(
                  children: [
                    InkWell(
                      onTap:()
                      {
                      Navigator.push(context, MaterialPageRoute(builder: (_)=>OrdersDetails(perOrder.orderId))).then((_){
                      hasData = false;
                      getActiveOrders();
                      if(mounted)
                      {
                      setState(() {
                      });
                      }

                      });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical:0.87*ConfigSize.heightMultiplier ,horizontal: 1.78*ConfigSize.widthMultiplier),
                        margin: EdgeInsets.symmetric(vertical: 1.25*ConfigSize.heightMultiplier),
                        height: 16.33*ConfigSize.heightMultiplier,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                backgroundImage: AssetImage('images/otherPlaceHolder.png'),
                                radius: 3.01*ConfigSize.heightMultiplier
                            ),
                            SizedBox(width: 2.55*ConfigSize.widthMultiplier,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width:61.22*ConfigSize.widthMultiplier,
                                    child: new Text('${perOrder.shopName}',overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.headline4,)),
                                new Text('Order # ${perOrder.uniqueId}',style: Theme.of(context).textTheme.headline2,),
                                SizedBox(height: 1.25*ConfigSize.heightMultiplier,),
                                // Row(
                                //   children: [
                                //     Container(
                                //       decoration: BoxDecoration(
                                //         borderRadius: BorderRadius.circular(100),
                                //         color: Colors.red
                                //       ),
                                //       child: Icon(Icons.restaurant_menu_rounded,color: Colors.white,),
                                //     ),
                                //     SizedBox(width: 3,),
                                //     // new Text('${perOrder.}'),
                                //   ],
                                // ),
                                SizedBox(height: 0.63*ConfigSize.heightMultiplier,),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: Colors.green
                                      ),
                                      child: Icon(Icons.home,color: Colors.white,),
                                    ),
                                    SizedBox(width: 0.76*ConfigSize.widthMultiplier),
                                    Container(
                                        width:48.46*ConfigSize.widthMultiplier,
                                        child: new Text('${perOrder.shippingAdd}',overflow: TextOverflow.ellipsis,maxLines: 2,style: Theme.of(context).textTheme.headline4,)),
                                  ],
                                ),
                                SizedBox(height: 0.87*ConfigSize.heightMultiplier,),
                                GestureDetector(
                                  onTap:()
                                  {
                                    widgets().showErrorDialogue(context, '${perOrder.customer_note}');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 0.76*ConfigSize.widthMultiplier,vertical: 0.37*ConfigSize.heightMultiplier),
                                    child:Text("Instructions",style: Theme.of(context).textTheme.headline4) ,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: Theme.of(context).primaryColor
                                        )
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(thickness: 2,)
                  ],
                );
              })
        ],
      ):Center(child: Text('No Active Orders!'),):Center(child: CircularProgressIndicator(),),
    );
  }
}
