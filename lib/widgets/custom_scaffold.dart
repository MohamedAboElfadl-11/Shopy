import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        //backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Image.asset(
          //   'images/image-not-found.jpg',
          //   fit: BoxFit.fill,
          //   width: double.infinity,
          //   height: MediaQuery.of(context).size.height * 0.2,
          // ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}
