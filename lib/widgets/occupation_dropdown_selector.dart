import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

class OccupationWidget extends StatefulWidget {
  const OccupationWidget({super.key});

  @override
  _OccupationWidgetState createState() => _OccupationWidgetState();
}

class _OccupationWidgetState extends State<OccupationWidget> {
  IndividualProfileController individualProfileController =
      Get.put(IndividualProfileController());

  final List<String> _occupations = [
    'Student',
    'Engineer',
    'Doctor',
    'Lawyer',
    'Teacher',
    'Entrepreneur',
    'Software Developer',
    'Designer',
    'Marketer',
    'Salesperson',
    'Researcher',
    'Writer',
    'Chef',
    'Musician',
    'Artist',
    'Other',
    // Add more occupations if required
  ];

  String? _selectedOccupation;

  @override
  void initState() {
    super.initState();
    _selectedOccupation = individualProfileController.gender.value.isNotEmpty
        ? individualProfileController.occupation.value
        : null;
  }

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
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _selectedOccupation,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 20,
                  hint: const Text(
                    'Select Occupation',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOccupation = newValue;
                      individualProfileController.occupation.value = newValue!;
                    });
                  },
                  items: _occupations
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
