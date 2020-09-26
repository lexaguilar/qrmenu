import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int offset = 0;
    int time = 800;

    return SafeArea(
        child: Stack(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 200),
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                offset += 5;
                time = 800 + offset;

                return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey[300],
                      child: ShimmerLayout(index),
                      period: Duration(milliseconds: time),
                    ));
              },
            )),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Shimmer.fromColors(
              highlightColor: Colors.white,
              baseColor: Colors.grey[300],
              child: ShimmerLayout2(),
              period: Duration(milliseconds: time),
            ))
      ],
    ));
  }
}

class ShimmerLayout extends StatelessWidget {
  final int index;
  ShimmerLayout(this.index);

  @override
  Widget build(BuildContext context) {
    double containerWidth = 260;
    double containerHeight = 15;

    List<Widget> container(int index) {
      return [
        Container(
          height: 100,
          width: 100,
          color: Colors.grey,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: containerHeight,
              width: containerWidth,
              color: Colors.grey,
            ),
            SizedBox(height: 5),
            Container(
              height: containerHeight,
              width: containerWidth,
              color: Colors.grey,
            ),
            SizedBox(height: 5),
            Container(
              height: containerHeight,
              width: containerWidth * 0.75,
              color: Colors.grey,
            )
          ],
        )
      ];
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: container(index)),
    );
  }
}

class ShimmerLayout2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> container() {
      return [
        Container(
          height: 150,
          width: 180,
          color: Colors.grey,
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150,
              width: 180,
              color: Colors.grey,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            SizedBox(height: 5),
          ],
        )
      ];
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: container()),
    );
  }
}
