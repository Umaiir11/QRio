import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final bool isEnabled;
  final bool isDateField;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final String? validationText;
  final Function(dynamic)? onSubmit;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final InputDecoration? decoration;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int maxLines;
  final FocusNode? focusNode;
  final FocusNode? nextNode;
  final ValueChanged<dynamic>? onSaved;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? fieldPadding;
  final Iterable<String>? autofillHints; // New property for autofill hints

  const CustomTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.readOnly = false,
    this.isEnabled = true,
    this.keyboardType,
    this.controller,
    this.textInputAction,
    this.validationText,
    this.onSubmit,
    this.labelStyle,
    this.hintStyle,
    this.decoration,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.maxLines = 1,
    this.focusNode,
    this.nextNode,
    this.onSaved,
    this.padding,
    this.onChanged,
    this.isDateField = false,
    this.fieldPadding,
    this.autofillHints, // Initialize autofill hints
  }); // Pass key to super constructor

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? EdgeInsets.fromLTRB(16.0, 8, 16, 0),
      child: Column(
        children: [
          Visibility(
            visible: widget.labelText != null,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Text(widget.labelText ?? '', style: widget.labelStyle )),
              ),
            ),

          widget.isDateField ? _textDateField() : _textField(),
        ],
      ),
    );
  }

  Widget _textDateField() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.r)),
      child: InputDatePickerFormField(
          onDateSaved: widget.onSaved,
          onDateSubmitted: widget.onSubmit,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(3000)),
    );
  }

  Widget _textField() {
    return Padding(
      padding: widget.fieldPadding ?? const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: TextFormField(
        key: const ValueKey('textInput'),
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        focusNode: widget.focusNode,
        enabled: widget.isEnabled,
        textInputAction: widget.textInputAction,
        style: widget.labelStyle?.copyWith(fontSize: 14) ,
        // Adjust font size based on label style
        decoration: widget.decoration ??
            InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              fillColor: widget.isEnabled ? Colors.white : Colors.grey[300],
              filled: true,
              errorStyle: TextStyle(  color: Colors.redAccent ,fontWeight: FontWeight.normal ,letterSpacing:2 ),
              hintText: widget.hintText,
              hintStyle: TextStyle(  color: Colors.black ,fontWeight: FontWeight.normal ,letterSpacing:2 ),
              prefixIcon: widget.prefixIcon,
             // prefixStyle: AppTextStyles.customText14(color: Colors.grey),
              suffixIcon: widget.suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
        validator: (value) => value == null || value.isEmpty ? widget.validationText : null,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
        onFieldSubmitted: (value) {
          if (widget.focusNode != null && widget.nextNode != null) {
            try {
              widget.focusNode!.unfocus();
              FocusScope.of(context).requestFocus(widget.nextNode);
            } catch (e) {
              // Handle potential errors during focus management
              print('Error focusing next node: $e');
            }
          }
          if (widget.onSubmit != null) {
            widget.onSubmit!(value);
          }
        },
        autofillHints: widget.autofillHints, // Pass autofill hints
      ),
    );
  }
}