import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meteo/ul/widgets/weather_item.dart';

import '../models/city.dart';
import '../models/constants.dart';
import 'detail_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Constants myConstants = Constants();

  // Clé API de géolocalisation (OpenCageData)
  final String geocodingApiKey = '457453f1a44243b2b4f70153bcb017c3';

  // Clé API météo (OpenWeatherMap)
  final String weatherApiKey = 'bad77936d76e7ba47074846a8bd704c2';

  //initiatilization
  int temperature = 0;
  int maxTemp = 0;
  String weatherStateName = 'Loading..';
  int humidity = 0;
  int windSpeed = 0;

  var currentDate = 'Currently';
  String imageUrl = '';
  int woeid =
      44418; //This is the Where on Earth Id for London which is our default city
  String location = 'London'; //Our default city

  //get the cities and selected cities data
  var selectedCities = City.getSelectedCities();
  List<String> cities = [
    'London'
  ]; //the list to hold our selected cities. Deafult is London

  List consolidatedWeatherList = []; //To hold our weather data after api call

  //Api calls url
  String searchLocationUrl = 'https://api.opencagedata'
      '.com/geocode/v1/json?q=';
  String searchWeatherUrl = 'https://api.openweathermap'
      '.org/data/2.5/forecast?';

  void fetchWeatherData(double latitude, double longitude) async {
    try {
      var weatherResult = await http.get(Uri.parse(
          '$searchWeatherUrl&lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=metric'));
      var result = json.decode(weatherResult.body);

      print('Weather API response: $result');

      if (result != null &&
          result['list'] != null &&
          result['list'].isNotEmpty) {
        var listData = result['list'];

        setState(() {
          temperature = listData[0]['main']['temp'].round();
          weatherStateName = listData[0]['weather'][0]['main'] ?? 'Unknown';
          humidity = listData[0]['main']['humidity'].round();
          windSpeed = listData[0]['wind']['speed'].round();
          maxTemp = listData[0]['main']['temp_max'].round();

          imageUrl = (weatherStateName != null && weatherStateName.isNotEmpty)
              ? weatherStateName.replaceAll(" ", "").toLowerCase()
              : 'clouds'; // Utilisez 'default' si weatherStateName est null ou vide

          // Dans la fonction fetchWeatherData
          consolidatedWeatherList = [];
          for (var i = 0; i < listData.length; i++) {
            var item = listData[i];
            var dtTxt = item['dt_txt'];
            if (dtTxt != null && dtTxt is String) {
              var parsedDateTime = DateTime.parse(dtTxt);
              item['applicable_date'] =
                  DateFormat('HH:mm').format(parsedDateTime);
            }
            consolidatedWeatherList.add(item);
          }
        });
      } else {
        print('Données météo non disponibles ou réponse incorrecte');
        // Définir des valeurs par défaut en cas d'erreur
        setState(() {
          weatherStateName = 'Unknown';
          imageUrl = 'cloud'; // Utilisez 'default' ici
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données météo: $e');
      // Définir des valeurs par défaut en cas d'erreur
      setState(() {
        weatherStateName = 'Unknown';
        imageUrl = 'cloud'; // Utilisez 'default' ici
      });
    }
  }

  //Get the Where on earth id
  void fetchLocation(String location) async {
    try {
      var searchResult = await http
          .get(Uri.parse('$searchLocationUrl$location&key=$geocodingApiKey'));
      print(searchResult.body);
      var result = json.decode(searchResult.body);
      print("10");
      if (result['results'] != null && result['results'].isNotEmpty) {
        var latitude = result['results'][0]['geometry']['lat'];
        var longitude = result['results'][0]['geometry']['lng'];
        fetchWeatherData(latitude, longitude);
      } else {
        print('Ville non trouvée');
        // Gérer l'erreur (afficher un message à l'utilisateur, etc.)
      }
    } catch (e) {
      print('Erreur lors de la recherche de la ville: $e');
    }
  }

  @override
  void initState() {
    fetchLocation(cities[0]);

    //For all the selected cities from our City model, extract the city and add it to our original cities list
    for (int i = 0; i < selectedCities.length; i++) {
      cities.add(selectedCities[i].city);
    }
    super.initState();
  }

  //Create a shader linear gradient
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    //Create a size variable for the mdeia query
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Our profile image
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/profile.png',
                  width: 40,
                  height: 40,
                ),
              ),
              //our location dropdown
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    width: 20,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                        value: location,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: cities.map((String location) {
                          return DropdownMenuItem(
                              value: location, child: Text(location));
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            location = newValue!;
                            location = newValue;
                            fetchLocation(location);
                          });
                        }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              Text(
                currentDate,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: size.width,
                height: 200,
                decoration: BoxDecoration(
                    color: myConstants.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: myConstants.primaryColor.withOpacity(.5),
                        offset: const Offset(0, 25),
                        blurRadius: 10,
                        spreadRadius: -12,
                      )
                    ]),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -40,
                      left: 20,
                      child: (imageUrl != null &&
                              imageUrl
                                  .isNotEmpty) // Vérification de null et de vide
                          ? Image.asset(
                              'assets/$imageUrl.png',
                              width: 150,
                            )
                          : const SizedBox(), // Afficher un SizedBox vide si imageUrl est null ou vide
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        weatherStateName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              temperature.toString(),
                              style: TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()..shader = linearGradient,
                              ),
                            ),
                          ),
                          Text(
                            'o',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()..shader = linearGradient,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherItem(
                      text: 'Wind Speed',
                      value: windSpeed,
                      unit: 'km/h',
                      imageUrl: 'assets/windspeed.png',
                    ),
                    weatherItem(
                        text: 'Humidity',
                        value: humidity,
                        unit: '',
                        imageUrl: 'assets/humidity.png'),
                    weatherItem(
                      text: 'Wind Speed',
                      value: maxTemp,
                      unit: 'C',
                      imageUrl: 'assets/max-temp.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Next 40 Hours',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: myConstants.primaryColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 150, // Définir une hauteur fixe pour le ListView
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: consolidatedWeatherList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var applicableDate =
                          consolidatedWeatherList[index]['applicable_date'];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                        consolidatedWeatherList:
                                            consolidatedWeatherList,
                                        selectedId: index,
                                        location: location,
                                      )));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          margin: const EdgeInsets.only(
                              right: 20, bottom: 10, top: 10),
                          width: 75, // Augmenter la largeur
                          height: 150, // Augmenter la hauteur
                          decoration: BoxDecoration(
                              color: false
                                  ? myConstants.primaryColor
                                  : Colors.blue,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 1),
                                  blurRadius: 5,
                                  color: false
                                      ? myConstants.primaryColor
                                      : Colors.black54.withOpacity(.2),
                                ),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                (consolidatedWeatherList[index]['main']
                                            ['temp'] !=
                                        null)
                                    ? consolidatedWeatherList[index]['main']
                                                ['temp']
                                            .round()
                                            .toString() +
                                        "°C"
                                    : 'N/A',
                                style: TextStyle(
                                  fontSize:
                                      20, // Augmenter la taille de la police
                                  color: false
                                      ? Colors.white
                                      : myConstants.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                  height:
                                      10), // Ajouter de l'espace entre les éléments
                              Text(
                                applicableDate,
                                style: TextStyle(
                                  fontSize:
                                      20, // Augmenter la taille de la police
                                  color: false
                                      ? Colors.white
                                      : myConstants.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
