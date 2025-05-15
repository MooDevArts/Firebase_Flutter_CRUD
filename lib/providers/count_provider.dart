import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_3/services/database_service.dart';

class CountProvider extends ChangeNotifier {
  int count;
  Map<String, dynamic> valInDB;
  final DatabaseReference _countRef = FirebaseDatabase.instance.ref("path1");
  StreamSubscription<DatabaseEvent>? _listenerSubscription;

  CountProvider({this.count = 0, this.valInDB = const {"count": 0}}) {
    startListening();
  }

  void startListening() {
    _countRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data is Map) {
        // Check if data is a Map
        Map<String, dynamic> typedData = {};
        data.forEach((key, value) {
          typedData[key.toString()] = value; // Convert key to String
        });
        valInDB = typedData;
      } else {
        print("Data from Firebase is not a Map: ${data.runtimeType}");
        valInDB = {};
      }
    });
  }

  void increaseCount() async {
    count = count + 1;
    await DatabaseService().create(path: "path1", data: {'count': count});

    notifyListeners();
  }

  void decreaseCount() async {
    count = count - 1;
    await DatabaseService().create(path: "path1", data: {'count': count});

    notifyListeners();
  }

  void makeCountZero() async {
    count = 0;
    await DatabaseService().create(path: "path1", data: {'count': count});

    notifyListeners();
  }

  @override
  void dispose() {
    _listenerSubscription
        ?.cancel(); // Important to cancel the listener when the provider is disposed
    super.dispose();
  }
}
