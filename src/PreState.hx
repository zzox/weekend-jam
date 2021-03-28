package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import openfl.Assets;

class PreState extends FlxState {
    override public function create () {
        super.create();

        FlxG.mouse.visible = false;
        // what about this?
        // FlxG.autoPause = false;
    }
    
    override public function update (elapsed:Float) {
        if (FlxG.keys.justPressed.SPACE) {
            startGame();
        }
    }

    function startGame () {
        FlxG.switchState(new PlayState());
    }
}
