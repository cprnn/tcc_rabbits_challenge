import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blockly/flutter_blockly.dart';
import 'package:tcc_rabbits_challenge/content.dart';
import 'package:tcc_rabbits_challenge/rabbits_challenge.dart';
import 'dart:js';

void _compileAndRunBlockly() {
  if (kIsWeb) {
    var workspace = context['Blockly'].callMethod('getMainWorkspace');
    if (workspace != null) {
      final codeGenerator = context['Blockly']['JavaScript'];
      final blocklyCode =
          codeGenerator.callMethod('workspaceToCode', [workspace]);
      print('Generated JavaScript code:');
      print(blocklyCode);
      try {
        context.callMethod('eval', [blocklyCode]);
      } catch (e) {
        print('Error evaluating JavaScript code:');
        print(e);
      }
    } else {
      if (kDebugMode) {
        print('Failed to retrieve main Blockly workspace.');
      }
    }
  } else {
    if (kDebugMode) {
      print('JavaScript execution is only available on Flutter Web.');
    }
  }
}

final BlocklyOptions workspaceConfiguration = BlocklyOptions.fromJson(const {
  'grid': {
    'spacing': 20,
    'length': 3,
    'colour': '#ccc',
    'snap': true,
  },
  'toolbox': initialToolboxJson,
  // null safety example
  'collapse': null,
  'comments': null,
  'css': null,
  'disable': null,
  'horizontalLayout': null,
  'maxBlocks': null,
  'maxInstances': null,
  'media': null,
  'modalInputs': null,
  'move': null,
  'oneBasedIndex': null,
  'readOnly': null,
  'renderer': null,
  'rendererOverrides': null,
  'rtl': null,
  'scrollbars': null,
  'sounds': null,
  'theme': null,
  'toolboxPosition': null,
  'trashcan': null,
  'maxTrashcanContents': null,
  'plugins': null,
  'zoom': null,
  'parentWorkspace': null,
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  RabbitsChallenge game = RabbitsChallenge();

  String customBlocks =
      await rootBundle.loadString('../assets/js/custom_blocks.js');

  void onInject(BlocklyData data) {
    debugPrint('onInject: ${data.xml}\n${jsonEncode(data.json)}');
  }

  void onChange(BlocklyData data) {
    debugPrint('onChange: ${data.xml}\n${jsonEncode(data.json)}\n${data.dart}');
  }

  void onDispose(BlocklyData data) {
    debugPrint('onDispose: ${data.xml}\n${jsonEncode(data.json)}');
  }

  void onError(dynamic err) {
    debugPrint('onError: $err');
  }

  runApp(
    MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 480, // Largura do jogo
              child: GameWidget(game: game),
            ),
            const ElevatedButton(
              onPressed: _compileAndRunBlockly,
              child: Text("Compilar e Executar Código"),
            ),
            ElevatedButton(
              onPressed: game.clearBlocklyWorkspace,
              child: const Text("Limpar Workspace"),
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
                        onInject: onInject,
                        onChange: onChange,
                        onDispose: onDispose,
                        onError: onError,
                        style: null,
                        script: '''
                          $customBlocks''',
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
