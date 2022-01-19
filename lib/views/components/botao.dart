import 'package:flutter/material.dart';

class Botao extends StatelessWidget {
  final String hint;
  final IconData icone;
  final Function click;
  final Color color;

  const Botao({
    Key? key,
    required this.hint,
    required this.icone,
    required this.click,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style:ElevatedButton.styleFrom(
        primary: color
      ),
      onPressed: () => click(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icone),
          SizedBox(
            width: 5,
          ),
          Text(hint),
        ],
      ),
    );
  }
}
