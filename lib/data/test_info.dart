import 'package:flutter/material.dart';

class TestStep {
  final String amountBad;
  final String amountGood;
  final String conBad;
  final String conGood;
  final String deductionPoints;
  final String selected;

  TestStep(
      {this.amountBad,
      this.amountGood,
      this.conBad,
      this.conGood,
      this.deductionPoints,
      this.selected});

  factory TestStep.fromJson(Map<String, dynamic> json) {
    return TestStep(
      amountBad: json['Amount_Bad'],
      amountGood: json['Amount_Good'],
      conBad: json['Con_Bad'],
      conGood: json['Con_Good'],
      deductionPoints: json['DeductionPoints'],
      selected: json['selected'],
    );
  }
}

class TestResult {
  final String item;
  final String condition;
  String path = '';
  String remarks = '';

  TestResult({@required this.item, @required this.condition});

  @override
  String toString() {
    return '{\"Item\":\"$item\", \"Condition\":\"$condition\", \"path\":\"$path\", \"remarks\":\"$remarks\"}';
  }
}
