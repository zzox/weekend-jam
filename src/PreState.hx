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

        // var textBytes = Assets.getText(AssetPaths.miniset__fnt);
        // var XMLData = Xml.parse(textBytes);
        // var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.miniset__png, XMLData);

        // var text = new FlxBitmapText(fontAngelCode);
        // text.letterSpacing = -1;
        // text.setPosition(12, 12);
        // text.text = 'We are WAITING to start_the_GAMe??!!!!';
        // bgColor = 0xffaaaaaa;
        // add(text);
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
