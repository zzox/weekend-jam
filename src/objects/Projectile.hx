package objects;

import data.Weapons;
import flixel.FlxSprite;

typedef ProjOptions = {
    var ?flipXVel:Bool;
}

class Projectile extends FlxSprite {
    public var damage:Int;

    public function new () {
        super(0, 0);

        loadGraphic(AssetPaths.bullet__png, true, 16, 16);

        animation.add('small-player-bullet', [0, 1], 12);
        animation.add('small-player-ball', [2, 3], 12);
        animation.add('small-enemy-bullet', [4, 5], 12);
        animation.add('small-enemy-ball', [6, 7], 12);
    }

    public function shoot (xPos:Float, yPos:Float, weapon:Weapon, ?options:ProjOptions) {
        var leftFlip = 1;
        if (options != null && options.flipXVel) {
            leftFlip = -1;
        }

        setPosition(xPos, yPos);
        setSize(weapon.size.x, weapon.size.y);
        offset.set(weapon.offset.x, weapon.offset.y);
        animation.play(weapon.animName);
        velocity.set(weapon.velocity.x * leftFlip, weapon.velocity.y);
        damage = weapon.damage;
    }
}
