import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

class QualificationWidget extends StatefulWidget {
  const QualificationWidget({super.key});

  @override
  _QualificationWidgetState createState() => _QualificationWidgetState();
}

class _QualificationWidgetState extends State<QualificationWidget> {
  String? _selectedQualification;
  IndividualProfileController individualProfileController =
      Get.put(IndividualProfileController());
  final List<String> _qualifications = [
    '10th Pass',
    '12th Pass',
    'Diploma',
    'Undergraduate',
    'Postgraduate',
    'PhD',
    'B.Tech',
    'M.Tech',
    'MBA',
    'MBBS',
    'MD',
    'BBA',
    'B.Sc',
    'M.Sc',
    'BA',
    'MA',
    'B.Com',
    'M.Com',
    'LLB',
    'LLM',
    // Add more qualifications if required
  ];

  @override
  void initState() {
    super.initState();
    _selectedQualification = individualProfileController.gender.value.isNotEmpty
        ? individualProfileController.qualification.value
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
      child: Row(children: [
        Expanded(
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: _selectedQualification,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 20,
                elevation: 16,
                style: const TextStyle(
                    color: Colors.black, overflow: TextOverflow.fade),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedQualification = newValue;
                    individualProfileController.qualification.value = newValue!;
                  });
                },
                items: _qualifications
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: const Text(
                  'Select Qualification',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
