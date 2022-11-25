import 'package:audio_player_changenotifier/Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Home.dart';

void main() {
  runApp(MaterialApp(
    home: ChangeNotifierProvider(create: (context) => Model(), child: Home()),
  ));
}
