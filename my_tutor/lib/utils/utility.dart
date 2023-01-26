import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility
{
  static String getHumanReadableDate( num millis){

    DateFormat dateFormat = DateFormat("dd-MMM-yyyy hh:mm a");
    return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(millis.toInt()));
  }

  static String getChatGroupId( String uid1, String uid2){

    if( uid1.codeUnitAt(0) > uid2.codeUnitAt(0)){
      return "$uid2$uid1";
    }else{
      return "$uid1$uid2";
    }
  }
}