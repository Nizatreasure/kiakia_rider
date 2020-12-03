import 'package:flutter/material.dart';

final decoration = InputDecoration(
  counterText: '',
  filled: true,
  fillColor: Color.fromRGBO(5, 54, 90, 0.05),
  hintStyle: TextStyle(
      color: Color.fromRGBO(5, 54, 90, 0.3),
      fontWeight: FontWeight.w400,
      fontSize: 14),
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.transparent)),
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(255, 71, 71, 1), width: 0.5),
      borderRadius: BorderRadius.circular(8)),
  focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(255, 71, 71, 1), width: 0.5),
      borderRadius: BorderRadius.circular(8)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide:
          BorderSide(color: Color.fromRGBO(35, 197, 82, 1), width: 0.5)),
  errorStyle: TextStyle(height: 0),
  prefixStyle: TextStyle(
      color: Color.fromRGBO(5, 54, 90, 1),
      fontWeight: FontWeight.w700,
      fontSize: 14),
);
