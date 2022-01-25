import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ListModel> listNew = [];
  final ItemScrollController _tabScrollController = ItemScrollController();
  final ItemScrollController _tabScrollController2 = ItemScrollController();
  final ItemPositionsListener _bodyPositionsListener =
      ItemPositionsListener.create();
  final ValueNotifier<int> _index = ValueNotifier<int>(0);
  void _onInnerViewScrolled() async {
    var positions = _bodyPositionsListener.itemPositions.value;

    if (positions.isEmpty) return;

    var firstIndex =
        _bodyPositionsListener.itemPositions.value.elementAt(0).index;

    if (_index.value == firstIndex) return;

    log(firstIndex.toString());
    _index.value = firstIndex;
    await _tabScrollController2.scrollTo(
        index: _index.value, duration: const Duration(milliseconds: 300));
    setState(() {});
  }

  @override
  void dispose() {
    _bodyPositionsListener.itemPositions.removeListener(_onInnerViewScrolled);
    return super.dispose();
  }

  @override
  void initState() {
    listNew = List.generate(
        26,
        (index) => ListModel(
            head: index.toString(),
            list: List.generate(10,
                (index2) => "$index $index $index $index2 $index2 $index2")));
    _bodyPositionsListener.itemPositions.addListener(_onInnerViewScrolled);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: ScrollablePositionedList.builder(
                itemScrollController: _tabScrollController2,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) {
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 7.5, right: 7.5, top: 15, bottom: 15),
                    height: 50,
                    width: 100,
                    color: _index.value == i ? Colors.pink : Colors.blue,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _tabScrollController.scrollTo(
                                index: i,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          });
                        },
                        child: Center(
                          child: Text(
                            listNew[i].head,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: listNew.length,
              ),
            ),
            Expanded(
              child: ScrollablePositionedList.builder(
                itemPositionsListener: _bodyPositionsListener,
                itemScrollController: _tabScrollController,
                itemBuilder: (ctx, i) {
                  ListModel data = listNew[i];
                  return Column(
                    children: [
                      Container(
                        height: 50,
                        color: i.isOdd ? Colors.orange : Colors.pink,
                        child: Center(
                          child: Text(
                            data.head,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      ...List.generate(data.list.length,
                          (index) => Container(height: 50, color: Colors.blue))
                    ],
                  );
                },
                itemCount: listNew.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListModel {
  final String head;
  final List<String> list;
  ListModel({required this.list, required this.head});
}
