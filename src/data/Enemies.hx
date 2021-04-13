package data;

import flixel.math.FlxPoint;

enum EnemyType {
    SmallRedTwin;
    SmallGreenTwin;
    SmallBlueSquid;
}

enum EnemyPattern {
    Direct;
    DirectXY;
}

typedef EnemyInfo = {
    var name:String;
    var points:Int;
    var hitPoints:Int;
    var collisionDamage:Int;
    var offset:FlxPoint;
    var size:FlxPoint;
    var pattern:EnemyPattern;
    var ?xVel:Int;
    var ?yVel:Int;
    var explosionType:String;
}

class Enemies {
    public static final data:Map<EnemyType, EnemyInfo> = [
        SmallRedTwin => {
            name: "small-red-twin",
            points: 100,
            hitPoints: 1,
            collisionDamage: 5,
            offset: new FlxPoint(8, 9),
            size: new FlxPoint(8, 4),
            pattern: Direct,
            yVel: 30,
            explosionType: 'explode-small'
        },
        SmallGreenTwin => {
            name: "small-green-twin",
            points: 250,
            hitPoints: 1,
            collisionDamage: 10,
            offset: new FlxPoint(8, 9),
            size: new FlxPoint(8, 4),
            pattern: Direct,
            yVel: 60,
            explosionType: 'explode-small'
        },
        SmallBlueSquid => {
            name: "small-blue-squid",
            points: 500,
            hitPoints: 1,
            collisionDamage: 12,
            offset: new FlxPoint(9, 10),
            size: new FlxPoint(7, 6),
            pattern: DirectXY,
            xVel: 30,
            yVel: 30,
            explosionType: 'explode-small'
        }
    ];
}

