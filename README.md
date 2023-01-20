<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->


## Features
When using Google Maps, we always have a problem with adding a marker on the map, and the available tools were either drawing the marker through canva path or using an image, but the problem is if we want to add words or data or add custom edit to this marker, but this package has solved the problem and now you can use any widget in filters as a marker for google map !
using the .toBitmapDescriptor() function on the widget to Convert it to use it as a marker icon!
# Getting started
## Add dependency

```dart
dependencies:
  widget_to_marker: ^0.0.1+3
```
##  1 - Create Your Widget To Make it as Marker:

```dart
import 'package:widget_to_marker/widget_to_marker.dart';

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
```
##  2 - Add it to the marker with   `.toBitmapDescriptor()`:
```dart
Marker(
      markerId: const MarkerId("3"),
      position: const LatLng(30.01124477440843, 30.78459296375513),
      icon: await TextOnImage(
        text: "Hello World",
      ).toBitmapDescriptor(),
    )
```
## Note
 You Can Use waitToRender Attribute to set duration for rendering large network and asset images

## Enjoy!!

![image](https://user-images.githubusercontent.com/88829064/210017494-ef63d4a2-fdec-46d9-b2a2-4f0451932e01.png)


