import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

class ActiveCitySelect extends StatefulWidget {
  const ActiveCitySelect({super.key});

  @override
  _ActiveCitySelectState createState() =>_ActiveCitySelectState();
}

class _ActiveCitySelectState extends State<ActiveCitySelect> {
  String? dropdownValue = 'Select Active city';
  final IndividualProfileController individualProfileController =
  Get.put(IndividualProfileController());

  @override
  void initState() {
    super.initState();
    dropdownValue = individualProfileController.activeCity.value.isNotEmpty
        ? individualProfileController.activeCity.value
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return
      Neumorphic(
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
              'Select Active city',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onChanged: (String? newValue) async{
              String response;
              if(newValue =='Delhi')
             {  response = await individualProfileController.apiService.updateActiveCity(individualProfileController.organization_id.value, newValue.toString());
             if(response == '1'){
               dropdownValue = newValue;
               individualProfileController.activeCity.value = dropdownValue!;
               setState(() {

               });
             }
             else{
             Get.snackbar('Oops!', 'Failed to update Active City');
             }
             }
              else{
                Get.snackbar('Sorry!!!!', 'Coming Soon ');
              }



            },
            items: individualProfileController.activeCities.value
                .map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,style: TextStyle(color: Colors.black ,fontWeight:value.toString() == 'Delhi'?FontWeight.w700:FontWeight.normal )),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
