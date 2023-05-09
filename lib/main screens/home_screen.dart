import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ifood_riders_app/main%20screens/history_screen.dart';
import 'package:ifood_riders_app/main%20screens/new_orders_screen.dart';
import 'package:ifood_riders_app/main%20screens/not_yet_delivered.dart';
import 'package:ifood_riders_app/main%20screens/parcel_delivering_screen.dart';
import 'package:ifood_riders_app/main%20screens/parcel_in_progress_screen.dart';
import 'package:ifood_riders_app/main%20screens/total_earnings_screen.dart';
import '../assistant methods/get_current_location.dart';
import '../authentication/auth_screen.dart';
import '../global/global.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title , IconData iconData , int index){
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 2 || index == 4
            ? const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan , Colors.amber ],
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0,0.0),
                stops: [0.0 , 1.0],
                tileMode: TileMode.clamp,
          ),
        )
            : const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber , Colors.cyan ],
            begin: FractionalOffset(0.0,0.0),
            end: FractionalOffset(1.0,0.0),
            stops: [0.0 , 1.0],
            tileMode: TileMode.clamp,
          ),
        ) ,
        child: InkWell(
          onTap: (){
            if (index == 0) {
              //new orders
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=> const NewOrdersScreen()
              ));
            }
            if (index == 1) {
              //Parcel in progress
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=>  const ParcelInProgressScreen()
              ));
            }
            if (index == 2) {
              //No yet delivered
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=>  const NotYetDeliveredScreen()
              ));
            }
            if (index == 3) {
              //History
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=>  const HistoryScreen()
              ));
            }
            if (index == 4) {
              //Total Earnings
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (context)=>  const TotalEarningsScreen()
              ));
            }
            if (index == 5) {
              //Log out
              firebaseAuth.signOut().then((value){
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (context)=> const AuthScreen()
                ));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50,),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10,),
              Center(
                child: Text(title ,
                style: const TextStyle(
                    fontSize: 16 , color: Colors.white
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
  }

  getRiderPreviousEarnings(){
    FirebaseFirestore.instance
        .collection('riders')
        .doc(sharedPreferences!.getString('uid'))
        .get().then((snap){
          setState(() {
            previousRiderEarnings = snap.data()!['earnings'].toString();
          });
    });
  }


  getPerParcelDeliveryAmount(){
    FirebaseFirestore.instance
        .collection('perDelivery')
        .doc('m8pWRsmSbMLb7Hp3zs6S').get().then((snap) {
          perParcelDeliveryAmount = snap.data()!['amount'].toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                sharedPreferences!.getString('photoUrl').toString() ,
              height: 40, width: 40, fit: BoxFit.cover,),
            const SizedBox(width: 5,),
            Text('Welcome ${sharedPreferences!.getString('name')!}' ,
              style: const TextStyle(
              fontSize: 25 , color: Colors.white ,
                  fontFamily: 'Signatra', fontWeight: FontWeight.normal),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan , Colors.amber ],
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0,0.0),
                stops: [0.0 , 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50 , horizontal: 1),
        child: GridView.count(
            crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem('New Available Orders', Icons.assignment, 0),
            makeDashboardItem('Parcel in progress', Icons.airport_shuttle, 1),
            makeDashboardItem('Not Yet Delivered', Icons.location_history, 2),
            makeDashboardItem('History', Icons.done_all, 3),
            makeDashboardItem('Total Earnings', Icons.monetization_on_outlined, 4),
            makeDashboardItem('Log out', Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
