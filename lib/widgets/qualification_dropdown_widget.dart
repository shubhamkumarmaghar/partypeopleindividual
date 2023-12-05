
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

class QualificationWidget extends StatefulWidget {
  const QualificationWidget({super.key});

  @override
  _QualificationWidgetState createState() => _QualificationWidgetState();
}

class _QualificationWidgetState extends State<QualificationWidget> {
  String? _selectedQualification;
  final TextEditingController textEditingController = TextEditingController();
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
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Neumorphic(
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
                child: DropdownButton2<String>(
                  value: _selectedQualification,

                //  icon: const Icon(Icons.arrow_drop_down),
                //  iconSize: 20,
                //  elevation: 16,
                  buttonStyleData:  ButtonStyleData(
                    padding: EdgeInsets.only(left: 16,right: 5),
                    height: Get.height*0.055,
                    width: Get.width*0.04,
                  ),
                  dropdownStyleData:  DropdownStyleData(
                    maxHeight: Get.height*0.5,
                  ),
                  style: const TextStyle(
                      color: Colors.black, overflow: TextOverflow.fade),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedQualification = newValue;
                      individualProfileController.qualification.value = newValue!;
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
                        expands: true,
                        maxLines: null,
                        style: TextStyle(color: Colors.black),
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
      ),
    );
  }
}
