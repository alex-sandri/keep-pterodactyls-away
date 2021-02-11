import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Info"),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Image Credit",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text("Darius Dan from www.flaticon.com"),
            ],
          ),
        ),
      ),
    );
  }
}
