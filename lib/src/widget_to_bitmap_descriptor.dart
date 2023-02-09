import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension ToBitDescription on Widget {
  Future<BitmapDescriptor> toBitmapDescriptor(
      {Size logicalSize = const Size(100, 100),
      Size imageSize = const Size(100, 100),
      Duration waitToRender = const Duration(milliseconds: 300),
      TextDirection textDirection = TextDirection.ltr}) async {
    final widget = RepaintBoundary(
      child: MediaQuery(
          data: const MediaQueryData(),
          child: Directionality(textDirection: TextDirection.ltr, child: this)),
    );
    final pngBytes = await createImageFromWidget(widget,
        waitToRender: waitToRender,
        logicalSize: logicalSize,
        imageSize: imageSize);
    return BitmapDescriptor.fromBytes(pngBytes);
  }
}

/// Creates an image from the given widget by first spinning up a element and render tree,
/// wait [waitToRender] to render the widget that take time like network and asset images

/// The final image will be of size [imageSize] and the the widget will be layout, ... with the given [logicalSize].
Future<Uint8List> createImageFromWidget(Widget widget,
    {required Size logicalSize,
    required Duration waitToRender,
    required Size imageSize}) async {
  final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();

  logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;
  imageSize = ui.window.physicalSize;

  // assert(logicalSize.aspectRatio == imageSize.aspectRatio);

  final RenderView renderView = RenderView(
    window: WidgetsBinding.instance.window,
    child: RenderPositionedBox(
        alignment: Alignment.center, child: repaintBoundary),
    configuration: ViewConfiguration(
      size: logicalSize,
      devicePixelRatio: 1.0,
    ),
  );

  final PipelineOwner pipelineOwner = PipelineOwner();
  final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());

  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();

  final RenderObjectToWidgetElement<RenderBox> rootElement =
      RenderObjectToWidgetAdapter<RenderBox>(
    container: repaintBoundary,
    child: widget,
  ).attachToRenderTree(buildOwner);

  buildOwner.buildScope(rootElement);

  await Future.delayed(waitToRender);

  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();

  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();

  final ui.Image image = await repaintBoundary.toImage(
      pixelRatio: imageSize.width / logicalSize.width);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}
