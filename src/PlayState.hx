package;

import actors.Player;
import actors.Enemy;
import data.Constants as Const;
import data.Enemies;
import data.Structures;
import data.Waves;
import display.Background;
import display.Explosion;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import objects.Projectile;

class PlayState extends FlxState {
    static inline final ENEMY_POOL_SIZE = 100;
    static inline final PROJ_POOL_SIZE = 100;
    static inline final EXPLOSION_POOL_SIZE = 20;
    static inline final PREROUND_TIME = 3;

    var background:Background;
    var player:Player;
    var enemies:FlxTypedGroup<Enemy>;
    var projectiles:FlxTypedGroup<Projectile>;
    var explosions:FlxTypedGroup<Explosion>;

    var worldName:String;
    var waveIndex:Int;
    var subwaveIndex:Int;
    var gameTime:Float;

    public var livingEnemies:Int;
    var subwavesDone:Bool;
    var levelComplete:Bool;

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

        background = new Background();
        add(background);
        background.scrollTween(10);

        player = new Player(77, 200, this);
        add(player);
        add(player.horizontalFlames);
        add(player.verticalFlames);

        enemies = new FlxTypedGroup<Enemy>(ENEMY_POOL_SIZE);
        for (_ in 0...ENEMY_POOL_SIZE) {
            var enemy = new Enemy(this);
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

        worldName = "space-1"; // MD: pass into state
        waveIndex = 0;
        subwaveIndex = 0;
        gameTime = -PREROUND_TIME;

        livingEnemies = 0;
        subwavesDone = false;

        levelComplete = false;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        FlxG.overlap(enemies, player, overlapPlayerWithEnemy);
        FlxG.overlap(projectiles, enemies, overlapProjectileWithEnemy);

        handleEnemySpawn(elapsed);
    }

    function handleEnemySpawn (elapsed:Float) {
        gameTime += elapsed;

        if (levelComplete) return;

        // if we haven't released all the subwaves, we check times here
        if (subwavesDone) {
            if (livingEnemies == 0) {
                subwavesDone = false;
                waveIndex++;
                subwaveIndex = 0;
                gameTime = 0;

                if (waveIndex == Waves.data[worldName].length) {
                    levelComplete = true;
                    trace('level complete!!!');
                }
            }
        } else {
            var subwaveItem = Waves.data[worldName][waveIndex][subwaveIndex];
            if (gameTime > subwaveItem.time) {
                var enemyShape:Array<Int> = Structures.getStructure(subwaveItem.shape, subwaveItem.quantity);

                for (xPos in enemyShape) {
                    createEnemy(xPos, Const.ENEMY_START_Y, subwaveItem.type);
                }

                subwaveIndex++;

                // check to see enemyCount if we should go to the next wave
                if (subwaveIndex == Waves.data[worldName][waveIndex].length) {
                    subwavesDone = true;
                }
            }
        }
    }

    function createEnemy (x:Int, y:Int, type:EnemyType) {
        livingEnemies++;
        var enemy = enemies.recycle(Enemy);
        enemy.start(x, y, type);
    }

    function overlapPlayerWithEnemy (enemy:Enemy, player:Player) {
        createExplosion(Utils.getSpriteCenter(enemy));
        createExplosion(Utils.getSpriteCenter(player));
        enemy.kill();
        player.kill();
    }

    function overlapProjectileWithEnemy (proj:Projectile, enemy:Enemy) {
        createExplosion(Utils.getSpriteCenter(enemy));
        enemy.kill();
        proj.kill();
    }

    public function shoot (x:Float, y:Float, velocity:Float) {
        var proj = projectiles.recycle(Projectile);
        proj.shoot(x, y, 0, -velocity); // TODO: different shoot types
    }

    function createExplosion (point:FlxPoint) {
        var exp = explosions.recycle(Explosion);
        exp.explode(point.x, point.y);
    }
}
