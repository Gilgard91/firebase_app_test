import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';

import 'demo_page.dart';

class Screen extends StatefulWidget {
  const Screen({
    super.key,
  });

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final _controller = GlobalKey<PageFlipWidgetState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageFlipWidget(
          key: _controller,
          backgroundColor: Colors.yellow,
          cutoffPrevious: 0.1,
          initialIndex: 0,
          // isRightSwipe: true,
          lastPage: Container(
              color: Colors.white,
              child: const Center(child: Text('Last Page!'))),
          children: <Widget>[
            for (var i = 0; i < 10; i++) DemoPage(page: i),
          ],
          onPageFlipped: (pageNumber) {
            debugPrint('onPageFlipped: (pageNumber) $pageNumber');
          },
          onFlipStart: () {
            debugPrint('onFlipStart');
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: const Icon(Icons.navigate_next),
        //   onPressed: () {
        //     _controller.currentState?.nextPage();
        //   },
        // ),
      ),
    );
  }
}