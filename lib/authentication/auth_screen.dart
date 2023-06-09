import 'package:flutter/material.dart';
import 'package:ifood_riders_app/authentication/register.dart';

import 'login.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('iFood',
              style: TextStyle(
                fontSize: 55,
                color: Colors.white,
                fontFamily: 'Signatra',
                letterSpacing: 6
              ),),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber , Colors.cyan ],
                  begin: FractionalOffset(0.0,0.0),
                  end: FractionalOffset(1.0,0.0),
                  stops: [0.0 , 1.0],
                  tileMode: TileMode.clamp,
                )
              ),
            ),
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              indicatorColor: Colors.white38,
              indicatorWeight: 6,
              tabs: [
              Tab(
                icon: Icon(Icons.lock , color: Colors.white,),
                text: 'Login',
              ),
              Tab(
                icon: Icon(Icons.person , color: Colors.white,),
                text: 'Register',
              ),
            ],),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber , Colors.cyan],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              )
            ),
            child: const TabBarView(
              children: [
                LoginScreen(),
                RegisterScreen(),
              ],
            ),
          ),
        ),
    );
  }
}
