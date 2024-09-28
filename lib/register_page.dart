import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';

class RegisterPage extends StatefulWidget {
  final String recognizedText;

  const RegisterPage({super.key, required this.recognizedText});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _numberPlateController = TextEditingController();
  final TextEditingController _vehicleOwnerController = TextEditingController();
  String? _selectedCategory; // Variable to hold selected category
  bool _inOutStatus = true;

  List<String> categories = ['Faculty', 'Student', 'PG Scholar'];

  @override
  void initState() {
    super.initState();
    _numberPlateController.text = widget.recognizedText;
    _selectedCategory = categories.first;
  }

  @override
  void dispose() {
    _numberPlateController.dispose();
    _vehicleOwnerController.dispose();
    super.dispose();
  }

  Future<void> addVehicle() async {
    String? id = FirebaseDatabase.instance.ref().push().key;
    await FirebaseDatabase.instance.ref('vehicles/$id').set({
      'numberPlate': _numberPlateController.text,
      'vehicleOwner': _vehicleOwnerController.text,
      'category': _selectedCategory,
      'inOutStatus': _inOutStatus
    });
  }

  void _submitForm() {
    if (_numberPlateController.text.isNotEmpty &&
        _vehicleOwnerController.text.isNotEmpty &&
        _selectedCategory != null) {
      addVehicle().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vehicle registered successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register vehicle: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Vehicle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _numberPlateController,
              decoration: InputDecoration(
                labelText: 'Number Plate',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _vehicleOwnerController,
              decoration: InputDecoration(
                labelText: 'Vehicle Owner',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('IN/OUT Status'),
              value: _inOutStatus,
              onChanged: (bool value) {
                setState(() {
                  _inOutStatus = value;
                });
              },
            ),
            SizedBox(height: 20),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: buttonBackground)
              ),
              onPressed: _submitForm,
              child: Text('Register Vehicle'),
            ),
          ],
        ),
      ),
    );
  }
}