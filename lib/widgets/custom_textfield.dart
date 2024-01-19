import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:neumorphic_ui/neumorphic_ui.dart';
class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextInputType? textInput;
  final int? maxLines;
  final bool validate;
  final String? initialValue; // New parameter
  final int? maxLength;
  final bool obscureText;
  final bool enabled;
  var suffixIcon;
  Color iconColor;
  final Function(String)? onChanged;

  CustomTextField({
    super.key,
    required this.validate,
    this.suffixIcon,
    this.textInput,
    this.maxLines,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    this.onChanged,
    this.maxLength,
    this.initialValue,
    this.enabled=true,
    this.iconColor=Colors.grey,// Include new parameter in the constructor
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _isValid = true;
  final Map<String, String> _validationMessages = {
    'Name': 'Please enter your name.',
    'Email': 'Please enter a valid email address.',
    'Address': 'Please enter your address.',
    'Password': 'Password must be at least 6 characters long.',
    'Mobile Number': 'Please enter a valid 10-digit mobile number.',
    'PIN Code': 'Please enter a valid 6-digit PIN code.',
  };
  late TextEditingController _textController; // Create a TextEditingController

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
        text: widget.initialValue); // Set the initial value

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _textController.dispose(); // Dispose of the controller when done

    _shakeController.dispose();
    super.dispose();
  }

  bool validateName(String value) {
    return value.isNotEmpty;
  }

  bool validateEmail(String value) {
    // Simple email validation
    return RegExp(
            r'^[\w-]+(\.[\w-]+)*@[a-zA-Z\d-]+(\.[a-zA-Z\d-]+)*\.[a-zA-Z\d-]{2,4}$')
        .hasMatch(value);
  }

  bool validateAddress(String value) {
    return value.isNotEmpty;
  }

  bool validatePassword(String value) {
    return value.length >= 6;
  }

  bool validateMobileNumber(String value) {
    // Simple mobile number validation
    return RegExp(r'^[0-9]{10}$').hasMatch(value);
  }

  bool validatePinCode(String value) {
    // Simple PIN code validation
    return RegExp(r'^[0-9]{6}$').hasMatch(value);
  }

  void validateField(String value) {
    bool isValid = widget.validate ? validateValue(value) : true;
    setState(() {
      _isValid = isValid;
    });
    if (!_isValid) {
      _shakeController.forward(from: 0.0);
    }
  }

  bool validateValue(String value) {
    if (widget.hintText == 'Name') {
      return validateName(value);
    } else if (widget.hintText == 'Email') {
      return validateEmail(value);
    } else if (widget.hintText == 'Address') {
      return validateAddress(value);
    } else if (widget.hintText == 'Password') {
      return validatePassword(value);
    } else if (widget.hintText == 'Mobile Number') {
      return validateMobileNumber(value);
    } else if (widget.hintText == 'PIN Code') {
      return validatePinCode(value);
    }
    // Add more field validations if needed
    return true; // Default to true if no specific validation found
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
        color: Colors.grey.shade100, // Very light grey for a softer look
      ),
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_shakeAnimation.value, 0.0),
            child: TextField(
              controller: _textController,
              // Use the controller
               maxLength: widget.maxLength,
              enabled: widget.enabled ,
              maxLines: widget.maxLines,
              keyboardType: widget.textInput,
              style: const TextStyle(color: Colors.black),
              // Very light color for the text
              obscureText: widget.obscureText,
              onChanged: (value) {
                widget.onChanged?.call(value);
                validateField(value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText,
                prefixIcon: Icon(
                  widget.icon,
                  color: Colors.red.shade900, // Standard grey for the icons
                ),
                suffixIcon: widget.suffixIcon,
                hintStyle: TextStyle(
                    color: _isValid ? Colors.grey : Colors.red.shade800,
                    fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }
}
