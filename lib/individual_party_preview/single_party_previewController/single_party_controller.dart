import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/centralize_api.dart';
import '../../individualDashboard/models/party_model.dart';
import '../../widgets/individual_amenities.dart';
class PartyPreviewScreenController extends GetxController{
  Party? party;
  String? partyId;
  RxBool isLoading = false.obs;
  final List partyImages = [];
  List<Category> categories = [];
  final List<CategoryList> categoryLists = [];
  List selectedAmenities = [];
  @override
  void onInit(){
    getdata();
  //  partyId = Get.arguments ?? '0';
   // getSingledata(partyID: '$partyId');
    super.onInit();
   }

  void getdata()async{
      partyId = await Get.arguments ?? '0';

    await getSingledata(partyID: '$partyId');
      getpartyImages();
      _fetchData();
   }

  Future<void> _fetchData() async {
    http.Response response = await http.get(
      Uri.parse(API.partyAmenities),
      headers: {'x-access-token': '${GetStorage().read('token')}'},
    );
    final data = jsonDecode(response.body);
      if (data['status'] == 1) {
        categories = (data['data'] as List)
            .map((category) => Category.fromJson(category))
            .toList();

        categories.forEach((category) {
          categoryLists.add(CategoryList(
              title: category.name, amenities: category.amenities));
        });
        getSelectedID();
      }
      update();

  }

  void getSelectedID() {
    int? lenght = party?.partyAmenities.length;
    for (var i = 0; i < lenght!; i++) {
      var amenityName = party?.partyAmenities[i].name;
      print("amenity name" + amenityName!);
        categories.forEach((category) {
          category.amenities.forEach((amenity) {
            if (amenity.name == amenityName) {
              if (selectedAmenities.contains(amenity.id)) {
              } else {
                selectedAmenities.add(amenity.id);
              }
              amenity.selected = true;
            }
          });
        });

    }
  }

  void getpartyImages() {
    partyImages.add(party?.coverPhoto);
    if (party?.imageB != null) {
      partyImages.add(party?.imageB);
    }
    if (party?.imageC != null) {
      partyImages.add(party?.imageC);
    }
    partyImages.forEach((element) {
      print(element.toString());
    });
  }


  Future<void> getSingledata({required String partyID})async {

    String url = API.getSinglePartyData+"?pid=$partyID";
    log("url $url");
    isLoading.value = true;
    try {
      final response = await http.get(
          Uri.parse(url),
          headers: {'x-access-token': GetStorage().read('token')
          });
      dynamic decodedData = jsonDecode(response.body);

      print("single party data $decodedData");
      if(decodedData['status']==1 && decodedData['message']=='Party Data Found.' ){
      party = Party.fromJson(decodedData['data'][0]);
      isLoading.value=false;
      update();
      }
      else{
        print('no data found');
        Fluttertoast.showToast(msg: 'No party Found');
      }
    }catch(e){
      print("error $e");
    }
  }
}

class Amenities {
  final String id;
  final String name;

  Amenities({required this.id, required this.name});
}
