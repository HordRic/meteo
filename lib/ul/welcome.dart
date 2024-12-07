import 'package:flutter/material.dart'; // Import the Flutter material package
import 'package:meteo/models/city.dart'; // Import the 'city.dart' file from the 'models' directory
import 'package:meteo/models/constants.dart'; // Import the 'constants.dart' file from the 'models' directory
import 'package:meteo/ul/home.dart'; // Import the 'home.dart' file from the 'ul' directory

class Welcome extends StatefulWidget {
  const Welcome({super.key}); // Constructor for Welcome

  @override
  State<Welcome> createState() => _WelcomeState(); // Create state for Welcome
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    List<City> cities = City.citiesList
        .where((city) => city.isDefault == false)
        .toList(); // Get the list of non-default cities
    List<City> selectedCities =
        City.getSelectedCities(); // Get the list of selected cities
    Constants myConstant = Constants(); // Create an instance of Constants
    Size size = MediaQuery.of(context).size; // Get the size of the screen

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: myConstant.secondaryColor,
        title: Text('${selectedCities.length} selected'), // Display the number of selected cities
      ),
      body: ListView.builder(
        itemCount: cities.length, // Number of items in the list
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(
                left: 10, top: 20, right: 10), // Set the margin
            padding:
                const EdgeInsets.symmetric(horizontal: 20), // Set the padding
            height: size.height * .08, // Set the height of the container
            width: size.width, // Set the width of the container
            decoration: BoxDecoration(
                border: cities[index].isSelected == true
                    ? Border.all(
                        color: myConstant.secondaryColor.withOpacity(.6),
                        width: 2,
                      )
                    : Border.all(
                        color: Colors.white), // Conditional border color
                borderRadius: const BorderRadius.all(
                    Radius.circular(10)), // Round the corners
                boxShadow: [
                  BoxShadow(
                    color: myConstant.primaryColor.withOpacity(.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // Set the shadow
                  )
                ]),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cities[index].isSelected =
                          !cities[index].isSelected; // Toggle selection
                    });
                  },
                  child: Image.asset(
                    cities[index].isSelected == true
                        ? 'assets/checked.png'
                        : 'assets/unchecked.png',
                    width: 30,
                  ), // Display checked or unchecked image
                ),
                const SizedBox(
                  width: 10,
                ), // Add a horizontal space
                Text(
                  cities[index].city,
                  style: TextStyle(
                    fontSize: 16,
                    color: cities[index].isSelected == true
                        ? myConstant.primaryColor
                        : Colors.black54,
                  ), // Conditional text color
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myConstant.secondaryColor,
        child: const Icon(Icons.pin_drop),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const Home())); // Navigate to the Home screen
        },
      ),
    );
  }
}
