package display;

import data.Constants as Const;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import openfl.Assets;
import objects.Powerup;

class Store extends FlxGroup {
    static inline final GRAPHIC_HEIGHT = 60;
    static inline final GRAPHIC_WIDTH = 44;

    var scene:PlayState;
    var bg1:FlxSprite;
    var bg2:FlxSprite;
    var bg3:FlxSprite;
    var startBg:FlxSprite;
    var text1:FlxBitmapText;
    var text2:FlxBitmapText;
    var text3:FlxBitmapText;
    var startText:FlxBitmapText;
    public var powerupPos1:FlxPoint = new FlxPoint(22, 102);
    public var powerupPos2:FlxPoint = new FlxPoint(72, 102);
    public var powerupPos3:FlxPoint = new FlxPoint(122, 102);
    public var powerupPosStart:FlxPoint = new FlxPoint(122, 180);

    public function new (scene:PlayState) {
        super();

        this.scene = scene;

        var textBytes = Assets.getText(AssetPaths.pixel3x5__fnt);
        var XMLData = Xml.parse(textBytes);
        var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.pixel3x5__png, XMLData);

        bg1 = new FlxSprite(6, 90);
        bg1.makeGraphic(GRAPHIC_WIDTH, GRAPHIC_HEIGHT, Const.HUD_BACKGROUND_COLOR);
        add(bg1);

        text1 = new FlxBitmapText(fontAngelCode);
        text1.setPosition(6, 120);
        text1.text = '';
        add(text1);

        bg2 = new FlxSprite(56, 90);
        bg2.makeGraphic(GRAPHIC_WIDTH, GRAPHIC_HEIGHT, Const.HUD_BACKGROUND_COLOR);
        add(bg2);

        text2 = new FlxBitmapText(fontAngelCode);
        text2.setPosition(56, 120);
        text2.text = '';
        add(text2);

        bg3 = new FlxSprite(106, 90);
        bg3.makeGraphic(GRAPHIC_WIDTH, GRAPHIC_HEIGHT, Const.HUD_BACKGROUND_COLOR);
        add(bg3);

        text3 = new FlxBitmapText(fontAngelCode);
        text3.setPosition(106, 120);
        text3.text = '';
        add(text3);

        startBg = new FlxSprite(106, 168);
        startBg.makeGraphic(GRAPHIC_WIDTH, GRAPHIC_HEIGHT, Const.HUD_BACKGROUND_COLOR);
        add(startBg);

        startText = new FlxBitmapText(fontAngelCode);
        startText.setPosition(106, 198);
        startText.text = 'NEXT LEVEL';
        add(startText);
    }

    public function createStore () {
        this.visible = true;
        scene.powerups.visible = true;

        scene.powerups.add(new Powerup(powerupPosStart.x, powerupPosStart.y, Go));

        var points = scene.points;
        var tripsAdded = false;
        var doubleAdded = false;
        for (pUp in 0...3) {
            if (pUp == 0 && points > Powerup.dict[Double].cost) {
                doubleAdded = true;
                scene.powerups.add(new Powerup(powerupPos2.x, powerupPos2.y, Double));
            }

            // check 'next up' trips
            // if ((pUp == 0 || (pUp == 1 && doubleAdded)) && Powerup.dict[]) {
            // }

            // we add repair, shield and clears after this
        }
    }
}
