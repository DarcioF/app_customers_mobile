import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController textEditingAction;
  final String hint;
  final String? hintText;
  final bool? enabled;
  final Function(String value) validator;

  const Input({
    Key? key,
    required this.textEditingAction,
    required this.hint,
    this.hintText,
    this.enabled,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
        child: TextFormField(
          controller: textEditingAction,
          obscureText: false,
          enabled: enabled,
          validator: (x) => validator(x!),
          decoration: InputDecoration(
            labelText: hint,
            labelStyle: TextStyle(
              fontFamily: 'Lexend Deca',
              fontWeight: FontWeight.bold
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Lexend Deca',
              color: Color(0x98FFFFFF),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color:Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
          ),
          style: TextStyle(
            fontFamily: 'Lexend Deca',
          ),
        ),
      ),
    );
  }
}
