package display;

import data.Constants as Const;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup;
import flixel.text.FlxBitmapText;
import openfl.Assets;

class HUD extends FlxGroup {
    static inline final SHIELD_COLOR = 0x0a89ff;
    static inline final HEALTH_START_COLOR = 0xffbb31;
    static inline final LOW_HEALTH_COLOR = 0xe03c28;
    static inline final LOW_HEALTH_AMOUNT = 21;
    static inline final BAR_START = 27;
    static inline final BAR_COUNT = 50;
    static inline final DIGITS_LENGTH = 8;

    var background:FlxSprite;
    var shieldContent:Array<FlxSprite>;
    var healthLabel:FlxSprite;
    var healthOutline:FlxSprite;
    var healthContent:Array<FlxSprite>;

    var scene:PlayState;

    var worldText:FlxBitmapText;
    var pointsText:FlxBitmapText;

    public var bannerText:FlxBitmapText;
    public var bannerBg:FlxSprite;

    public function new (scene:PlayState) {
        super();

        this.scene = scene;

        background = new FlxSprite(0, 0);
        background.makeGraphic(160, 15, Const.HUD_BACKGROUND_COLOR);
        add(background);

        // shield
        var shieldLabel = new FlxSprite(0, 1, AssetPaths.shield_label__png);
        shieldLabel.color = SHIELD_COLOR;
        add(shieldLabel);

        var shieldOutline = new FlxSprite(25, 1, AssetPaths.bar__png);
        shieldOutline.color = SHIELD_COLOR;
        add(shieldOutline);

        // health
        healthLabel = new FlxSprite(0, 8, AssetPaths.health_label__png);
        healthLabel.color = HEALTH_START_COLOR;
        add(healthLabel);

        healthOutline = new FlxSprite(25, 8, AssetPaths.bar__png);
        healthOutline.color = HEALTH_START_COLOR;
        add(healthOutline);

        shieldContent = [];
        healthContent = [];
        for (i in 0...BAR_COUNT) {
            var shieldContentItem = new FlxSprite(BAR_START + i, 3, AssetPaths.bar_digit__png);
            shieldContentItem.color = SHIELD_COLOR;
            shieldContentItem.visible = false;
            shieldContent.push(shieldContentItem);
            add(shieldContentItem);

            var healthContentItem = new FlxSprite(BAR_START + i, 10, AssetPaths.bar_digit__png);
            healthContentItem.color = HEALTH_START_COLOR;
            healthContentItem.visible = false;
            healthContent.push(healthContentItem);
            add(healthContentItem);
        }

        var textBytes = Assets.getText(AssetPaths.pixel3x5__fnt);
        var XMLData = Xml.parse(textBytes);
        var fontAngelCode = FlxBitmapFont.fromAngelCode(AssetPaths.pixel3x5__png, XMLData);

        var worldLabel = new FlxSprite(131, 1, AssetPaths.world_label__png);
        worldLabel.color = Const.TEXT_COLOR;
        add(worldLabel);

        worldText = new FlxBitmapText(fontAngelCode);
        worldText.setPosition(155, -4);
        worldText.color = Const.TEXT_COLOR;
        add(worldText);

        var pointsLabel = new FlxSprite(105, 8, AssetPaths.score_label__png);
        add(pointsLabel);

        pointsText = new FlxBitmapText(fontAngelCode);
        pointsText.setPosition(127, 3);
        add(pointsText);

        bannerBg = new FlxSprite(0, 112);
        bannerBg.makeGraphic(160, 13, 0xff211640);
        bannerBg.visible = false;
        add(bannerBg);

        bannerText = new FlxBitmapText(fontAngelCode);
        bannerText.setPosition(18, 110);
        bannerText.text = 'L E V E L  C O M P L E T E';
        bannerText.visible = false;
        add(bannerText);
    }

    override function update (elapsed:Float) {
        if (scene.player != null) {
            var shield = scene.player.shieldPoints;
            for (i in 0...shieldContent.length) {
                shieldContent[i].visible = i <= shield / 2;
            }

            var health = scene.player.hitPoints;
            var color = health < LOW_HEALTH_AMOUNT ? LOW_HEALTH_COLOR : HEALTH_START_COLOR;
            for (i in 0...healthContent.length) {
                healthContent[i].visible = i < health / 2;
                healthContent[i].color = color;
            }
            healthLabel.color = color;
            healthOutline.color = color;

            worldText.text = scene.worldIndex + 1 + '';
            pointsText.text = Utils.leftPad(scene.points, DIGITS_LENGTH);
        } else {
            var health = 0;
            var color = LOW_HEALTH_COLOR;
            for (i in 0...healthContent.length) {
                healthContent[i].visible = i < health / 2;
                healthContent[i].color = color;
            }
        }

        super.update(elapsed);
    }
}
