import 'package:flutter_blockly/flutter_blockly.dart';
import 'package:tcc_rabbits_challenge/content.dart';
import 'dart:js'; //change this to something that is multi-platform

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
