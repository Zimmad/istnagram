// This class is not immutable, because it holds of a variable(state) that is not final and private.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:istnagram/views/components/constants/strings.dart';
import 'package:istnagram/views/components/loading/loading_screen_constroller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;
  // factory LoadingScreen.instance() => LoadingScreen._sharedInstance();

  LoadingScreenController? _controller;

  void show({required BuildContext context, String text = Strings.loading}) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: text);
    }
  }

  void hide() {
    _controller?.close;
    _controller = null;
  }

  LoadingScreenController? showOverlay(
      {required BuildContext context, required String text}) {
    final state = Overlay.of(context);
    if (state == null) {
      return null;
    }
    final textController = StreamController<String>();
    textController.add(text);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: ((context) => Material(
            //by default it takes the entire height
            color: Colors.black
                .withAlpha(150), // Black transparent color. 255 is full balck
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: size.height * 0.8,
                  maxWidth: size.width * 0.8,
                  minWidth: size.width * 0.5,
                  // minHeight: size.height * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  // by default it takes the entire height
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    // by defalt it takes the entire height
                    // controller:
                    child: Column(
                      // by default it takes the entire available height
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const CircularProgressIndicator(),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<String>(
                          stream: textController.stream,
                          // initialData: initialData,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.requireData,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black),
                              );
                            } else {
                              return Container(
                                  // child: child,
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );

    state.insert(overlay);
    return LoadingScreenController(close: () {
      textController.close();
      overlay.remove();
      return true;
    }, update: (text) {
      textController.add(text);
      return true;
    });
  }
}
