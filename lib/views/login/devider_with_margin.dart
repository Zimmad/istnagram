import 'package:flutter/material.dart';

class DeviderWithMargin extends StatefulWidget {
  const DeviderWithMargin({Key? key}) : super(key: key);

  @override
  State<DeviderWithMargin> createState() => _DeviderWithMarginState();
}

class _DeviderWithMarginState extends State<DeviderWithMargin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 40),
        Divider(),
        SizedBox(height: 40),
      ],
    );
  }
}
