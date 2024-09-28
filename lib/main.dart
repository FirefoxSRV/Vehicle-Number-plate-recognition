import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'camera_screen.dart';
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';


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



class CustomScrollableWidget extends StatelessWidget {
  const CustomScrollableWidget({
    super.key,
  });


  Future<void> handleCapturePress(BuildContext context) async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      var permissionResult = await Permission.camera.request();
      if (!permissionResult.isGranted) {
        return;
      }
    }

    final cameras = await availableCameras();

    final firstCamera = cameras.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: firstCamera),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height*0.35,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50))),
            child: Column(
              children: [
                Container(height: MediaQuery.of(context).size.height*0.025,),
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  height: MediaQuery.of(context).size.height*0.05,
                  child: Center(child: Text("Automatic Vehicle Detection",style: GoogleFonts.quicksand(fontWeight:FontWeight.w500,fontSize:22),)),
                  color: Colors.white,
                ),
                Container(height: MediaQuery.of(context).size.height*0.025,),
                Divider(indent: 20,endIndent: 20,),
                Container(height: MediaQuery.of(context).size.height*0.025,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      height: MediaQuery.of(context).size.height*0.08,
                      minWidth: MediaQuery.of(context).size.width*0.88,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      onPressed: () => handleCapturePress(context),
                      child: Text("Capture",style: TextStyle(color: Colors.white),),
                      color: buttonBackground,
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.width*0.1,),
                MaterialButton(
                  height: MediaQuery.of(context).size.height*0.08,
                  minWidth: MediaQuery.of(context).size.width*0.88,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  onPressed: (){

                  },
                  child: Text("Settings",style: TextStyle(color: Colors.white),),
                  color: buttonBackground,
                ),
                SizedBox(height: MediaQuery.of(context).size.width*0.1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      height: MediaQuery.of(context).size.height*0.08,
                      minWidth: MediaQuery.of(context).size.width*0.4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      onPressed: (){


                      },
                      child: Text("About APP",style: TextStyle(color: Colors.white),),
                      color: buttonBackground,
                    ),
                    MaterialButton(
                      height: MediaQuery.of(context).size.height*0.08,
                      minWidth: MediaQuery.of(context).size.width*0.4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      onPressed: (){

                      },
                      child: Text("About us",style: TextStyle(color: Colors.white),),
                      color: buttonBackground,
                    ),
                  ],
                ),
              ],
            ),

          ),

        ],
      ),
    );
  }
}
