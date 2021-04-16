package display;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;
import flixel.text.FlxBitmapText;
import flixel.util.FlxTimer;
import openfl.Assets;

class Banner extends FlxGroup {
    static inline final FULL_WIDTH = 160;
    public var text:FlxBitmapText;
    public var background:FlxSprite;

    public function new (offset:Int = 0) {
        super();
        var textBytes = Assets.getText(AssetPaths.pixel3x5__fnt);
        var XMLData = Xml.parse(textBytes);
        var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.pixel3x5__png, XMLData);
        
        background = new FlxSprite(0, 112);
        background.makeGraphic(FULL_WIDTH, 13 + offset, 0xff211640);
        add(background);
    
        text = new FlxBitmapText(fontAngelCode);
        text.setPosition(18, 110 + offset);
        add(text);
        visible = false;
    }

    public function display (displayText:String, ?time:Float) {
        text.text = displayText;
        visible = true;

        text.setPosition((FULL_WIDTH - text.width) / 2, text.y);

        if (time != null) {
            new FlxTimer().start(time, (_:FlxTimer) -> { visible = false; });
        }
    }
}

// TODO: make work
class GameOverBaner extends Banner {
    public function new () {
        super(32);
    }

    public function show () {
        // a

        visible = true;
        text.text = 'HI - SCORE'; // different display between hi score and score
    }
}
