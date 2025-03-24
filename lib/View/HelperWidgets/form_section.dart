import 'package:flutter/material.dart';

class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const FormSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 10),
        ...children,
        const SizedBox(height: 20),
      ],
    );
  }
}


class FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isNumber;

  const FormTextField({super.key, required this.controller, required this.label, this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

Widget customTextFormField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  TextInputType inputType = TextInputType.text,
  String? Function(String?)? validator,
  bool isRequired = true,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: labelText, hintText: hintText),
    keyboardType: inputType,
    validator: validator ??
            (value) {
          if (isRequired && value!.isEmpty) {
            return '$labelText is required';
          }
          return null;
        },
  );
}

Widget customSlider({
  required double value,
  required Function(double) onChanged,
}) {
  return Slider(
    value: value,
    min: 0,
    max: 200,
    divisions: 40,
    onChanged: onChanged,
  );
}

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  int maxLines = 1,
  int? maxLength,
  Function(String)? onChanged,
}) {
  return TextField(
    decoration: InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    maxLines: maxLines,
    maxLength: maxLength,
    controller: controller,
    onChanged: onChanged,
  );
}

Widget customSectionTitle(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: Colors.white,
      fontFamily: 'Cairo',
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
  );
}
