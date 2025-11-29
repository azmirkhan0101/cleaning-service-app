import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneInputField extends StatefulWidget {
  final String initialIsoCode;
  final String? initialNumber; // local number without country code
  final String? initialE164; // full number with country code e.g. +15551234567
  final void Function(String e164)? onChanged; // returns +<code><number>
  final void Function(bool isValid)? onValidated; // validation callback

  const PhoneInputField({
    super.key,
    this.initialIsoCode = 'IT',
    this.initialNumber,
    this.initialE164,
    this.onChanged,
    this.onValidated,
  });

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  final TextEditingController _controller = TextEditingController();
  late PhoneNumber _phoneNumber;

  @override
  void initState() {
    super.initState();
    _phoneNumber = PhoneNumber(isoCode: widget.initialIsoCode);
    if (widget.initialE164 != null && widget.initialE164!.isNotEmpty) {
      PhoneNumber.getRegionInfoFromPhoneNumber(widget.initialE164!)
          .then((resolved) {
            setState(() {
              _phoneNumber = resolved;
              // Use the parsed phone number from the resolved object
              // This preserves the correct local number
              _controller.text = resolved.parseNumber();
            });
          })
          .catchError((error) {
            debugPrint('Error parsing E164 number: $error');
            // Fallback: try to manually extract local number
            if (widget.initialNumber != null) {
              _controller.text = widget.initialNumber!;
            } else {
              // Last resort: show the full E164
              _controller.text = widget.initialE164!;
            }
          });
    } else if (widget.initialNumber != null) {
      _controller.text = widget.initialNumber!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber number) {
        if (widget.onChanged != null && number.phoneNumber != null) {
          widget.onChanged!(number.phoneNumber!);
        }
      },
      onInputValidated: (bool value) {
        if (widget.onValidated != null) {
          widget.onValidated!(value);
        }
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        useBottomSheetSafeArea: true,
        setSelectorButtonAsPrefixIcon: true,
        leadingPadding: 12,
        trailingSpace: false,
      ),
      autoValidateMode: AutovalidateMode.onUserInteraction,
      ignoreBlank: false,
      initialValue: _phoneNumber,
      textFieldController: _controller,
      formatInput: true,
      keyboardType: TextInputType.phone,
      inputDecoration: const InputDecoration(
        fillColor: Color(0xFFE9EBF3),
        filled: true,
        hintText: 'Enter your phone number',
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      searchBoxDecoration: const InputDecoration(
        labelText: 'Search Country',
        hintText: 'Search by name or code',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      spaceBetweenSelectorAndTextField: 12,
      maxLength: 15,
      errorMessage: 'Invalid phone number',
    );
  }
}
