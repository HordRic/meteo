import 'package:flutter/material.dart'; // Import the Flutter material package
import 'package:meteo/models/constants.dart'; // Import the 'constants.dart' file from the 'models' directory

import 'welcome.dart'; // Import the 'welcome.dart' file

class GetStarted extends StatelessWidget {
  const GetStarted({super.key}); // Constructor for GetStarted

  @override
  Widget build(BuildContext context) {
    Constants myConstants = Constants(); // Create an instance of Constants
    Size size = MediaQuery.of(context).size; // Get the size of the screen

    return Scaffold(
        body: Container(
      width: size.width, // Set the width of the container to the screen width
      height:
          size.height, // Set the height of the container to the screen height
      color: myConstants.primaryColor
          .withOpacity(.5), // Set the background color with opacity
      child: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the children vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center the children horizontally
          children: [
            Image.asset(
                'assets/get-started.png'), // Display the 'get-started' image
            const SizedBox(
              height: 30,
            ), // Add a vertical space
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Welcome())); // Navigate to the Welcome screen
              },
              child: Container(
                height: 50, // Set the height of the button
                width: size.width * 0.7, // Set the width of the button
                decoration: BoxDecoration(
                  color: myConstants
                      .primaryColor, // Set the background color of the button
                  borderRadius: const BorderRadius.all(
                      Radius.circular(10)), // Round the corners
                ),
                child: const Center(
                  child: Text(
                    'Get started',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ), // Display 'Get started' text
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
