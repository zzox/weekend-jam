package display;

import flixel.FlxSprite;

class Explosion extends FlxSprite {
    public function new () {
        super(0, 0);

        loadGraphic(AssetPaths.explosion__png, true, 32, 32);

        animation.add('explode-small', [0, 1, 2, 3, 4], 12, false);
        animation.add('explode-medium', [0, 5, 6, 7, 8], 12, false);
        animation.finishCallback = finishAnimation;
    }

    /**
        Set with ship origin to origin so this explosion can be launched from the center
    **/
    public function explode (x:Float, y:Float, type:String) {
        setPosition(x - (width / 2), y - (height / 2));
        animation.play(type);
    }

    function finishAnimation (animName:String) {
        kill();
    }
}
