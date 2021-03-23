import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Utils {
    static public function getSpriteCenter (sprite:FlxSprite):FlxPoint {
        return new FlxPoint(sprite.x + (sprite.width / 2), sprite.y + (sprite.height / 2));
    }
}
