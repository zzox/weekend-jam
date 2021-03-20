import flixel.FlxSprite;

class Projectile extends FlxSprite {
    public function new () {
        super(0, 0);

        loadGraphic(AssetPaths.bullet__png, true, 16, 16);
        setSize(2, 5);
        offset.set(7, 5);

        animation.add('small-bullet', [0, 1], 12);
    }

    public function shoot (xPos:Float, yPos:Float, xVel:Float = 0.0, yVel:Float = 0.0) {
        setPosition(xPos, yPos);
        animation.play('small-bullet');
        velocity.set(xVel, yVel);
    }
}