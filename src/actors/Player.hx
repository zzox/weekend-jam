package actors;

import data.Constants as Const;
import flixel.FlxSprite;
import flixel.FlxG;

typedef HoldsObj = {
    var left:Float;
    var right:Float;
    var up:Float;
    var down:Float;
}

class Player extends FlxSprite {
    var scene:PlayState;
    var holds:HoldsObj;

    var shootTime:Float;

    static inline final ACCELERATION = 1200;

    // TODO: MD: for each weapon
    static inline final BULLET_RELOAD_TIME = 0.2;
    static inline final SHOOT_VELOCITY = 240;

    public function new (x:Float, y:Float, scene:PlayState) {
        super(x, y);
        this.scene = scene;

        loadGraphic(AssetPaths.player_ship__png, true, 16, 16);
        offset.set(5, 5);
        setSize(6, 6);

        animation.add('fly', [0]);

        holds = {
            left: 0,
            right: 0,
            up: 0,
            down: 0
        };

        drag.set(1800, 1200);
        maxVelocity.set(180, 120);

        shootTime = 0;
    }

    override public function update (elapsed:Float) {
        animation.play('fly');

        handleInputs(elapsed);
        shootTime -= elapsed;

        handleBumpers();

        super.update(elapsed);
    }

    // TODO: should logic go in playState?
    function handleInputs (elapsed:Float) {
        var upDownVel:Float = 0.0;
        var leftRightVel:Float = 0.0;

        if (FlxG.keys.pressed.LEFT) {
            leftRightVel = -1;
            holds.left += elapsed;
        } else {
            holds.left = 0;
        }

        if (FlxG.keys.pressed.RIGHT) {
            leftRightVel = 1;
            holds.right += elapsed;
        } else {
            holds.right = 0;
        }

        if (FlxG.keys.pressed.LEFT && FlxG.keys.pressed.RIGHT) {
            if (holds.right > holds.left) {
                leftRightVel = -1;
            } else {
                leftRightVel = 1;
            }
        }

        if (FlxG.keys.pressed.UP) {
            upDownVel = -1;
            holds.up += elapsed;
        } else {
            holds.up = 0;
        }

        if (FlxG.keys.pressed.DOWN) {
            upDownVel = 1;
            holds.down += elapsed;
        } else {
            holds.down = 0;
        }

        if (FlxG.keys.pressed.UP && FlxG.keys.pressed.DOWN) {
            if (holds.down > holds.up) {
                upDownVel = -1;
            } else {
                upDownVel = 1;
            }
        }

        acceleration.set(leftRightVel * ACCELERATION * 1.5, upDownVel * ACCELERATION);

        if (FlxG.keys.anyPressed([SPACE, Z]) && shootTime < 0) {
            scene.shoot(x + (getHitbox().width / 2) - 1, y, SHOOT_VELOCITY);
            shootTime = BULLET_RELOAD_TIME;
        }
    }

    function handleBumpers () {
        if (x < Const.LEFT_BUMPER) {
            x = Const.LEFT_BUMPER;
        }

        if (x > Const.RIGHT_BUMPER) {
            x = Const.RIGHT_BUMPER;
        }

        if (y < Const.TOP_BUMPER) {
            y = Const.TOP_BUMPER;
        }

        if (y > Const.BOTTOM_BUMPER) {
            y = Const.BOTTOM_BUMPER;
        }
    }
}