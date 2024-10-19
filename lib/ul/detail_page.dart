import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meteo/ul/welcome.dart';
import 'package:meteo/ul/widgets/weather_item.dart';

import '../models/constants.dart';

class DetailPage extends StatefulWidget {
  final List consolidatedWeatherList;
  final int selectedId;
  final String location;

  const DetailPage(
      {Key? key,
      required this.consolidatedWeatherList,
      required this.selectedId,
      required this.location})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String imageUrl = '';
  List hourlyWeatherList = [];
  @override
  void initState() {
    super.initState();
    // Extraire les données horaires de consolidatedWeatherList
    hourlyWeatherList = widget.consolidatedWeatherList.map((item) {
      return {
        'temp': item['main']['temp'],
        'time': item['applicable_date'], // Utiliser applicable_date directement
        'weather_state_name': item['weather'][0]['main'],
      };
    }).toList();
    hourlyWeatherList = hourlyWeatherList.where((hourlyWeather) {
      // Filtrer les éléments avec des données manquantes
      return hourlyWeather['temp'] != null &&
          hourlyWeather['weather_state_name'] != null &&
          hourlyWeather['time'] != null;
    }).toList();

    print(
        'Hourly Weather List: $hourlyWeatherList'); // Afficher la liste pour déboguer
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    //Create a shader linear gradient
    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    int selectedIndex = 0; // Par défaut, sélectionner le premier élément
    // Trouver l'index de l'heure actuelle (à adapter à votre format d'heure)
    final now = DateTime.now();
    final currentHour = DateFormat('HH:mm').format(now);
    selectedIndex = hourlyWeatherList
        .indexWhere((hourlyWeather) => hourlyWeather['time'] == currentHour);
    if (selectedIndex == -1) {
      selectedIndex =
          0; // Si l'heure actuelle n'est pas trouvée, sélectionner le premier élément
    }
    var selectedWeatherData = widget.consolidatedWeatherList[selectedIndex];

    var weatherStateName = selectedWeatherData['weather_state_name'] ?? '';
    imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();
    if (widget.consolidatedWeatherList.isEmpty || hourlyWeatherList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Détails')),
        body: const Center(child: Text('Aucune donnée disponible.')),
      );
    }

    return Scaffold(
      backgroundColor: myConstants.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: myConstants.secondaryColor,
        elevation: 0.0,
        title: Text(widget.location),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Welcome()));
                },
                icon: const Icon(Icons.settings)),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: SizedBox(
              height: 150,
              width: 400,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: hourlyWeatherList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var hourlyWeather = hourlyWeatherList[index];
                    var weatherIcon = hourlyWeather['weather_state_name']
                        ?.replaceAll(' ', '')
                        .toLowerCase();
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      margin: const EdgeInsets.only(right: 20),
                      width: 80,
                      decoration: BoxDecoration(
                          color: index == selectedIndex
                              ? Colors.white
                              : const Color(0xff9ebcf9),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 1),
                              blurRadius: 5,
                              color: Colors.blue.withOpacity(.3),
                            )
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            hourlyWeather['temp']?.round().toString() ??
                                hourlyWeather['time'],
                            style: TextStyle(
                              fontSize: 17,
                              color: index == selectedIndex
                                  ? Colors.blue
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset(
                            'assets/${weatherIcon ?? 'clouds'}.png',
                            width: 40,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  'Error loading image: $error'); // Afficher l'erreur dans la console
                              return const Icon(
                                  Icons.error); // Afficher une icône d'erreur
                            },
                          ),
                          Text(
                            hourlyWeather['time'],
                            style: TextStyle(
                              fontSize: 17,
                              color: index == selectedIndex
                                  ? Colors.blue
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: size.height * .55,
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  )),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -50,
                    right: 20,
                    left: 20,
                    child: Container(
                      width: size.width * .7,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.center,
                              colors: [
                                Color(0xffa9c1f5),
                                Color(0xff6696f5),
                              ]),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(.1),
                              offset: const Offset(0, 25),
                              blurRadius: 3,
                              spreadRadius: -10,
                            ),
                          ]),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            top: -40,
                            left: 20,
                            child: Image.asset(
                              'assets/${imageUrl.isNotEmpty ? imageUrl : 'clouds'}.png', //
                              width: 150,
                            ),
                          ),
                          Positioned(
                              top: 120,
                              left: 30,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  weatherStateName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              )),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Container(
                              width: size.width * .8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  weatherItem(
                                    text: 'Wind Speed',
                                    value: widget.consolidatedWeatherList[
                                                selectedIndex]['wind_speed']
                                            ?.round() ??
                                        0,
                                    unit: 'km/h',
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  weatherItem(
                                      text: 'Humidity',
                                      value: widget.consolidatedWeatherList[
                                                  selectedIndex]['humidity']
                                              ?.round() ??
                                          0,
                                      unit: '',
                                      imageUrl: 'assets/humidity.png'),
                                  weatherItem(
                                    text: 'Max Temp',
                                    value: widget.consolidatedWeatherList[
                                                selectedIndex]['max_temp']
                                            ?.round() ??
                                        0,
                                    unit: 'C',
                                    imageUrl: 'assets/max-temp.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.consolidatedWeatherList[selectedIndex]
                                              ['the_temp']
                                          ?.round()
                                          .toString() ??
                                      'N/A',
                                  style: TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                ),
                                Text(
                                  'o',
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = linearGradient,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 300,
                      left: 20,
                      child: SizedBox(
                        height: 200,
                        width: size.width * .9,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: widget.consolidatedWeatherList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var futureWeatherName =
                                  widget.consolidatedWeatherList[index]
                                      ['weather_state_name'];
                              var futureImageURL = futureWeatherName != null
                                  ? futureWeatherName
                                      .replaceAll(' ', '')
                                      .toLowerCase()
                                  : 'clouds'; // Image par défaut si futureWeatherName est nul
                              Text(
                                widget.consolidatedWeatherList[index]
                                    ['applicable_date'], // Afficher l'heure
                                style: const TextStyle(
                                  color: Color(0xff6696f5),
                                ),
                              );
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 10, top: 10, right: 10, bottom: 5),
                                height: 80,
                                width: size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: myConstants.secondaryColor
                                            .withOpacity(.1),
                                        spreadRadius: 5,
                                        blurRadius: 20,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.consolidatedWeatherList[index]
                                                ['applicable_date'] ??
                                            'N/A', // Afficher 'N/A' si la valeur est null
                                        style: const TextStyle(
                                          color: Color(0xff6696f5),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            widget.consolidatedWeatherList[
                                                        index]['max_temp']
                                                    ?.round()
                                                    .toString() ??
                                                'N/A',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const Text(
                                            '/',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 30,
                                            ),
                                          ),
                                          Text(
                                            widget.consolidatedWeatherList[
                                                        index]['min_temp']
                                                    ?.round()
                                                    .toString() ??
                                                'N/A',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/${futureImageURL ?? 'clouds'}.png',
                                            width: 30,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              print(
                                                  'Error loading image: $error'); // Afficher l'erreur dans la console
                                              return const Icon(Icons
                                                  .error); // Afficher une icône d'erreur
                                            },
                                          ),
                                          Text(widget.consolidatedWeatherList[
                                              index]['weather_state_name']),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
