package objects;

import data.Weapons;
import flixel.FlxSprite;

class Projectile extends FlxSprite {
    public function new () {
        super(0, 0);

        loadGraphic(AssetPaths.bullet__png, true, 16, 16);

        animation.add('small-player-bullet', [0, 1], 12);
        animation.add('small-player-ball', [2, 3], 12);
    }

    public function shoot (xPos:Float, yPos:Float, weapon:WeaponType) {
        var bullet = Weapons.data[weapon];

        setSize(bullet.size.x, bullet.size.y);
        offset.set(bullet.size.x, bullet.size.y);
        setPosition(xPos, yPos);
        animation.play(bullet.animName);
        velocity.set(bullet.velocity.x, bullet.velocity.y);
    }
}
