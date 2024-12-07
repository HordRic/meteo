import 'package:flutter/material.dart'; // Import the Flutter material package

import 'ul/get_started.dart'; // Import the 'get_started.dart' file from the 'ul' directory

void main() {
  runApp(const MyApp()); // Launch the app with MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor for MyApp

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather App', // Application title
      home: GetStarted(), // Initial screen of the app
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}
