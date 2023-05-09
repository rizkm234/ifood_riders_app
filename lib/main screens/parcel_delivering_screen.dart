import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_riders_app/main%20screens/home_screen.dart';

import '../assistant methods/get_current_location.dart';
import '../global/global.dart';
import '../maps/map_utils.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  final String? getOrderId;
  final String? sellerId;
  final String? purchaserId;
  final String? purchaserAddress;
  final double? purchaserLat;
  final double? purchaserLng;
  const ParcelDeliveringScreen({Key? key,
    this.getOrderId,
    this.sellerId,
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng
  }) : super(key: key);

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
String orderTotalAmount = '' ;
  confirmParcelDelivered(
      getOrderId,
      sellerId,
      purchaserId,
      purchaserAddress,
      purchaserLat,
      purchaserLng){
    String riderNewTotalEarningsAmount = (double.parse(previousRiderEarnings)+(double.parse(perParcelDeliveryAmount))).toString() ;
    FirebaseFirestore.instance
        .collection('orders')
        .doc(getOrderId).update({
      'status' : 'ended',
      'address' : completeAddress,
      'lat' : position!.latitude,
      'lang' : position!.longitude,
      'earnings' : perParcelDeliveryAmount,
    }).then((value){
      FirebaseFirestore.instance
          .collection('riders')
          .doc(sharedPreferences!.getString('uid')).update({
        'earnings' : riderNewTotalEarningsAmount,
      });
    }).then((value){
      FirebaseFirestore.instance
          .collection('sellers')
          .doc(widget.sellerId).update({
        'earnings' : (double.parse(orderTotalAmount) + double.parse(previousEarnings)).toString(),
      });
    }).then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(purchaserId)
          .collection('orders')
          .doc(getOrderId).update({
        'status' : 'ended',
        'riderUID' : sharedPreferences!.getString('uid'),
      });
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context)=> const HomeScreen()));
  }
  
  getOrderTotalAmount(){
    FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.getOrderId).get().then((snap){
          orderTotalAmount = snap.data()!['totalAmount'].toString();
          widget.sellerId!= snap.data()!['sellerUID'].toString();
    }).then((value) {
      getSellerData();
    });
  }

  getSellerData(){
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.sellerId).get().then((snap){
          previousEarnings = snap.data()!['earnings'].toString();
    });
      //   .update({
      // 'earnings' : num.parse(orderTotalAmount),
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/confirm2.png'),
          const SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
              //cafe / restaurant location
              MapUtils.launchMapFromSourceToDestination(
                position!.latitude,
                position!.longitude,
                widget.purchaserLat,
                widget.purchaserLng,
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.cyan
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 15,),
                  Image.asset('images/home.png', width: 80,),
                  const SizedBox(width: 15,),
                  const Text(
                    'Show Delivery Drop-off Location',
                    style: TextStyle(
                        fontFamily: 'Acme',
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      // letterSpacing: 2
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, left: 10),
            child: Center(
              child: InkWell(
                onTap: (){
                  //rider location update
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                  confirmParcelDelivered(
                      widget.getOrderId,
                      widget.sellerId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng
                  );
                },
                child: Container(
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [Colors.green , Colors.cyan ],
                      begin: FractionalOffset(0.0,0.0),
                      end: FractionalOffset(1.0,0.0),
                      stops: [0.0 , 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width ,
                  height: 50,
                  child: const Center(
                    child: Text(
                      'Order has been delivered - Confirm',
                      style: TextStyle(color: Colors.white , fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
}
