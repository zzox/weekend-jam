import flixel.FlxSprite;

class Explosion extends FlxSprite {
    public function new () {
        super(0, 0);

        loadGraphic(AssetPaths.explosion__png, true, 16, 16);

        animation.add('explode', [0, /*1,*/ 2, 3, 4, 5], 12, false);
        animation.finishCallback = finishAnimation;
    }

    public function explode (x:Float, y:Float) {
        setPosition(x, y);
        animation.play('explode');
    }

    function finishAnimation (animName:String) {
        if (animName == 'explode') {
            kill();
        }
    }
}