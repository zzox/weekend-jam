package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.PixelPerfectScaleMode;

class PlayState extends FlxState {
    static inline final ENEMY_POOL_SIZE = 10;
    static inline final PROJ_POOL_SIZE = 100;
    static inline final EXPLOSION_POOL_SIZE = 20;

    var player:Player;
    var enemies:FlxTypedGroup<Enemy>;
    var projectiles:FlxTypedGroup<Projectile>;
    var explosions:FlxTypedGroup<Explosion>;

    override public function create() {
        super.create();

        // PROD: remove this vvv
        // requires `-debug` flag
        FlxG.debugger.visible = true;
        FlxG.debugger.drawDebug = true;

        FlxG.mouse.visible = false;

        camera.pixelPerfectRender = true;
        FlxG.scaleMode = new PixelPerfectScaleMode();

        bgColor = 0xff151515;

        player = new Player(120, 120, this);
        add(player);

        enemies = new FlxTypedGroup<Enemy>(ENEMY_POOL_SIZE);
        for (_ in 0...ENEMY_POOL_SIZE) {
            var enemy = new Enemy();
            enemy.kill();
            enemies.add(enemy);
        }
        add(enemies);

        projectiles = new FlxTypedGroup<Projectile>(PROJ_POOL_SIZE);
        for (_ in 0...ENEMY_POOL_SIZE) {
            var proj = new Projectile();
            proj.kill();
            projectiles.add(proj);
        }
        add(projectiles);

        explosions = new FlxTypedGroup<Explosion>(EXPLOSION_POOL_SIZE);
        for (_ in 0...EXPLOSION_POOL_SIZE) {
            var explo = new Explosion();
            explo.kill();
            explosions.add(explo);
        }
        add(explosions);

        createEnemy();
        createEnemy();
        createEnemy();
        createEnemy();
        createEnemy();
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        FlxG.overlap(enemies, player, overlapPlayerWithEnemy);
        FlxG.overlap(projectiles, enemies, overlapProjectileWithEnemy);
    }

    function createEnemy () {
        var enemy = enemies.recycle(Enemy);
        enemy.start(Math.random() * 120 + 20, -32, Direct, { yVel: 60 });
    }

    function overlapPlayerWithEnemy (enemy:Enemy, player:Player) {
        enemy.kill();
        createExplosion(Utils.getSpriteCenter(enemy));
        player.kill();
        createExplosion(Utils.getSpriteCenter(player));
    }

    function overlapProjectileWithEnemy (proj:Projectile, enemy:Enemy) {
        proj.kill();
        createExplosion(Utils.getSpriteCenter(enemy));
        enemy.kill();
    }

    public function shoot (x:Float, y:Float, velocity:Float) {
        var proj = projectiles.recycle(Projectile);
        proj.shoot(x, y, null, -velocity);
    }

    public function createExplosion (point:FlxPoint) {
        var exp = explosions.recycle(Explosion);
        exp.explode(point.x, point.y);
    }
}
