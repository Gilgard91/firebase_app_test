import 'package:flutter/material.dart';


class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, color: Colors.red, size: 40,),
            Text("Pagina test", style: TextStyle(color: Colors.black, fontSize: 30),),
          ],
        ),
      )
    );
  }
}