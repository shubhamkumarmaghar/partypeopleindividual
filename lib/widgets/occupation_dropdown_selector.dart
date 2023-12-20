import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

class OccupationWidget extends StatefulWidget {
  const OccupationWidget({super.key});

  @override
  _OccupationWidgetState createState() => _OccupationWidgetState();
}

class _OccupationWidgetState extends State<OccupationWidget> {
  final TextEditingController textEditingController = TextEditingController();
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
    '',
    // Add more occupations if required
  ];

  String? _selectedOccupation;

  @override
  void initState() {
    super.initState();
    _selectedOccupation = individualProfileController.occupation.value.isNotEmpty
        ? individualProfileController.occupation.value
        : "";
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
                child: DropdownButton2<String>(
                  value: _selectedOccupation,
                  //icon: const Icon(Icons.arrow_drop_down),
                 // iconSize: 20,
                  buttonStyleData:  ButtonStyleData(
                    padding: EdgeInsets.only(left: 16,right: 5),
                    height: Get.height*0.055,
                    width: Get.width*0.04,
                  ),
                  dropdownStyleData:  DropdownStyleData(
                    maxHeight: Get.height*0.5,
                  ),
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
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchInnerWidgetHeight: 50,
                    searchInnerWidget: Container(
                      height: 50,
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        expands: true,
                        maxLines: null,
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for an item...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value.toString().toLowerCase().contains('${searchValue.toString().toLowerCase()}');
                    },
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
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
