// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MacDock(),
      ),
    );
  }
}

class MacDock extends StatefulWidget {
  const MacDock({super.key});

  @override
  State<MacDock> createState() => MacDockState();
}

class MacDockState extends State<MacDock> {
  List<IconData> iconItems = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];
  int? draggingIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 70,
        // width: MediaQuery.of(context).size.width * 0.9,
        width: iconItems.length * 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black12,
        ),
        padding: const EdgeInsets.all(2),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: iconItems.length,
          itemBuilder: (context, index) {
            return DragTarget<int>(
              onWillAcceptWithDetails: (oldIndex) => oldIndex != index,
              onAcceptWithDetails: (oldIndex) {
                setState(() {
                  final item = iconItems.removeAt(oldIndex.data);
                  iconItems.insert(index, item);
                });
              },
              builder: (context, candidateData, rejectedData) {
                return Draggable<int>(
                  data: index,
                  onDragStarted: () {
                    setState(() {
                      draggingIndex = index;
                    });
                  },
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      draggingIndex = null;
                    });
                  },
                  onDragCompleted: () {
                    setState(() {
                      draggingIndex = null;
                    });
                  },
                  childWhenDragging: Container(
                    width: 50,
                    height: 50,
                    // margin: EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  feedback: Material(
                    color: Colors.transparent,
                    child: renderDockItem(index, isDragging: true),
                  ),
                  // child: renderDockItem(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.bounceOut,
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.primaries[
                          iconItems[index].hashCode % Colors.primaries.length],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: draggingIndex == index
                          ? [
                              const BoxShadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ]
                          : [],
                    ),
                    child: renderDockItem(index),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget renderDockItem(int index, {bool isDragging = false}) {
    return Container(
      constraints: const BoxConstraints(minWidth: 50),
      height: 50,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors
            .primaries[iconItems[index].hashCode % Colors.primaries.length],
        boxShadow: isDragging
            ? [
                const BoxShadow(
                    color: Colors.black26, blurRadius: 20, spreadRadius: 5)
              ]
            : [],
      ),
      child: Center(child: Icon(iconItems[index], color: Colors.white)),
    );
  }
}
