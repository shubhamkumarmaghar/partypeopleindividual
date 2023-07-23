import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../individualDashboard/models/party_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/individual_amenities.dart';

class Amenity {
  final String id;
  final String name;

  Amenity({required this.id, required this.name});
}

class PartyPreview extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final Party party;

  const PartyPreview({super.key, required this.party});

  @override
  State<PartyPreview> createState() => _PartyPreviewState();
}

class _PartyPreviewState extends State<PartyPreview> {
  List<Category> _categories = [];
  final List<CategoryList> _categoryLists = [];

  Future<void> _fetchData() async {
    http.Response response = await http.get(
      Uri.parse('http://app.partypeople.in/v1/party/party_amenities'),
      headers: {'x-access-token': '${GetStorage().read('token')}'},
    );
    final data = jsonDecode(response.body);
    setState(() {
      if (data['status'] == 1) {
        _categories = (data['data'] as List)
            .map((category) => Category.fromJson(category))
            .toList();

        _categories.forEach((category) {
          _categoryLists.add(CategoryList(
              title: category.name, amenities: category.amenities));

        });

      }
    });
  }


  Future<void> ongoingParty(String id) async {
    final response = await http.post(
      Uri.parse('http://app.partypeople.in/v1/party/party_ongoing'),
      headers: <String, String>{
        'x-access-token': '${GetStorage().read('token')}',
      },
      body: <String, String>{
        'party_id': id,
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == 1) {
        print('Party ongoing save successfully');
        Get.snackbar('Welcome',
            'You are welcome to join party');
      }
      else {
        print('Failed to update ongoing Party data');
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update Party onging data');
    }
  }


  @override
  void initState() {
    _fetchData();
    print(widget.party.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 65,
            ),
            widget.party.imageStatus == '1'
                ? Container(
                    padding: EdgeInsets.zero,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: Get.width,
                    child: Image.network(
                      widget.party.coverPhoto,
                      width: Get.width,
                      height: 160,
                      fit: BoxFit.fill,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    padding: EdgeInsets.zero,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: Get.width,
                    child: Image.network(
                      widget.party.coverPhoto,
                      width: Get.width,
                      height: 160,
                      fit: BoxFit.fill,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      },
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                widget.party.title.capitalizeFirst!,
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontFamily: 'malgun',
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                widget.party.description.capitalizeFirst!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontFamily: 'malgun',
                  fontSize: 12.sp,
                  color: const Color(0xff7D7373),
                ),
              ),
            ),
            const Divider(),
            widget.party.papularStatus == '1'
                ? CustomListTile(
                    icon: Icons.calendar_month,
                    title: "Popular Party Dates",
                    subtitle:
                        "${DateFormat('EEEE, d MMMM y').format(DateTime.parse(widget.party.prStartDate))} to ${widget.party.endDate != null ? DateFormat('EEEE, d MMMM y').format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.party.endDate) * 1000)) : ''}",
                  )
                : Container(),
            CustomListTile(
              icon: Icons.calendar_month,
              title: "Party Start & End Dates",
              subtitle:
                  "${widget.party.prStartDate != null ? DateFormat('EEEE, d MMMM y').format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.party.startDate) * 1000)) : ''} to ${widget.party.endDate != null ? DateFormat('EEEE, d MMMM y').format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.party.endDate) * 1000)) : ''}",
            ),
            CustomListTile(
              icon: Icons.favorite,
              title: "Party Likes",
              subtitle: "${widget.party.like} Likes",
            ),
            CustomListTile(
              icon: Icons.remove_red_eye_sharp,
              title: "Party Views",
              subtitle: "${widget.party.view} Views",
            ),
            CustomListTile(
              icon: Icons.group_add,
              title: "Party Goings",
              subtitle: "${widget.party.ongoing} Goings",
            ),
            CustomListTile(
              icon: Icons.supervised_user_circle_outlined,
              title: "Gender Allowed",
              subtitle: widget.party.gender
                  .replaceAll('[', '')
                  .replaceAll(']', '')
                  .capitalizeFirst!,
            ),
            CustomListTile(
              icon: Icons.phone,
              title: "Party Contact Number",
              subtitle: widget.party.phoneNumber,
            ),
            CustomListTile(
              icon: Icons.group,
              title: "Age Allowed Between",
              subtitle: "${widget.party.startAge} - ${widget.party.endAge} ",
            ),
            CustomListTile(
              icon: Icons.warning,
              title: "Persons Limit",
              subtitle: widget.party.personLimit,
            ),
            CustomListTile(
              icon: Icons.local_offer,
              title: "Offers",
              subtitle: widget.party.offers,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade900,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Entry Fees',
                    style: TextStyle(
                        fontFamily: 'malgun',
                        fontSize: 17,
                        color: Colors.white),
                  ),
                  subtitle: Container(
                    padding: const EdgeInsets.only(top: 4, bottom: 5),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Ladies',
                              style: TextStyle(
                                  fontFamily: 'malgun',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            Text(
                              'Couples',
                              style: TextStyle(
                                  fontFamily: 'malgun',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            Text(
                              'Stag',
                              style: TextStyle(
                                  fontFamily: 'malgun',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                            Text(
                              'Others',
                              style: TextStyle(
                                  fontFamily: 'malgun',
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.party.ladies == '0'
                                ? const Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "  - ₹ ${widget.party.ladies}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                            widget.party.couples == '0'
                                ? const Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "  - ₹ ${widget.party.couples}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                            widget.party.stag == '0'
                                ? const Text(
                                    "  - NA",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    "  - ₹ ${widget.party.stag}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                            widget.party.others == '0'
                                ? const Text("  - NA",
                                    style: TextStyle(color: Colors.white))
                                : Text(
                                    "  - ₹ ${widget.party.others}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
              child:CustomButton(
                width: Get.width * 0.6,
                text: 'On Going',
                onPressed:(){ongoingParty(widget.party.id);},
              )
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 0),
              child: Container(
                alignment: Alignment.topCenter,
                child: const Text(
                  "Selected Amenities",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'malgun', fontSize: 16),
                ),
              ),
            ),
            Visibility(
              visible: _categoryLists.isNotEmpty,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _categoryLists.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final categoryList = _categoryLists[index];

                  return categoryList.amenities.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (categoryList.amenities.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  categoryList.title.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    letterSpacing: 1.1,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Wrap(
                                spacing: 5.0,
                                children: categoryList.amenities.map((amenity) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: amenity.selected
                                        ? Chip(
                                            label: Text(
                                              amenity.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.sp,
                                                fontFamily: 'malgun',
                                              ),
                                            ),
                                            backgroundColor: amenity.selected
                                                ? Colors.red.shade900
                                                : Colors.grey[400],
                                          )
                                        : Container(),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        )
                      : Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'malgun',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'malgun',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class TitleAnswerWidget extends StatelessWidget {
  final String title;
  final String answer;

  const TitleAnswerWidget(
      {super.key, required this.title, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red.withOpacity(0.2),
            ),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class BoostButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final color;

  const BoostButton(
      {Key? key,
      required this.color,
      required this.label,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flash_on, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
