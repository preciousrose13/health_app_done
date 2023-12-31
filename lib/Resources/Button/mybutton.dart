import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final bool loading;
  const RoundButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 60,
          width: 250,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 73, 170, 255),
            borderRadius: BorderRadius.circular(50),
            //border color 
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: loading
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  )
                : Text(
                    text,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
          )),
    );
  }
}
