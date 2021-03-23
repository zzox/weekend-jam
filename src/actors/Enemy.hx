package actors;

import data.Constants as Const;
import flixel.FlxSprite;

enum EnemyPattern {
    Direct;
}

typedef PatternInfo = {
    var yVel:Float;
}

class Enemy extends FlxSprite {
    var pattern:EnemyPattern;
    var scene:PlayState;
    var type:String;

    public function new (scene:PlayState) {
        super(0, 0);
        this.scene = scene;

        loadGraphic(AssetPaths.small_ships__png, true, 24, 24);

        animation.add("small-red-twin", [0, 1, 2], 12);

        flipY = true;
    }

    public function start (x:Float, y:Float, type:String, pattern:EnemyPattern, info:PatternInfo) {
        this.x = x;
        this.y = y;

        offset.set(8, 8);
        setSize(8, 7);

        this.pattern = pattern;
        this.type = type;

        velocity.set(0, info.yVel);
    }

    override public function update (elapsed:Float) {
        animation.play(type);

        if (y > Const.BOTTOM_END) {
            kill();
        }

        super.update(elapsed);
    }

    override public function kill () {
        super.kill();
        scene.livingEnemies--;
    }
}
