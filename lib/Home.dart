import 'package:audio_player_changenotifier/Model.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'second.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Model m = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio_List"),
      ),
      body: FutureBuilder(
        future: m.getSong(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<SongModel> list = snapshot.data as List<SongModel>;
            print(list);
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                // SongModel sm = list[index];
                print(list[index].title);
                return ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return second(list, index);
                      },
                    ));
                  },
                  title: Text("${list[index].title}"),
                  subtitle: Text(m.printDuration(Duration(
                      milliseconds: list[index].duration!.toInt()))), //
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
