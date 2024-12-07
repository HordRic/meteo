import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:meteo/ul/welcome.dart';
import 'package:meteo/ul/widgets/weather_item.dart';

import '../models/constants.dart';

Future<List> fetchHourlyWeatherData(double latitude, double longitude) async {
  const String weatherApiKey = 'bad77936d76e7ba47074846a8bd704c2';

  final apiUrl =
      'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$weatherApiKey&units=metric';

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('API Response: $data'); // Log de la réponse de l'API
      return data['list'];
    } else {
      print('Erreur: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception('Erreur lors de la récupération des données météo');
    }
  } catch (e) {
    print('Erreur: $e');
    return [];
  }
}

class DetailPage extends StatefulWidget {
  final List consolidatedWeatherList;
  final int selectedId;
  final String location;

  const DetailPage(
      {super.key,
      required this.consolidatedWeatherList,
      required this.selectedId,
      required this.location});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List hourlyWeatherData = [];
  String imageUrl = '';
  List hourlyWeatherList = [];
  String weatherStateName = ''; // Définir la variable ici

  @override
  void initState() {
    super.initState();
    hourlyWeatherList = widget.consolidatedWeatherList;
    print('Hourly Weather List: $hourlyWeatherList');

    if (widget.selectedId < 0 || widget.selectedId >= widget.consolidatedWeatherList.length) {
      print('selectedId invalide: ${widget.selectedId}');
      Navigator.pop(context);
      return;
    }

    final selectedLocation = widget.consolidatedWeatherList[widget.selectedId];
    final latitude = selectedLocation?['coord']?['lat'] ?? 0.0;
    final longitude = selectedLocation?['coord']?['lon'] ?? 0.0;

    fetchHourlyWeatherData(latitude, longitude).then((data) {
      setState(() {
        hourlyWeatherData = data;
        print('Hourly Weather Data: $hourlyWeatherData'); // Log des données horaires
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Constants myConstants = Constants();

    final Shader linearGradient = const LinearGradient(
      colors: <Color>[Color(0xffABCFF2), Color(0xff9AC6F3)],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    int selectedIndex = 0;

    if (hourlyWeatherData.isNotEmpty) {
      final now = DateTime.now();
      final currentHour = DateFormat('yyyy-MM-dd HH:00:00').format(now);
      for (int i = 0; i < hourlyWeatherData.length; i++) {
        if (hourlyWeatherData[i]['dt_txt'] == currentHour) {
          selectedIndex = i;
          break;
        }
      }

      if (selectedIndex >= hourlyWeatherData.length) {
        selectedIndex = hourlyWeatherData.length - 1;
      }

      weatherStateName = hourlyWeatherData[selectedIndex]['weather'][0]['main'] ?? '';
      imageUrl = weatherStateName.replaceAll(' ', '').toLowerCase();
    } else {
      print("L'heure actuelle n'a pas été trouvée dans les données horaires.");
    }

    if (widget.consolidatedWeatherList.isEmpty || hourlyWeatherData.isEmpty) {
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
                  itemCount: hourlyWeatherData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var hourlyWeather = hourlyWeatherData[index];
                    var weatherIcon = hourlyWeather['weather']?[0]?['main']
                            ?.replaceAll(' ', '')
                            .toLowerCase() ??
                        'clouds';
                    String formattedTime =
                        'N/A';
                    if (hourlyWeather['dt_txt'] != null) {
                      try {
                        formattedTime = DateFormat('HH:mm')
                            .format(DateTime.parse(hourlyWeather['dt_txt']));
                      } catch (e) {
                        print('Erreur lors du formatage de l\'heure: $e');
                      }
                    }
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
                            hourlyWeather['main']['temp']?.round().toString() ??
                                'N/A',
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
                                  'Error loading image: $error');
                              return const Icon(
                                  Icons.error);
                            },
                          ),
                          Text(
                            formattedTime,
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
                              'assets/${imageUrl.isNotEmpty ? imageUrl : 'clouds'}.png',
                              width: 150,
                            ),
                          ),
                          Positioned(
                              top: 120,
                              left: 30,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  weatherStateName, // Utilisation de la variable définie
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
                                    value: hourlyWeatherList[selectedIndex]
                                                ['wind']['speed']
                                            ?.round() ??
                                        0,
                                    unit: 'km/h',
                                    imageUrl: 'assets/windspeed.png',
                                  ),
                                  weatherItem(
                                      text: 'Humidity',
                                      value: hourlyWeatherList[selectedIndex]
                                                  ['main']['humidity']
                                              ?.round() ??
                                          0,
                                      unit: '',
                                      imageUrl: 'assets/humidity.png'),
                                  weatherItem(
                                    text: 'Max Temp',
                                    value: hourlyWeatherList[selectedIndex]
                                                ['main']['temp_max']
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
                                  hourlyWeatherList[selectedIndex]['main']['temp']
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
                              var weatherData =
                                  widget.consolidatedWeatherList[index];
                              final weatherIcon = (weatherData['weather'] !=
                                          null &&
                                      weatherData['weather'].isNotEmpty &&
                                      weatherData['weather'][0]['main'] != null)
                                  ? weatherData['weather'][0]['main']
                                      ?.replaceAll(' ', '')
                                      .toLowerCase()
                                  : 'clouds';
                              final temperature =
                                  (weatherData['main'] != null &&
                                          weatherData['main']['temp'] != null)
                                      ? weatherData['main']['temp']
                                          .round()
                                          .toString()
                                      : 'N/A';
                              if (hourlyWeatherData.isNotEmpty) {
                                Text(
                                  hourlyWeatherData[index]['dt_txt'] ??
                                      'N/A',
                                  style: const TextStyle(
                                    color: Color(0xff6696f5),
                                  ),
                                );
                              } else {
                                const CircularProgressIndicator();
                              }
                              final futureImageURL = weatherData['weather']?[0]
                                          ?['main']
                                      ?.replaceAll(' ', '')
                                      .toLowerCase() ??
                                  'clouds';
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
                                        hourlyWeatherData[index]
                                                ['dt_txt'] ??
                                            'N/A',
                                        style: const TextStyle(
                                          color: Color(0xff6696f5),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            hourlyWeatherData[index]['main']['temp_max']
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
                                            hourlyWeatherData[index]['main']['temp_min']
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
                                            'assets/${weatherData['weather'] != null && weatherData['weather'].isNotEmpty && weatherData['weather'][0]['main'] != null ? weatherData['weather'][0]['main']?.replaceAll(' ', '').toLowerCase() : 'clouds'}.png',
                                            width: 30,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              print(
                                                  'Error loading image: $error');
                                              return const Icon(Icons.error);
                                            },
                                          ),
                                          Text(hourlyWeatherData[index]
                                                  ['weather'][0]['main'] ??
                                              'N/A')
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