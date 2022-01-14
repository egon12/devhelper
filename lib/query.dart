import 'package:devhelper/table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Query extends StatefulWidget {
  Query({Key? key}) : super(key: key);

  final focusNode = FocusNode(debugLabel: 'Query');

  @override
  State<StatefulWidget> createState() {
    return QueryState();
  }
}

class QueryState extends State<Query> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyDB local')),
      body: SafeArea(
        child: Column(
          children: [
            const Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  maxLines: 300, // some bad hardcode
                  style: TextStyle(fontFamily: 'Monospace'),
                ),
              ),
            ),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                TextButton(child: const Text('INSERT'), onPressed: () {}),
                TextButton(child: const Text('UPDATE'), onPressed: () {}),
                TextButton(child: const Text('INSERT'), onPressed: () {}),
                TextButton(
                  child: const Text('EXECUTE'),
                  onPressed: () {
                    Get.to(DBTable());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
