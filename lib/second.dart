import 'package:audio_player_changenotifier/Model.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';//todo

class second extends StatelessWidget {
  List<SongModel> list;
  int index;

  second(this.list, this.index);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Model(),
      builder: (context, child) {
        Model m = Provider.of(context);
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () async {
                    await m.audioPlayer.pause();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back))),
          body: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(7),
                      bottomLeft: Radius.circular(7),
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                  ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 25, right: 25),
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (value) {
                      index = value;
                      m.pageChange();
                      print("Hardik");
                    },
                    controller: m.pagecontroller,
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Center(child: Text("${list[index].title}"));
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text("${list[index].displayName}"),
              SizedBox(
                height: 15,
              ),
              Slider(
                onChanged: (value)  async {
                  await m.audioPlayer.seek(Duration(milliseconds: value.toInt()));
                  await m.audioPlayer.resume();
                  print("Beladiya");
                  print(m.position);
                },
                min: 0,
                max: list[index].duration!.toDouble(),
                value: m.position.toDouble(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "+ ${m.printDuration(Duration(milliseconds: m.position.toInt()))}"),
                    Text(
                        "- ${m.printDuration(Duration(milliseconds: list[index].duration!.toInt()) - Duration(milliseconds: m.position.toInt()))}"),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              BottomAppBar(
                color: Colors.pink,
                elevation: 10,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        child: IconButton(
                            onPressed: () {
                              m.previousSideSong(index, list);
                              print("Hardik previousSide");
                            },
                            icon: Icon(size: 30, Icons.skip_previous)),
                      ),
                      CircleAvatar(
                        radius: 24,
                        child: IconButton(
                            onPressed: () {
                              m.stopStart(index, list);
                              print("Hardik play song");
                            },
                            icon: Icon(
                                m.isPlaying ? Icons.pause : Icons.play_arrow)),
                      ),
                      CircleAvatar(
                        radius: 24,
                        child: IconButton(
                            onPressed: () async {
                              m.nextSideSong(index, list);
                              print("Hardik nextSide Song");
                            },
                            icon: Icon(size: 30, Icons.skip_next)),
                      ),
                    ]),
              )
            ],
          ),
        );
      },
    );
  }
}
