import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNav2 extends StatefulWidget {
  const BottomNav2({Key? key}) : super(key: key);

  @override
  State<BottomNav2> createState() => _BottomNav2State();
}

class _BottomNav2State extends State<BottomNav2> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Navigator(
      onGenerateRoute: (settings) {
        Widget page = Page1();
        if (settings.name == 'page2') page = Page2();
        return MaterialPageRoute(builder: (_) => page);
      },
    ),
    const Icon(
      Icons.chat,
      size: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 78,
        child: Column(
          children: [
            const SizedBox(
              height: 22,
            ),
            BottomNavigationBar(
              selectedFontSize: 0.0,
              unselectedFontSize: 0.0,
              backgroundColor: Colors.orange,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.call),
                  label: 'Call',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.message), label: 'Message'),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ],
        ),
      ),
      // body: Navigator(
      //   onGenerateRoute: (settings) {
      //     Widget page = Page1();
      //     if (settings.name == 'page2') page = Page2();
      //     return MaterialPageRoute(builder: (_) => page);
      //   },
      // ),
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 65.0,
        width: double.infinity,
        color: Colors.blue,
        child: Text(
          "test cái ha",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, 'page2'),
          child: const Text('Go to Page2'),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Page2')),
        body: Center(child: Text("Đây là trang 2")),
      );
}
