import {javascriptGenerator, Order} from 'blockly/javascript';

// Definir bloco personalizado 'movement'
Blockly.Blocks['movement'] = {
  init: function () {
    this.jsonInit({
      "type": "movement",
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
    );
  }
};

Blockly.Blocks['movement_back'] = {
  init: function () {
    this.jsonInit({
      "type": "movement_back",
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
    );
  }
};

Blockly.Blocks['set_direction'] = {
  init: function () {
    this.jsonInit({
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
    );
  }
};

Blockly.Blocks['jump'] = {
  init: function () {
    this.jsonInit({
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
    );
  }
};

// Gerador de código para o bloco 'movement'
javascriptGenerator['movement'] = function (block) {
  window.parent.postMessage({ action: 'move_player', direction: 'right' }, '*');
};

javascriptGenerator['movement_back'] = function (block) {
  window.parent.postMessage({ action: 'move_player', direction: 'left' }, '*');
};

javascriptGenerator['set_direction'] = function (block) {
  //window.parent.postMessage({action: 'move_player', direction: 'left'}, '*');
};

javascriptGenerator['jump'] = function (block) {
  window.parent.postMessage({ action: 'jump' }, '*');
};