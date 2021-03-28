package data;

import flixel.math.FlxPoint;

enum WeaponType {
    PlayerBullet;
    PlayerBall;
}

typedef Weapon = {
    var reloadTime:Float; // how long until we can shoot again
    var animName:String;
    var size:FlxPoint;
    var offset:FlxPoint;
    var velocity:FlxPoint;
}

class Weapons {
    public static final data:Map<WeaponType, Weapon> = [
        PlayerBullet => {
            reloadTime: 1,
            animName: 'small-player-bullet',
            size: new FlxPoint(2, 5),
            offset: new FlxPoint(7, 5),
            velocity: new FlxPoint(0, 240)
        },
        PlayerBall => {
            reloadTime: 1,
            animName: 'small-player-ball',
            size: new FlxPoint(2, 2),
            offset: new FlxPoint(7, 7),
            velocity: new FlxPoint(60, 240)
        }
    ];
}