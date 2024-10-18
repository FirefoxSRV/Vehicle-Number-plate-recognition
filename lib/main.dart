import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'camera_screen.dart';
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/custom_scollable_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyDgGVyOqFBb-djdzgAuddXvJAh_Ra8mvaU',
      appId: '1:881877825860:android:2908e1c6eb994012533f11',
      messagingSenderId: '881877825860',
      projectId: 'mad-project-627be',
      storageBucket: 'mad-project-627be.appspot.com',
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: buttonBackground),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/home.png"),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height*0.6,
              ),
            ],
          ),
          //Content
          CustomScrollableWidget(),
        ],
      ),
    );
  }
}


