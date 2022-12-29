import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Widget to Marker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Widget to Marker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<Marker> markers = {};
  initMarkers() async {
    markers = {};

    markers.add(Marker(
      markerId: const MarkerId("1"),
      position: const LatLng(31.06976262630338, 31.23652808368206),
      icon: await CountWidget(count: 1).toBitmapDescriptor(),
    ));
    markers.add(Marker(
      markerId: const MarkerId("2"),
      position: const LatLng(30.418868934059237, 31.22851464897394),
      icon: await MarkerWidget().toBitmapDescriptor(),
    ));
    markers.add(Marker(
      markerId: const MarkerId("3"),
      position: const LatLng(30.01124477440843, 30.78459296375513),
      icon: await TextOnImage(
        text: "Hello World",
      ).toBitmapDescriptor(),
    ));
    setState(() {});
  }

  @override
  void initState() {
    initMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: GoogleMap(
          initialCameraPosition: const CameraPosition(
              target: LatLng(30.488774662306618, 31.032559163868427), zoom: 9),
          markers: markers,
          onTap: (s) {
            print(s);
          },
        )));
  }
}

class CountWidget extends StatelessWidget {
  const CountWidget({super.key, required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text('$count'),
    );
  }
}

class MarkerWidget extends StatelessWidget {
  const MarkerWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Image(
      image: const AssetImage(
        "assets/marker2.png",
      ),
      height: 150,
      width: 150,
    );
  }
}

class TextOnImage extends StatelessWidget {
  const TextOnImage({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image(
          image: const AssetImage(
            "assets/marker.png",
          ),
          height: 150,
          width: 150,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }
}
