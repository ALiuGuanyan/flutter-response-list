import 'package:flutter/material.dart';
import '../mock/data.dart';

const double NAV_ITEM_WIDTH = 100.0;
const Duration ANIMATE_DURATION = Duration(milliseconds: 200);

class IndexPage extends StatefulWidget {
  final Size size;

  IndexPage({Key key,@required this.size}):super(key: key);
  
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _current = 0;
  ScrollController _controller;

  // 这里的高度我给写死了，
  // 你可以用globalkey
  // 去动态获取每一个tab 对应内容的高度
  final double _contentHeight = 280.0;
  final double _navItemHeight = 100.0;
  
  final double contentVerticalPadding = 10.0;
  
  void listen(double height) {
    // 自己调整滑动多少更改激活状态
    if (_controller.offset > (_current) * height + _navItemHeight) {
      setState(() {
        _current = _current + 1;
      });
    }

    if (_controller.offset < (_current - 1) * height + _navItemHeight) {
      setState(() {
        _current = _current - 1;
      });
    }


  }
  
  

  @override
  void initState() {

    _controller = ScrollController();
    _controller.addListener(() {
      double height = _contentHeight + _navItemHeight ;
      listen(height);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _rhsWidth = widget.size.width - NAV_ITEM_WIDTH;
    double _navItemHeight = widget.size.height / nav.length;
    return Container(
      color: Color(0xFFF3F3F3),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("商品分类", style: TextStyle(color: Colors.black87),),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Color(0xFFF3F3F3),
          body: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Positioned(
                left: 0,
                height: widget.size.height,
                child: Column(
                  children: List.generate(
                    nav.length,
                        (int index) {
                          return GestureDetector(
                            onTap: () {
                              if ( index != _current) {
                                setState(() {
                                  _current = index;
                                });
                                _controller.animateTo(
                                  _current * (_contentHeight + _navItemHeight + contentVerticalPadding),
                                  duration: ANIMATE_DURATION,
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: ANIMATE_DURATION,
                              width: NAV_ITEM_WIDTH,
                              height: _navItemHeight,
                              color: _current == index ? Color(0xFFF3F3F3) : Colors.white,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  child: Text(
                                    nav[index]["name"],
                                  ),
                                  style: TextStyle(
                                    color: _current == index ? Colors.black87 : Colors.grey[400],
                                    fontWeight: FontWeight.bold,
                                  ),
                                  duration: ANIMATE_DURATION,
                                ),
                              ),
                            ),
                          );
                        },
                  ),
                ),
              ),
              Positioned(
                right: 0,
                width: _rhsWidth,
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(widget.size),
                  child: ListView(
                    children: List.generate(nav.length, (int index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: _navItemHeight,
                            width: _rhsWidth,
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                nav[index]["name"],
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: _contentHeight,
                            width: _rhsWidth,
                            margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, contentVerticalPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            child: NavContent(
                              content: nav[index]["content"],
                            ),
                          )
                        ],
                      );
                    },),
                    controller: _controller,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class NavContent extends StatelessWidget {
  final double _bkgSize = 70.0;
  final List<String> content;


  NavContent({
    Key key,
    this.content,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: List.generate(content.length, (int index) {
          return Container(
            width: _bkgSize + 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  width: _bkgSize,
                  height: _bkgSize,
                ),
                Center(
                  child: Text(
                    content[index],
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 12.0,
                    ),
                  ),
                )
              ],
            ),
          );
        },),
      ),
    );
  }
}
