import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../individual_profile/controller/individual_profile_controller.dart';
import 'custom_textfield.dart';
import 'status_model.dart' as StatusModel;

class SelectState extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onCityChanged;
  final TextStyle? style;
  final Color? dropdownColor;

  const SelectState(
      {Key? key,
      required this.onCountryChanged,
      required this.onStateChanged,
      required this.onCityChanged,
      this.style,
      this.dropdownColor})
      : super(key: key);

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  final TextEditingController countryEditingController = TextEditingController();
  final TextEditingController stateEditingController = TextEditingController();
  final TextEditingController cityEditingController = TextEditingController();
  IndividualProfileController individualProfileController =
      Get.put(IndividualProfileController());
  List<String> _cities = ["Choose City"];
  List<String> _country = ["Choose Country"];
  String _selectedCity = "Choose City";
  String _selectedCountry = "Choose Country";
  String _selectedState = "Choose State";
  List<String> _states = ["Choose State"];
  var responses;

  @override
  void initState() {
    getCounty();
    _selectedCountry =
        _country.contains(individualProfileController.country.value)
            ? individualProfileController.country.value
            : "Choose Country";
    _selectedState = _states.contains(individualProfileController.state.value)
        ? individualProfileController.state.value
        : "Choose State";
    _selectedCity = _cities.contains(individualProfileController.city.value)
        ? individualProfileController.city.value
        : "Choose City";
    super.initState();
  }

  Future getResponse() async {
    var res = await rootBundle.loadString('assets/country.json');
    return jsonDecode(res);
  }

  Future getCounty() async {
    var countryres = await getResponse() as List;
    countryres.forEach((data) {
      var model = StatusModel.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      if (!mounted) return;
      setState(() {
        if (!_country.contains(model.name!)) {
          _country.add(model.name!);
        }
      });
    });

    if (mounted) {
      setState(() {
        _selectedCountry =
            _country.contains(individualProfileController.country.value)
                ? individualProfileController.country.value
                : "Choose Country";
      });
    }

    if (_selectedCountry != "Choose Country") {
      await getState();
    }

    return _country;
  }

  Future getState() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      if (!mounted) return;
      setState(() {
        var name = f.map((item) => item.name).toList();
        for (var statename in name) {
          print(statename.toString());
          if (!_states.contains(statename)) {
            _states.add(statename.toString());
          }
        }
      });
    });

    if (mounted) {
      setState(() {
        _selectedState =
            _states.contains(individualProfileController.state.value)
                ? individualProfileController.state.value
                : "Choose State";
      });
    }

    if (_selectedState != "Choose State") {
      await getCity();
    }

    return _states;
  }

  Future getCity() async {
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.name == _selectedCountry)
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      var name = f.where((item) => item.name == _selectedState);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          for (var citynames in citiesname) {
            print(citynames.toString());
            if (!_cities.contains(citynames)) {
              _cities.add(citynames.toString());
            }
          }
        });
      });
    });

    if (mounted) {
      setState(() {
        _selectedCity = _cities.contains(individualProfileController.city.value)
            ? individualProfileController.city.value
            : "Choose City";
      });
    }

    return _cities;
  }

  void _onSelectedCountry(String value) {
    if (!mounted) return;
    setState(() {
      _selectedState = "Choose State";
      _states = ["Choose State"];
      _selectedCountry = value;
      individualProfileController.country.value = value;
      this.widget.onCountryChanged(value);
      getState();
    });
  }

  void _onSelectedState(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = "Choose City";
      _cities = ["Choose City"];
      _selectedState = value;
      individualProfileController.state.value = value;

      this.widget.onStateChanged(value);
      getCity();
    });
  }

  void _onSelectedCity(String value) {
    if (!mounted) return;
    setState(() {
      _selectedCity = value;
      this.widget.onCityChanged(value);
      individualProfileController.city.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Expanded(
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
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            value: _selectedCountry,
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
                            hint: const Text('Select Country',
                                style: TextStyle(color: Colors.grey)),
                            items: _country.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(
                                  dropDownStringItem,
                                  style: TextStyle(
                                      color:
                                          dropDownStringItem == 'Choose Country'
                                              ? Colors.grey
                                              : Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) => _onSelectedCountry(value!),
                            dropdownSearchData: DropdownSearchData(
                              searchController: countryEditingController,
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
                                  controller: countryEditingController,
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
                                return item.value.toString().contains(searchValue);
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                countryEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
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
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            value: _selectedState,
                           // icon: const Icon(Icons.arrow_drop_down),
                            //iconSize: 20,
                            buttonStyleData:  ButtonStyleData(
                              padding: EdgeInsets.only(left: 16,right: 5),
                              height: Get.height*0.055,
                              width: Get.width*0.04,
                            ),
                            dropdownStyleData:  DropdownStyleData(
                              maxHeight: Get.height*0.5,
                            ),
                            hint: const Text('Select State',
                                style: TextStyle(color: Colors.grey)),
                            items: _states.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(
                                  dropDownStringItem,
                                  style: TextStyle(
                                      color:
                                          dropDownStringItem == 'Choose State'
                                              ? Colors.grey
                                              : Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) => _onSelectedState(value!),
                            dropdownSearchData: DropdownSearchData(
                              searchController: stateEditingController,
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
                                  controller: stateEditingController,
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
                                return item.value.toString().contains(searchValue);
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                stateEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
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
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            value: _selectedCity,
                          //  icon: const Icon(Icons.arrow_drop_down),
                            //iconSize: 20,
                            buttonStyleData:  ButtonStyleData(
                              padding: EdgeInsets.only(left: 16,right: 5),
                              height: Get.height*0.055,
                              width: Get.width*0.04,
                            ),
                            dropdownStyleData:  DropdownStyleData(
                              maxHeight: Get.height*0.5,
                            ),
                            hint: const Text('Select City',
                                style: TextStyle(color: Colors.grey)),
                            items: _cities.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(
                                  dropDownStringItem,
                                  style: TextStyle(
                                      color: dropDownStringItem == 'Choose City'
                                          ? Colors.grey
                                          : Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) => _onSelectedCity(value!),
                            dropdownSearchData: DropdownSearchData(
                              searchController: cityEditingController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(style: TextStyle(color: Colors.black),
                                  expands: true,
                                  maxLines: null,
                                  controller: cityEditingController,
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
                                return item.value.toString().contains(searchValue);
                              },
                            ),
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                cityEditingController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomTextField(
                validate: true,
                hintText: 'PIN Code',
                obscureText: false,
                maxLength: 6,
                initialValue: individualProfileController.pincode.value,
                icon: Icons.location_on,
                textInput: TextInputType.number,
                onChanged: (value) {
                  individualProfileController.pincode.value = value;
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
