import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget productShimmerCard() {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Container(
      padding: EdgeInsets.all(9.0),
      color: Colors.white,
      child: _productShimmerCard(),
    ),
  );
}

Widget _productShimmerCard() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.grey[200],
        child: Container(
          height: 20.0,
          width: 500.0,
          color: Colors.white,
        ),
      ),
      Container(
        height: 10.0,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[400],
        highlightColor: Colors.grey[200],
        child: Container(
          height: 20.0,
          width: 100.0,
          color: Colors.white,
        ),
      ),
      Container(
        height: 10.0,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        child: Container(
          height: 30.0,
          width: 300.0,
          color: Colors.white,
        ),
      ),
      SizedBox(
        height: 30.0,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        child: Container(
          height: 20.0,
          width: 500.0,
          color: Colors.white,
        ),
      ),
      Container(
        height: 10.0,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        child: Container(
          height: 20.0,
          width: 100.0,
          color: Colors.white,
        ),
      ),
      Container(
        height: 10.0,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        child: Container(
          height: 30.0,
          width: 300.0,
          color: Colors.white,
        ),
      )
    ],
  );
}
