package actors;

import data.Constants as Const;
import data.Enemies;
import data.Waves;
import flixel.FlxSprite;

typedef PatternInfo = {
    var yVel:Float;
}

class Enemy extends FlxSprite {
    static inline final HURT_TIME = 1.0;
    static inline final HURT_COLOR = 0xffbb311;
    static inline final CLEAR = 0xffffff;
    static final HURT_FLASHES:Array<Int> = [0, 0, 1, 1, 1, 1];

    var pattern:EnemyPattern;
    var scene:PlayState;
    var name:String;
    public var points:Int;
    var hitPoints:Int;
    public var collisionDamage:Int;
    public var explosionType:String;
    var shooters:Array<Shooter>;
    var time:Float;
    var isHurt:Bool;
    var hurtTime:Float;
    var hurtFlashIndex:Int;

    public function new (scene:PlayState) {
        super(0, 0);
        this.scene = scene;

        loadGraphic(AssetPaths.small_ships__png, true, 24, 24);

        animation.add("small-red-twin", [0, 1, 2], 12);
        animation.add("small-green-twin", [3, 4, 5], 12);
        animation.add("small-blue-squid", [6, 7, 8], 12);
        animation.add("red-twin-shooter", [9, 10, 11], 12);
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
        hitPoints = enemyType.hitPoints;
        collisionDamage = enemyType.collisionDamage;
        explosionType = enemyType.explosionType;
        shooters = enemyType.shooters != null ? enemyType.shooters.copy() : [];

        // needed to sync offset to beat, since offset is never updated
        for (shooter in shooters) {
            shooter.offset = Waves.convertBeatsToSeconds(shooter.offset, Waves.data[scene.worldIndex].bpm);
        }

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

        hurtFlashIndex = 0;
    }

    override public function update (elapsed:Float) {
        animation.play(name);

        if (y > Const.BOTTOM_END) {
            scene.points -= points;
            scene.livingEnemies--;
            kill();
        }

        for (shooter in shooters) {
            shooter.offset -= elapsed;
            if (shooter.offset < 0) {
                shooter.shootTime -= elapsed;

                if (shooter.shootTime < 0) {
                    scene.enemyShoot(x + shooter.position.x, y + shooter.position.y, shooter.type);
                    shooter.shootTime += Waves.convertBeatsToSeconds(shooter.reloadTime, Waves.data[scene.worldIndex].bpm);
                }
            }
        }

        if (isHurt) {
            if (hurtTime > 0) {
                hurtTime -= elapsed;

                hurtFlashIndex = (hurtFlashIndex + 1) % HURT_FLASHES.length;

                color = HURT_FLASHES[hurtFlashIndex] == 1 ? HURT_COLOR : CLEAR;
            } else {
                isHurt = false;
                hurtFlashIndex = 0;
                color = CLEAR;
            }
        }

        super.update(elapsed);
    }

    public function damage (pts:Int) {
        hitPoints -= pts;
        if (hitPoints <= 0) {
            scene.destroyEnemy(this);
            this.kill();
        } else {
            isHurt = true;
            hurtTime = HURT_TIME; // may be needed to make dynamic in the future
        }
    }
}
