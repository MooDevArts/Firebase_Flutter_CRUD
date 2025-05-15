import 'package:flutter/material.dart';
import 'package:hello_world_3/services/database_service.dart';

class CountProvider extends ChangeNotifier {
  int count;

  CountProvider({this.count = 0});

  void increaseCount() async {
    count = count + 1;
    await DatabaseService().create(path: "path1", data: "{'count':$count}");
    notifyListeners();
  }

  void decreaseCount() async {
    count = count - 1;
    await DatabaseService().create(path: "path1", data: "{'count':$count}");
    notifyListeners();
  }

  void makeCountZero() async {
    count = 0;
    await DatabaseService().create(path: "path1", data: "{'count':$count}");
    notifyListeners();
  }
}
