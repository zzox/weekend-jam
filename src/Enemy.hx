import flixel.FlxSprite;

enum EnemyPattern {
    Direct;
}

typedef PatternInfo = {
    var yVel:Float;
}

class Enemy extends FlxSprite {
    var pattern:EnemyPattern;

    public function new () {
        super(0, 0);

        loadGraphic(AssetPaths.small_red_twin__png, true, 16, 16);

        animation.add('idle', [0]);

        flipY = true;
    }

    public function start (x:Float, y:Float, pattern:EnemyPattern, info:PatternInfo) {
        this.x = x;
        this.y = y;

        offset.set(4, 4);
        setSize(8, 7);

        this.pattern = pattern;

        velocity.set(0, info.yVel);
    }

    override public function update (elapsed:Float) {
        animation.play('idle');
        super.update(elapsed);
    }
}