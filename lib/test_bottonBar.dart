import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  PageController _myPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        // shape: CircularNotchedRectangle(),

        child: Container(
          color: Colors.black,
          height: 77,
          child: Column(
            children: [
              const SizedBox(
                height: 29,
              ),
              Row(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    iconSize: 30.0,
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _myPage.jumpToPage(0);
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 30.0,
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _myPage.jumpToPage(1);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        onPageChanged: (int) {
          print('Page Changes to index $int');
        },
        children: <Widget>[
          Navigator(
            onGenerateRoute: (settings) {
              Widget page = Page1();
              if (settings.name == 'page2') page = Page2();
              return MaterialPageRoute(builder: (_) => page);
            },
          ),
          Center(
            child: Container(
              child: Text('Đây thì là tìm kiếm'),
            ),
          ),
        ],

        physics:
            NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
      ),
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
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            'page2',
            arguments: <String, String>{
              'city': 'Berlin',
              'country': 'Germany',
            },
          ),
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
