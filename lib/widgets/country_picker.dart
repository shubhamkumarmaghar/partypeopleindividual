import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CountryWidget extends StatefulWidget {
  @override
  _CountryWidgetState createState() => _CountryWidgetState();
}

class _CountryWidgetState extends State<CountryWidget> {
  String? _selectedCountry;
  final List<String> _countries = [
    'India',
    'United States',
    'Canada',
    'Australia',
    'United Kingdom',
    // Add more countries if required
  ];

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: const EdgeInsets.all(12.0),
      style: NeumorphicStyle(
        intensity: 0.8,
        surfaceIntensity: 0.25,
        depth: 8,
        shape: NeumorphicShape.flat,
        lightSource: LightSource.topLeft,
        color: Colors.grey.shade100,
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: _selectedCountry,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 20,
            elevation: 16,
            hint: Text(
              'Select Country',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            style: TextStyle(color: Colors.black, fontSize: 14),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCountry = newValue;
              });
            },
            items: _countries.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
