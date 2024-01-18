import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:partypeopleindividual/centralize_api.dart';
class PartyPreviewScreenController extends GetxController{


  Future<void> getSingledata({required String partyID})async {
    String url = API.getSinglePartyData+"?pid+$partyID";
    final response = await http.get(
        Uri.parse(url),
        headers:{'x-access-token': GetStorage().read('token')
        });

  }
}