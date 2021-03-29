import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Utils {
    static public function getSpriteCenter (sprite:FlxSprite):FlxPoint {
        return new FlxPoint(sprite.x + (sprite.width / 2), sprite.y + (sprite.height / 2));
    }

    static public function leftPad (number:Int, length:Int):String {
        var padding = '';
        for (_ in 0...length - '$number'.length) { padding += '0'; }
        return padding + number;
    }
}
