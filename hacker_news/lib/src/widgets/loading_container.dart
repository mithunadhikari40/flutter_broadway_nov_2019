import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListTile(
      title: buildContainer(width),
      subtitle: buildContainer(width),
    );
  }

  Widget buildContainer(width) {
    return Container(
      width: width * .8,
      height: 24.0,
      color: Colors.black12,
    );
  }
}
