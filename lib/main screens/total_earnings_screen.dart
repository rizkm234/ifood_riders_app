import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_riders_app/global/global.dart';
import '../widgets/simple_appBar.dart';

class TotalEarningsScreen extends StatefulWidget {
  const TotalEarningsScreen({Key? key}) : super(key: key);

  @override
  State<TotalEarningsScreen> createState() => _TotalEarningsScreenState();
}

class _TotalEarningsScreenState extends State<TotalEarningsScreen> {
  String total = FirebaseFirestore.instance
      .collection('riders').doc(sharedPreferences!.getString('uid')).toString() ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: 'Total Earnings',),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan , Colors.amber ],
              begin: FractionalOffset(0.0,0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0 , 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const Icon(Icons.monetization_on , color: Colors.white,size: 250,),
              const SizedBox(height: 10,),
              const Text(
                'Total Earnings:' , style: TextStyle(
                  fontSize: 40 ,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              )),
              Text('EGP: $previousRiderEarnings' , style: const TextStyle(
                  fontSize: 35, color: Colors.white
              )),
            ],),
        ),
      ),
    );
  }
}
