import 'package:flutter/material.dart';

class Note extends StatelessWidget {

  String _name;
  String _date;
  int _id;

  Note(this._name, this._date);

  String get name => _name;
  String get date => _date;
  int get id => _id;

  Note.map(dynamic obj) {
    this._name = obj['name'];
    this._date = obj['date'];
    this._id = obj['id'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['name'] = _name;
    map['date'] = _date;
    if (_id != null) {
      map['id'] = _id;
    }
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._name = map['name'];
    this._date = map['date'];
    this._id = map['id'];
  }






  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(

        children: <Widget>[
          Text(
            _name,
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),

          Text(
            _date,
            style: TextStyle(
              fontSize: 10.0,
            ),
          )
        ],
      )
    );
  }
}
