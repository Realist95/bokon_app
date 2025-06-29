import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:photo_view/photo_view.dart';

class GalleryPhotoWrapper extends StatelessWidget {
  const GalleryPhotoWrapper({
    super.key,
    required this.child,
    required this.imageUrl,
    this.backgroundColor = Colors.black,
    this.backgroundIsTransparent = true,
    // this.disposeLevel,
    // this.disableSwipeToDismiss = false,
  });

  final Widget child;
  final String imageUrl;

  final Color backgroundColor;

  final bool backgroundIsTransparent;

  // final DisposeLevel? disposeLevel;

  // final bool disableSwipeToDismiss;

  @override
  Widget build(BuildContext context) {
    final UniqueKey tag = UniqueKey();

    Image image = Image.file(File(imageUrl), fit: BoxFit.contain);

    return Hero(
      tag: tag,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              barrierColor: backgroundIsTransparent
                  ? Colors.white.withOpacity(0)
                  : backgroundColor,
              pageBuilder: (BuildContext context, _, __) {
                return FullScreenPhoto(
                  tag: tag,
                  backgroundColor: backgroundColor,
                  backgroundIsTransparent: backgroundIsTransparent,
                  child: image.image,
                );
              },
            ),
          );
        },
        child: ImagePixels(
          imageProvider: image.image,
          defaultColor: Colors.grey,
          builder: (context, img) {
            return child;
          },
        ),
      ),
    );
  }
}

class FullScreenPhoto extends StatefulWidget {
  const FullScreenPhoto({
    super.key,
    required this.child,
    required this.tag,
    this.backgroundColor = Colors.black,
    this.backgroundIsTransparent = true,
  });

  final ImageProvider child;
  final Color backgroundColor;
  final bool backgroundIsTransparent;
  final UniqueKey tag;

  @override
  _FullScreenViewerState createState() => _FullScreenViewerState();
}

class _FullScreenViewerState extends State<FullScreenPhoto> {
  double? _initialPositionY = 0;

  double? _currentPositionY = 0;

  double _positionYDelta = 0;

  double _opacity = 1;

  final double _disposeLimit = 150;

  Duration _animationDuration = Duration.zero;

  final controller = TransformationController();

  int widthImg = 0;
  int heightImg = 0;

  @override
  void initState() {
    super.initState();
    // setDisposeLevel();

    // controller.addListener(() {
    //   setState(() {});
    // });
  }

  // setDisposeLevel() {
  //   if (widget.disposeLevel == DisposeLevel.high) {
  //     _disposeLimit = 300;
  //   } else if (widget.disposeLevel == DisposeLevel.medium) {
  //     _disposeLimit = 200;
  //   } else {
  //     _disposeLimit = 100;
  //   }
  // }

  void _dragUpdate(DragUpdateDetails details) {
    setState(() {
      _currentPositionY = details.globalPosition.dy;
      _positionYDelta = _currentPositionY! - _initialPositionY!;
      setOpacity();
    });
  }

  void _dragStart(DragStartDetails details) {
    setState(() {
      _initialPositionY = details.globalPosition.dy;
    });
  }

  _dragEnd(DragEndDetails details) {
    if (_positionYDelta > _disposeLimit || _positionYDelta < -_disposeLimit) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        // _animationDuration = _kRouteDuration;
        _opacity = 1;
        _positionYDelta = 0;
      });

      Future.delayed(_animationDuration).then((_) {
        setState(() {
          _animationDuration = Duration.zero;
        });
      });
    }
  }

  setOpacity() {
    final double tmp = _positionYDelta < 0
        ? 1 - ((_positionYDelta / 1000) * -1)
        : 1 - (_positionYDelta / 1000);
    if (kDebugMode) {
      print(tmp);
    }

    if (tmp > 1) {
      _opacity = 1;
    } else if (tmp < 0) {
      _opacity = 0;
    } else {
      _opacity = tmp;
    }

    if (_positionYDelta > _disposeLimit || _positionYDelta < -_disposeLimit) {
      _opacity = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPosition = 0 + max(_positionYDelta, -_positionYDelta) / 15;

    return ImagePixels(
      imageProvider: widget.child,
      defaultColor: Colors.grey,
      builder: (context, img) {
        widthImg = img.width ?? 0;
        heightImg = img.height ?? 0;

        return Hero(
          tag: widget.tag,
          child: Scaffold(
            backgroundColor: widget.backgroundIsTransparent
                ? Colors.transparent
                : widget.backgroundColor,
            body: Container(
              color: widget.backgroundColor.withOpacity(_opacity),
              constraints: BoxConstraints.expand(
                height: MediaQuery.of(context).size.height,
              ),
              child: Stack(
                children: <Widget>[
                  PhotoView(
                    imageProvider: widget.child,
                    minScale: 1.0,
                    maxScale: 2.5,
                  ),
                  // AnimatedPositioned(
                  //   duration: _animationDuration,
                  //   curve: Curves.fastOutSlowIn,
                  //   top: 0 + _positionYDelta,
                  //   bottom: 0 - _positionYDelta,
                  //   left: horizontalPosition,
                  //   right: horizontalPosition,
                  //   child: InteractiveViewer(
                  //       // boundaryMargin: const EdgeInsets.all(double.infinity),
                  //       // panEnabled: true,
                  //       minScale: 1.0,
                  //       panAxis: widthImg > heightImg
                  //           ? PanAxis.horizontal
                  //           : PanAxis.vertical,
                  //       transformationController: controller,
                  //       // onInteractionEnd: (details) {
                  //       //   print(details);
                  //       // },
                  //       // constrained: false,
                  //       child:
                  //           // widget.disableSwipeToDismiss
                  //           ClipRRect(
                  //         // borderRadius: const BorderRadius.all(
                  //         //   Radius.circular(40),
                  //         // ),
                  //         clipBehavior: Clip.hardEdge,
                  //         child: Image(
                  //           image: widget.child,
                  //         ),

                  //         // widget.child,
                  //       )
                  //       // : KeymotionGestureDetector(
                  //       //     onStart: (details) => _dragStart(details),
                  //       //     onUpdate: (details) => _dragUpdate(details),
                  //       //     onEnd: (details) => _dragEnd(details),
                  //       //     child: ClipRRect(
                  //       //       borderRadius: const BorderRadius.all(
                  //       //         Radius.circular(40),
                  //       //       ),
                  //       //       clipBehavior: Clip.hardEdge,
                  //       //       child: widget.child,
                  //       //     ),
                  //       //   ),
                  //       ),
                  // ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 60, 30, 0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(40),
                            ),
                            color: Color(0xff222222),
                          ),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.clear,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
