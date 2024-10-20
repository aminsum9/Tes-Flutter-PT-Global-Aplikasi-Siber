import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
          height: screenHeight,
          color: const Color.fromRGBO(1, 1, 1, 0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          )),
    );
  }
}
