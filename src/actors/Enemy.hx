package actors;

import data.Constants as Const;
import data.Enemies;
import flixel.FlxSprite;

typedef PatternInfo = {
    var yVel:Float;
}

class Enemy extends FlxSprite {
    var pattern:EnemyPattern;
    var scene:PlayState;
    var name:String;
    public var points:Int;

    public function new (scene:PlayState) {
        super(0, 0);
        this.scene = scene;

        loadGraphic(AssetPaths.small_ships__png, true, 24, 24);

        animation.add("small-red-twin", [0, 1, 2], 12);
        animation.add("small-green-twin", [3, 4, 5], 12);
        animation.add("small-blue-squid", [6, 7, 8], 12);
    }

    public function start (x:Float, y:Float, type:EnemyType) {
        this.x = x;
        this.y = y;

        flipX = false;

        var enemyType = Enemies.data[type];
        offset.set(enemyType.offset.x, enemyType.offset.y);
        setSize(enemyType.size.x, enemyType.size.y);

        name = enemyType.name;
        points = enemyType.points;

        if (enemyType.pattern == Direct) {
            velocity.set(0, enemyType.yVel);
        } else if (enemyType.pattern == DirectXY) {
            var xDir = 1;
            if (x > Const.MIDPOINT_X) {
                flipX = true;
                xDir = -1;
            }

            velocity.set(enemyType.xVel * xDir, enemyType.yVel);
        }
    }

    override public function update (elapsed:Float) {
        animation.play(name);

        if (y > Const.BOTTOM_END) {
            scene.points -= points;
            kill();
        }

        super.update(elapsed);
    }

    override public function kill () {
        super.kill();
        scene.livingEnemies--;
    }
}
