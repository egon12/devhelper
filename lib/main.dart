import 'package:devhelper/edit_db.dart';
import 'package:devhelper/query.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'storage/db.dart';
import 'main_list.dart';
import 'main_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var db = await getDB();
  Get.put(db);
  MainBinding mainBinding = MainBinding();

  runApp(
    MyApp(mainBinding: mainBinding),
  );
}

class MyApp extends StatelessWidget {
  final MainBinding mainBinding;

  const MyApp({Key? key, required this.mainBinding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dev Helper',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: const MainList(),
      initialBinding: mainBinding,
      getPages: [
        EditDBGetPage,
        GetPage(name: '/query', page: () => Query(), binding: QueryBinding())
      ],
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: MyHomePage(title: 'Flutter Home Page'),
    );
  }
  */
}
