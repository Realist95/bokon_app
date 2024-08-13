import 'package:bokon_app/common/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFiled extends StatelessWidget {
  const InputFiled({
    super.key,
    this.label = "",
    this.textError = "",
    this.isRequired = false,
    this.padding = const EdgeInsets.all(20),
    this.keyboardType = TextInputType.text,
    this.listInputFormatters,
    this.controller,
  });
  final String label;
  final String textError;
  final bool isRequired;
  final EdgeInsets padding;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? listInputFormatters;
  final TextEditingController? controller;

  get validator => (value) {
        if (isRequired == false) return null;
        if (value!.isEmpty) {
          return textError;
        }
        return null;
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(222, 222, 226, .1),
              width: 5,
            ),
          ),
          label: RichText(
            text: TextSpan(
              text: label,
              style: appStyle(
                18,
                const Color.fromRGBO(85, 85, 109, 1),
                FontWeight.w400,
              ),
              children: [
                isRequired
                    ? TextSpan(
                        text: " *",
                        style: appStyle(
                          18,
                          const Color(0xFFe51920),
                          FontWeight.w400,
                        ),
                      )
                    : const TextSpan()
              ],
            ),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: listInputFormatters,
      ),
    );
  }
}
