import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const leftMargin = 40.0;

class SportsStorePage extends StatefulWidget {
  @override
  _SportsStorePageState createState() => _SportsStorePageState();
}

class _SportsStorePageState extends State<SportsStorePage> {
  final _priceNotifier = ValueNotifier<int>(0);

  final _pageController = PageController(viewportFraction: 0.9);

  final _pageNotifier = ValueNotifier<double>(0.0);

  Widget _buildHeader() {
    Widget _buildGroup(bool selected, IconData icon) {
      return Row(
        children: [
          Icon(
            icon,
            color: selected ? Colors.black : Colors.grey[300],
            size: 13,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            'Soccer ball',
            style: TextStyle(
              fontSize: 13,
              color: selected ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: leftMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sports store',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: leftMargin),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey[300],
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(children: [
                _buildGroup(true, Icons.battery_charging_full),
                const SizedBox(
                  width: 20,
                ),
                _buildGroup(false, Icons.shopping_basket),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() => BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey[300],
        elevation: 4,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.shopping_basket,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.wb_sunny,
            ),
          )
        ],
      );

  Widget _buildBottomWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: leftMargin),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage('images/mesi.png'),
            ),
            title: Text(
              'Lionel Messi',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Barcelona',
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  void _listener() {
    _pageNotifier.value = _pageController.page;
    setState(() {});
  }

  @override
  void initState() {
    lastPrice = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.addListener(_listener);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_listener);
    _pageController.dispose();
    _pageNotifier.dispose();
    _priceNotifier.dispose();
    super.dispose();
  }

  int lastPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: StreamBuilder(
          stream: Firestore.instance.collection('product').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');

            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 46),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            width: MediaQuery.of(context).size.width / 3,
                            bottom: 20,
                            child: Padding(
                              padding: const EdgeInsets.only(left: leftMargin),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Spacer(),
                                  ValueListenableBuilder<int>(
                                      valueListenable: _priceNotifier,
                                      builder: (context, value, child) {
                                        return TweenAnimationBuilder<int>(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          tween: IntTween(
                                              begin: lastPrice, end: value),
                                          builder:
                                              (context, animationValue, child) {
                                            return Text(
                                              "\$$animationValue",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey[700],
                                              ),
                                            );
                                          },
                                        );
                                      }),
                                  Spacer(),
                                  Text(
                                    'Available size',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: OutlineButton(
                                            onPressed: null,
                                            child: Text(
                                              '3',
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: OutlineButton(
                                            onPressed: null,
                                            child: Text(
                                              '4',
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: OutlineButton(
                                            onPressed: null,
                                            child: Text(
                                              '5',
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ValueListenableBuilder<double>(
                            valueListenable: _pageNotifier,
                            builder: (context, value, child) => PageView.builder(
                              controller: _pageController,
                              itemCount: snapshot.data.documents.length,
                              onPageChanged: (index) {
                                //every time the page changed, get the current page and get the price from the balls array
                                //update the value to the notifier and object inside [ValueListenableBuilder] will rebuild
                                // _priceNotifier.value = snapshot.data.documents[index].price;
                                // lastPrice = snapshot.data.documents[index].price;
                                _priceNotifier.value = snapshot.data.documents[index]["price"];
                                lastPrice = snapshot.data.documents[index]["price"];
                              },
                              itemBuilder: (context, index) {
                                final lerp = lerpDouble(
                                    1, 0, (index - _pageNotifier.value).abs());

                                double opacity = lerpDouble(
                                    1.0, 0.0, (index - _pageNotifier.value).abs());
                                opacity = opacity < 0 ? 0 : opacity;
                                return Opacity(
                                  opacity: opacity,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 20,
                                              ),
                                              child: Hero(
                                                tag:
                                                    'hero_text_${snapshot.data.documents[index]["name"]}',
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: Text(
                                                    snapshot.data.documents[index]["name"]
                                                        .split(" ")
                                                        .join("\n"),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.black,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(PageRouteBuilder(
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 800),
                                                  pageBuilder: (_, animation, __) =>
                                                  FadeTransition(
                                                    opacity: animation,
                                                  ),
                                                ));
                                              },
                                              child: Hero(
                                                tag:
                                                    'hero_background_${snapshot.data.documents[index]["name"]}',
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF07205A),
                                                    borderRadius:
                                                        BorderRadius.circular(20.0),
                                                  ),
                                                  child: Align(
                                                    alignment: Alignment.bottomLeft,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(30),
                                                      child: Material(
                                                        color: Colors.transparent,
                                                        child: Text(
                                                          snapshot.data.documents[index]["model"]
                                                              .split(" ")
                                                              .join("\n"),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Transform.scale(
                                          alignment: Alignment.centerRight,
                                          scale: lerp,
                                          child: Hero(
                                            tag: 'hero_ball_${snapshot.data.documents[index]["name"]}',
                                            child: Image.asset(
                                              snapshot.data.documents[index]["image"],
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomWidget(),
                ],
              ),
            );
          }
        )
      ),
    );
  }
}

