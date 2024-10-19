class City{
  bool isSelected;
  final String city;
  final String country;
  final bool isDefault;

  City({required this.isSelected, required this.city, required this.country, required this.isDefault});
 //list of  cities
  // List of Cities data
  static List<City> citiesList = [
    City(
        isSelected: false,
        city: 'Lomé',
        country: 'Togo',
        isDefault: false),
    City(
        isSelected: false,
        city: 'London',
        country: 'United Kingdom',
        isDefault: true),
    City(
        isSelected: false,
        city: 'Tokyo',
        country: 'Japan',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Delhi',
        country: 'India',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Beijing',
        country: 'China',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Paris',
        country: 'France',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Rome',
        country: 'Italy',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Lagos',
        country: 'Nigeria',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Amsterdam',
        country: 'Netherlands',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Barcelona',
        country: 'Spain',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Miami',
        country: 'United States',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Vienna',
        country: 'Austria',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Berlin',
        country: 'Germany',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Toronto',
        country: 'Canada',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Brussels',
        country: 'Belgium',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Nairobi',
        country: 'Kenya',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Sydney',
        country: 'Australia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Moscow',
        country: 'Russia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'São Paulo',
        country: 'Brazil',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Cairo',
        country: 'Egypt',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Bangkok',
        country: 'Thailand',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Buenos Aires',
        country: 'Argentina',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Istanbul',
        country: 'Turkey',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Seoul',
        country: 'South Korea',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Mexico City',
        country: 'Mexico',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Jakarta',
        country: 'Indonesia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Algiers',
        country: 'Algeria',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Luanda',
        country: 'Angola',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Porto-Novo',
        country: 'Benin',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Gaborone',
        country: 'Botswana',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Ouagadougou',
        country: 'Burkina Faso',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Bujumbura',
        country: 'Burundi',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Yaoundé',
        country: 'Cameroon',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Praia',
        country: 'Cape Verde',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Bangui',
        country: 'Central African Republic',
        isDefault: false),
    City(
        isSelected: false,
        city: 'N Djamena',
        country: 'Chad',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Moroni',
        country: 'Comoros',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Brazzaville',
        country: 'Congo',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Yamoussoukro',
        country: 'Ivory Coast',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Djibouti',
        country: 'Djibouti',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Cairo',
        country: 'Egypt',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Malabo',
        country: 'Equatorial Guinea',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Asmara',
        country: 'Eritrea',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Addis Ababa',
        country: 'Ethiopia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Libreville',
        country: 'Gabon',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Banjul',
        country: 'Gambia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Accra',
        country: 'Ghana',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Conakry',
        country: 'Guinea',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Bissau',
        country: 'Guinea-Bissau',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Nairobi',
        country: 'Kenya',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Maseru',
        country: 'Lesotho',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Monrovia',
        country: 'Liberia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Tripoli',
        country: 'Libya',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Antananarivo',
        country: 'Madagascar',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Lilongwe',
        country: 'Malawi',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Bamako',
        country: 'Mali',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Nouakchott',
        country: 'Mauritania',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Port Louis',
        country: 'Mauritius',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Rabat',
        country: 'Morocco',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Maputo',
        country: 'Mozambique',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Windhoek',
        country: 'Namibia',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Niamey',
        country: 'Niger',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Abuja',
        country: 'Nigeria',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Kigali',
        country: 'Rwanda',
        isDefault: false),
    City(
        isSelected: false,
        city: 'São Tomé',
        country: 'São Tomé and Príncipe',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Dakar',
        country: 'Senegal',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Victoria',
        country: 'Seychelles',
        isDefault: false),
    City(
        isSelected: false,
        city: 'Freetown',
        country: 'Sierra Leone',
        isDefault: false),

  ];

  static List<City> getSelectedCities(){
    List<City> selectedCities = City.citiesList;
    return selectedCities
        .where((city) => city.isSelected == true)
        .toList();
  }
}
