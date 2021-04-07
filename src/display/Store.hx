package display;

import data.Constants as Const;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import openfl.Assets;

class Store extends FlxGroup {
    var scene:PlayState;
    var bg1:FlxSprite;
    var bg2:FlxSprite;
    var bg3:FlxSprite;
    var text1:FlxBitmapText;
    var text2:FlxBitmapText;
    var text3:FlxBitmapText;

    public function new (scene:PlayState) {
        super();

        this.scene = scene;

        var textBytes = Assets.getText(AssetPaths.pixel3x5__fnt);
        var XMLData = Xml.parse(textBytes);
        var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.pixel3x5__png, XMLData);

        bg1 = new FlxSprite(6, 90);
        bg1.makeGraphic(44, 60, Const.HUD_BACKGROUND_COLOR);
        add(bg1);

        text1 = new FlxBitmapText(fontAngelCode);
        text1.setPosition(6, 106);
        text1.text = 'test 1 text';
        add(text1);

        bg2 = new FlxSprite(56, 90);
        bg2.makeGraphic(44, 60, Const.HUD_BACKGROUND_COLOR);
        add(bg2);

        text2 = new FlxBitmapText(fontAngelCode);
        text2.setPosition(56, 106);
        text2.text = 'test 2 text';
        add(text2);

        bg3 = new FlxSprite(106, 90);
        bg3.makeGraphic(44, 60, Const.HUD_BACKGROUND_COLOR);
        add(bg3);

        text3 = new FlxBitmapText(fontAngelCode);
        text3.setPosition(106, 106);
        text3.text = 'test 3 text';
        add(text3);
    }
}
