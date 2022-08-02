import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

  Row bottomTxt(
      {required String desc, required String title, required var onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          desc,
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: const TextStyle(color: Color(0xff14DAE2)),
            ))
      ],
    );
  }

  Container customTextFileds({
    required String iconImg,
    required String title,
    required TextEditingController textEditingController,
    required var valid,
    var onChangeValue,
    var icondata,
    bool isObseucre = false,
  }) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 13,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
            style: const TextStyle(color: Colors.white),
            obscureText: isObseucre,
            controller: textEditingController,
            validator: valid,
            decoration: InputDecoration(
                prefixIcon: Image.asset(iconImg),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                border: InputBorder.none,
                // ignore: use_full_hex_values_for_flutter_colors
                fillColor: const Color(0xfff3b324e),
                filled: true,
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide:
                        BorderSide(width: 2.0, color: Color(0xff14DAE2)))),
            onChanged: ((value) => onChangeValue = value))
      ]),
    );
  }