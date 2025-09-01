import 'package:app_test/home_page.dart';
import 'package:app_test/pageflip/demo_page.dart';
import 'package:app_test/pageflip/page_flip.dart';
import 'package:app_test/test_page.dart';
import 'package:flutter/material.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});

  @override
  _TabBarPageState createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5151C6),
        bottomOpacity: 0,
        title: TabBar(
          dividerColor: Colors.transparent,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home, color: Colors.white,)),
            Tab(icon: Icon(Icons.settings, color: Colors.white,)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomePage(),
          TestPage()
        ],
      ),
    );
  }
}