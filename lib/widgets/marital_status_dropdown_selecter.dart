import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

class MatrialStatus extends StatefulWidget {
  const MatrialStatus({super.key});

  @override
  _MatrialStatusState createState() => _MatrialStatusState();
}

class _MatrialStatusState extends State<MatrialStatus> {
  String? dropdownValue;
  final IndividualProfileController individualProfileController =
      Get.put(IndividualProfileController());

  @override
  void initState() {
    super.initState();
    dropdownValue = individualProfileController.maritalStatus.value.isNotEmpty
        ? individualProfileController.maritalStatus.value
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 20,
            elevation: 16,
            style: const TextStyle(
              color: Colors.black,
            ),
            hint: const Text(
              'Select Marital Status',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
                individualProfileController.maritalStatus.value = dropdownValue!;
              });
            },
            items: <String>['Single', 'Married', 'Divorced','Others']
                .map<DropdownMenuItem<String>>((String value) {
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
