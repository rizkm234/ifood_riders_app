import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_riders_app/assistant%20methods/get_current_location.dart';
import 'package:ifood_riders_app/global/global.dart';
import 'package:ifood_riders_app/main%20screens/parcel_delivering_screen.dart';
import 'package:ifood_riders_app/maps/map_utils.dart';



class ParcelPickingScreen extends StatefulWidget {
  final String? purchaserId;
  final String? purchaserAddress;
  final double? purchaserLat;
  final double? purchaserLng;
  final String? sellerId;
  final String? getOrderID;
  const ParcelPickingScreen({Key? key,
  this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.getOrderID,
    this.sellerId
  }) : super(key: key);

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  bool clicked = false;
  double? sellerLat , sellerLng ;
  getSellerData()async{
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(widget.sellerId)
        .get().then((DocumentSnapshot){
          sellerLat = DocumentSnapshot.data()!['lat'];
          sellerLng = DocumentSnapshot.data()!['lang'];
    });
  }

  confirmParcelPicked(getOrderId, sellerId, purchaserId,purchaserAddress, purchaserLat, purchaserLng){
    FirebaseFirestore.instance
        .collection('orders')
        .doc(getOrderId).update({
      'status' : 'delivering',
      'address' : completeAddress,
      'lat' : position!.latitude,
      'lang' : position!.longitude,
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(
        builder: (context)=> ParcelDeliveringScreen(
            getOrderId :getOrderId,
            sellerId: sellerId,
            purchaserId : purchaserId,
            purchaserAddress: purchaserAddress,
            purchaserLat: purchaserLat,
            purchaserLng : purchaserLng
        )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSellerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/confirm1.png', width: 350,),
          const SizedBox(height: 15,),
          GestureDetector(
            onTap: (){
              //cafe / restaurant location
              MapUtils.launchMapFromSourceToDestination(
                  position!.latitude,
                  position!.longitude,
                  sellerLat,
                  sellerLng,
              );
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.green
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 15,),
                  Image.asset('images/restaurant.png', width: 80,),
                  const SizedBox(width: 15,),
                  const Text(
                      'Show Cafe/Rest Location',
                    style: TextStyle(
                      fontFamily: 'Acme',
                      fontSize: 15,
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
                  // clicked = true;
                  // setState(() {
                  //   clicked ;
                  // });
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                  confirmParcelPicked(
                      widget.getOrderID,
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
                      'Order has been picked - Confirmed',
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