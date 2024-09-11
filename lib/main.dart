import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:tcc_rabbits_challenge/blockly.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';
import 'dart:js'; //change this to something that is multi-platform
import 'package:flutter_blockly/flutter_blockly.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();


//to see if flutter is running JS
  var object = JsObject(context['Object']);
  object['greeting'] = 'Hello';
  object['greet'] = (name) => "${object['greeting']} $name";
  var message = object.callMethod('greet', ['JavaScript']);
  context['console'].callMethod('log', [message]);

  RabbitsChallenge game = RabbitsChallenge();

  String customBlocks = await rootBundle.loadString('assets/js/custom_blocks.js');

  runApp(
    MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 480, // Define a largura do jogo
              child: GameWidget(game: game),
            ),
            Expanded(
              child: Container(
                color: const Color(0x253A5633),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: BlocklyEditorWidget(
                        workspaceConfiguration: workspaceConfiguration,
                        initial: null,
                        /*onInject: (data) {
                          if (kDebugMode) {
                            print("Editor Injected");
                          }
                        },
                        onChange: (data) {
                          if (kDebugMode) {
                            print("Editor Changed");
                          }
                        },
                        onDispose: (data) {
                          if (kDebugMode) {
                            print("Editor Disposed");
                          }
                        },
                        onError: (error) {
                          if (kDebugMode) {
                            print("Error: $error");
                          }
                        },*/
                        style: null,
                        script: customBlocks,
                        editor: null,
                        packages: null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
