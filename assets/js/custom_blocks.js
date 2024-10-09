
console.log(Blockly);

var movementRightJson = {
  "type": "movement_right",
  "message0": "mova-se à direita %1",
  "args0": [
    {
      "type": "input_dummy",
      "name": "forward",
      "align": "CENTRE"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 330,
  "tooltip": "",
  "helpUrl": "",
  "inputsInline": false
}

var movementLeftJson = {
  "type": "movement_left",
  "tooltip": "",
  "helpUrl": "",
  "message0": "mova-se à esquerda %1",
  "args0": [
    {
      "type": "input_dummy",
      "name": "backward",
      "align": "CENTRE"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 330,
  "inputsInline": false
}

var setDirectionJson = {
  "type": "set_direction",
  "tooltip": "",
  "helpUrl": "",
  "message0": "vire à  %1 %2",
  "args0": [
    {
      "type": "field_dropdown",
      "name": "direction_options",
      "options": [
        [
          "esquerda",
          "left"
        ],
        [
          "direita",
          "right"
        ]
      ]
    },
    {
      "type": "input_dummy",
      "name": "turn_direction"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 255
}

var jumpJson = {
  "type": "jump",
  "tooltip": "",
  "helpUrl": "",
  "message0": "pule %1",
  "args0": [
    {
      "type": "input_dummy",
      "name": "jump"
    }
  ],
  "previousStatement": null,
  "nextStatement": null,
  "colour": 165
}

Blockly.Blocks['movement_right'] = {
  init: function () {
    this.jsonInit(movementRightJson);
  }
};


Blockly.Blocks['movement_left'] = {
  init: function () {
    this.jsonInit(movementLeftJson);
  }
};

Blockly.Blocks['set_direction'] = {
  init: function () {
    this.jsonInit(setDirectionJson);
  }
};

Blockly.Blocks['jump'] = {
  init: function () {
    this.jsonInit(jumpJson);
  }
};

Blockly.JavaScript.forBlock['movement_right'] = function (block) {
  console.log("aha direita");
  var code = 'window.parent.postMessage({ action: \'move_player\', direction: \'right\' }, \'*\');';
  return code;
};

Blockly.JavaScript.forBlock['movement_left'] = function (block) {
  console.log("aha esquerda");
  var code = 'window.parent.postMessage({ action: \'move_player\', direction: \'left\' }, \'*\');';
  return code;
};

Blockly.JavaScript.forBlock['set_direction'] = function (block) {
  console.log("aha direction");
  var direction = block.getFieldValue('direction_options');
  console.log(direction);
  var code = 'window.parent.postMessage({ action: \'change_direction\', direction: \'' + direction + '\' }, \'*\');';
  return code;
};

Blockly.JavaScript.forBlock['jump'] = function (block) {

  console.log("aha jump");
  var code = 'window.parent.postMessage({ action: \'jump\' }, \'*\');';
  return code;

};