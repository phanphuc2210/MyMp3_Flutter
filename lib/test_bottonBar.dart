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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0),
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
                    padding: EdgeInsets.only(right: 28.0),
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
          Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Trang home nè ha'),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(3);
                        });
                      },
                      child: Text("Khac khac"))
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              child: Text('Đây thì là tìm kiếm'),
            ),
          ),
          Center(
            child: Container(
              child: Text('Đây thì là trang 3 trong truyền thuyết'),
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
