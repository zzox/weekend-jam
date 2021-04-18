package display;

import data.Waves;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.FlxTweenType;

enum BGItemType {
    Star;
}

class Background extends FlxGroup {
    // TODO: move to constants
    static inline final STAR_TOP_Y = -32;
    static inline final STAR_BOTTOM_Y = 480; // longer to have less repetition
    static inline final LEFTMOST_X = -32;
    static inline final RIGHTMOST_X = 192;
    var scene:PlayState;

    var stars:Array<BackgroundItem>;

    public function new (scene) {
        super();
        // MD: stars and background stuff
        var starsNum = 200;

        this.scene = scene;

        stars = [];
        for (i in 0...starsNum) {
            var starName = '';
            if (i <= 50) {
                starName = 'far-star';
            } else if (i > 50 && i < 180) {
                starName = 'small-star';
            } else if (i < 190) {
                starName = 'pink-star';
            } else {
                starName = 'star-twinkle';
            }

            var bgItem = new BackgroundItem(
                LEFTMOST_X + Math.random() * (RIGHTMOST_X - LEFTMOST_X),
                STAR_TOP_Y + Math.random() * (STAR_BOTTOM_Y - STAR_TOP_Y),
                Star,
                starName
            );

            bgItem.visible = false;

            add(bgItem);
            stars.push(bgItem);
        }
    }

    /**
        speed up and slow down background to make it look like speeding through space
    **/
    public function scrollTween (mulitplier:Int) {
        // ping pong each from current velocity to a faster (2x?) and back
        for (star in stars) {
            FlxTween.tween(
                star,
                { "velocity.y": star.velocity.y * mulitplier },
                2,
                {
                    type: FlxTweenType.PINGPONG,
                    ease: FlxEase.cubeInOut,
                    onComplete: (t:FlxTween) -> t.executions == 2 ? t.cancel() : null
                }
            );
        }
    }

    override function update (elapsed:Float) {
        for (star in stars) {
            if (star.y > STAR_BOTTOM_Y) {
                var world = Waves.data[scene.worldIndex];
                if (world.visibleStars.indexOf(star.name) > -1) {
                    star.visible = true;
                } else {
                    star.visible = false;
                }

                star.y = star.y - (STAR_BOTTOM_Y - STAR_TOP_Y);
            }

            // not sure why this is required
            star.update(elapsed);
        }
    }
}

class BackgroundItem extends FlxSprite {
    static inline final STAR_SPEED_MAX = 30;
    public var name:String;

    public function new (x:Float, y:Float, type:BGItemType, name:String) {
        super(x, y);
        this.name = name;

        if (type == Star) {
            var twinkleLength:Int = Math.floor(10 + Math.random() * 20);
            var twinkle:Array<Int> = [];
            for (_ in 0...twinkleLength) twinkle.push(0);
            twinkle.push(1);

            loadGraphic(AssetPaths.stars__png, true, 4, 4);
            animation.add('small-star', [0]);
            animation.add('star-twinkle', twinkle, 3);
            animation.add('far-star', [2]);
            animation.add('pink-star', [3]);
            animation.play(name);

            velocity.set(0, Math.random() * STAR_SPEED_MAX);
        }
    }
}
