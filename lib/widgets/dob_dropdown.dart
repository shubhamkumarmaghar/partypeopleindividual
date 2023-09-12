import 'dart:developer';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:partypeopleindividual/individual_profile/controller/individual_profile_controller.dart';

class CustomDateField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final bool validate;
  final TextEditingController controller;

  const CustomDateField({
    super.key,
    required this.validate,
    required this.hintText,
    required this.icon,
    required this.controller,
  });

  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  DateTime? _selectedDate;
  IndividualProfileController individualProfileController =
  Get.put(IndividualProfileController());


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        widget.controller.text =
            DateFormat('dd/MM/yyyy').format(_selectedDate!);
        individualProfileController.dob.value = widget.controller.text;
      });
    }
    else{
      DateTime date =  DateTime.parse('${widget.controller.text}');
          log('date $date');
      widget.controller.text = DateFormat('dd/MM/yyyy').format(date);
      log('new date $date');

    }
  }



  @override
  Widget build(BuildContext context) {
    //DateTime date =  DateTime.parse('${widget.controller.text}');
   // log('date $date');
  //  widget.controller.text = DateFormat('dd/MM/yyyy').format(date);
   // log('new date $date');
    return Neumorphic(
      margin: const EdgeInsets.all(12.0),
      style: NeumorphicStyle(
        intensity: 0.8,
        surfaceIntensity: 0.25,
        depth: 8,
        shape: NeumorphicShape.flat,
        lightSource: LightSource.topLeft,
        color: Colors.grey.shade100, // Very light grey for a softer look
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          Icon(
            widget.icon,
            color: Colors.red.shade900, // Standard grey for the icons
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  controller: widget.controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
