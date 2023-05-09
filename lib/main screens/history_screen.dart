import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_riders_app/global/global.dart';
import '../assistant methods/assistant_methods.dart';
import '../widgets/order_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/simple_appBar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key,}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: 'History',),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('riderUID' , isEqualTo: sharedPreferences!.getString('uid') )
            .where('status' , isEqualTo: 'ended' )
            .snapshots(),
        builder: (context , snapshot){
          return snapshot.hasData
              ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context , index){
                return FutureBuilder<QuerySnapshot>(
                  future:FirebaseFirestore.instance
                      .collection('items')
                      .where(
                      'itemID', whereIn: separateOrderItemIDs(
                      (snapshot.data!
                          .docs[index].data()! as Map <String , dynamic>)
                      ['productIDS'] ))
                      .orderBy('publishedDate', descending: true).get(),
                  builder: (context , snap){
                    return snap.hasData
                        ? OrderCard(
                        itemCount: snap.data!.docs.length,
                        data: snap.data!.docs,
                        orderID: snapshot.data!.docs[index].id,
                        seperateQuatitesList: separateOrderItemQuantities((snapshot.data!
                            .docs[index].data()! as Map <String , dynamic>)
                        ['productIDS']))
                        : Center(child: circularProgress(),);
                  },
                );
              }
          )
              : Center(child: circularProgress(),);
        },
      ),
    );
  }
}
