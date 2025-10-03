import 'package:flutter/material.dart';
import '../widgets/detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("Go to Detail Home"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DetailPage(title: "Home Detail"),
              ),
            );
          },
        ),
      ),
    );
  }
}
