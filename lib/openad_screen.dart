import 'package:flutter/material.dart';

class OpenAdPage extends StatelessWidget {
  const OpenAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "home Open",
        home: Scaffold(
          body: Center(
            child: Column(
              children: [
                Text("Halloo ini benner saya"),
                ElevatedButton(onPressed: () {}, child: Text("Open ad"))
              ],
            ),
          ),
        ));
  }
}
