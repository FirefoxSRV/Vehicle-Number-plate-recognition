import 'dart:io';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'register_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class FormPage extends StatefulWidget {
  final String recognizedText;
  final String imagePath;

  const FormPage({Key? key, required this.recognizedText, required this.imagePath}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.recognizedText);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void checkPlateAndToggleStatus(BuildContext context, String recognizedText) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('vehicles');
    Query query = ref.orderByChild('numberPlate').equalTo(recognizedText);

    DataSnapshot snapshot = await query.get();

    if (snapshot.exists && snapshot.value != null) {
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data.isNotEmpty) {
        String key = data.keys.first;
        bool currentStatus = data[key]['inOutStatus'] as bool;

        bool newStatus = !currentStatus;
        String arrayKey = newStatus ? 'entryArray' : 'exitArray';

        // Append the current timestamp to the respective array
        await ref.child(key).child(arrayKey).push().set(DateTime.now().toIso8601String());

        // Update the inOutStatus
        await ref.child(key).update({'inOutStatus': newStatus});

        String message = newStatus ? 'ENTERED' : 'EXITED';
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Status Updated'),
            content: Text('The vehicle has $message.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      } else {
        print("Error: Data is not in expected format or no data found.");
      }
    } else {
      // No data found, navigate to the registration page
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return RegisterPage(recognizedText: recognizedText);
      }));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Number Plate")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (widget.imagePath.isNotEmpty)
              Container(
                height: 300,
                width: double.infinity,
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            TextFormField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Number Plate'),
            ),
            SizedBox(height: 20),
            MaterialButton(
              color: buttonBackground,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.black54)
              ),
              onPressed: () {
                String text = textController.text;
                print(text);
                checkPlateAndToggleStatus(context,text);
              },
              child: Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}