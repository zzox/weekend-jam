package display;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

class HUD extends FlxGroup {
    static inline final SHIELD_COLOR = 0x0a89ff;
    static inline final HEALTH_START_COLOR = 0xffbb31;
    static inline final LOW_HEALTH_COLOR = 0xe3c28;
    static inline final LOW_HEALTH_AMOUNT = 20;
    static inline final BAR_START = 27;
    static inline final BAR_COUNT = 50;

    var background:FlxSprite;
    var shieldContent:Array<FlxSprite>;
    var healthLabel:FlxSprite;
    var healthOutline:FlxSprite;
    var healthContent:Array<FlxSprite>;

    var scene:PlayState;

    public function new (scene:PlayState) {
        super();

        this.scene = scene;

        background = new FlxSprite(0, 0);
        background.makeGraphic(160, 15, 0xff211640);
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
    }

    override function update (elapsed:Float) {
        var shield = scene.player.shieldPoints;
        for (i in 0...shieldContent.length) {
            shieldContent[i].visible = i <= shield / 2;
        }

        var health = scene.player.hitPoints;
        var color = health < LOW_HEALTH_AMOUNT ? LOW_HEALTH_COLOR : HEALTH_START_COLOR;
        for (i in 0...healthContent.length) {
            healthContent[i].visible = i <= health / 2;
            healthContent[i].color = color;
        }

        super.update(elapsed);
    }
}
