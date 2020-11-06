import 'package:flutter/material.dart';
class SinduPlayer extends StatefulWidget {
  @override
  _SinduPlayerState createState() => _SinduPlayerState();
}

enum Status { running, stopped, paused }
IconData iconType = Icons.play_arrow_sharp;
Status current = Status.running;

void setIcon() {
  if(current == Status.running){
    iconType = Icons.pause;
    current = Status.paused;
  }
  else if(current == Status.paused){
    iconType = Icons.play_arrow_sharp;
    current = Status.running;
  }
}

class _SinduPlayerState extends State<SinduPlayer> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.skip_previous_sharp,
                    size: 90.0,
                    color: Colors.white
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    setIcon();
                  });
                },
                child: Icon(
                    iconType,
                    size: 90.0,
                    color: Colors.white),
              ),
              GestureDetector(
                onTap: () {},
                child: Icon(
                    Icons.skip_next_sharp,
                    size: 90.0,
                    color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
