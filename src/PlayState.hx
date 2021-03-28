package;

import display.HUD;
import flixel.tweens.FlxEase;
import actors.Player;
import actors.Enemy;
import data.Enemies;
import data.Structures;
import data.Waves;
import data.Weapons;
import display.Background;
import display.Explosion;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import objects.Projectile;

enum GameState {
    Playing;
    MainMenu;
}

class PlayState extends FlxState {
    static inline final ENEMY_POOL_SIZE = 100;
    static inline final PROJ_POOL_SIZE = 1000;
    static inline final EXPLOSION_POOL_SIZE = 20;
    static inline final PREROUND_TIME = 3;
    public static inline final PLAYER_START_X = 77;
    static inline final PLAYER_START_Y = 200;

    public var gameState:GameState;

    var background:Background;
    public var player:Player;
    var enemies:FlxTypedGroup<Enemy>;
    var projectiles:FlxTypedGroup<Projectile>;
    var explosions:FlxTypedGroup<Explosion>;

    var worldIndex:Int;
    var waveIndex:Int;
    var subwaveIndex:Int;
    var gameTime:Float;

    public var livingEnemies:Int;
    var subwavesDone:Bool;
    var levelComplete:Bool;

    var ambientSound:FlxSound;
    var waveSound:FlxSound;
    var loopTime:Float = 0.0;

    var hud:HUD;

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

        player = new Player(PLAYER_START_X, PLAYER_START_Y, this);
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
        for (_ in 0...PROJ_POOL_SIZE) {
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

        hud = new HUD(this);
        add(hud);

        gameState = MainMenu;
        ambientSound = FlxG.sound.play(AssetPaths.amb1__wav, 1.0, true);

        worldIndex = 0;
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if (gameState == Playing) {
            FlxG.overlap(enemies, player, overlapPlayerWithEnemy);
            FlxG.overlap(projectiles, enemies, overlapProjectileWithEnemy);

            loopTime += elapsed;

            handleEnemySpawn(elapsed);
        } else if (gameState == MainMenu) {
            if (FlxG.keys.anyJustPressed([SPACE, TAB, Z, X])) {
                startLevel();
            }
        }
    }

    function startLevel () {
        waveIndex = 0;
        subwaveIndex = 0;
        gameTime = -PREROUND_TIME;

        livingEnemies = 0;
        subwavesDone = false;
        levelComplete = false;

        player.weapons[0].reloadTime = Waves.convertBeatsToSeconds(1, Waves.data[worldIndex].bpm);
        trace(player.weapons[0].reloadTime);

        gameState = Playing;

        background.scrollTween(20);

        // TODO: transition sound
        FlxTween.tween(ambientSound, { volume: 0.0 }, 3.0);

        player.inControl = false;
        FlxTween.tween(player, { x: PLAYER_START_X }, 3.0, { ease: FlxEase.cubeOut });
        FlxTween.tween(player, { y: PLAYER_START_Y }, 3.0, { ease: FlxEase.cubeInOut, onComplete:
            (_:FlxTween) -> { player.inControl = true; }
        });

        var timer = new FlxTimer();
        timer.start(PREROUND_TIME, (_:FlxTimer) -> {
            waveSound = FlxG.sound.play(AssetPaths.int1__wav, 1, true);
            waveSound.onComplete = () -> loopTime = 0;
        });
    }

    function handleEnemySpawn (elapsed:Float) {
        gameTime += elapsed;

        if (levelComplete) return;

        var world = Waves.data[worldIndex];
        // if we haven't released all the subwaves, we check times here
        if (subwavesDone) {
            // start the next wave if there's no enemies left.
            // we have a negative gametime to start the next wave at the exact time the music loops.
            if (livingEnemies == 0) {
                subwavesDone = false;
                waveIndex++;
                subwaveIndex = 0;

                var loopLength = waveSound.length / 1000;
                gameTime = -(loopLength - loopTime);
                // if it's too short (less than a beat) we add a new loop.
                // WARN: Not 100% tested so a potential problem area.
                if (gameTime > -(Waves.convertBeatsToSeconds(1, world.bpm))) {
                    gameTime -= loopTime;
                }

                if (waveIndex == world.waves.length) {
                    levelComplete = true;
                    trace('level complete!!!');
                }
            }
        } else {
            var subwaveItem = world.waves[waveIndex][subwaveIndex];
            if (gameTime > Waves.convertBeatsToSeconds(subwaveItem.beats - 1, world.bpm)) {
                var enemyShape:Array<Int> = Structures.getStructure(subwaveItem.shape, subwaveItem.quantity);

                for (xPos in enemyShape) {
                    createEnemy(xPos, -(Waves.convertBeatsToSeconds(1, world.bpm) * 30), subwaveItem.type);
                }

                subwaveIndex++;

                // check to see enemyCount if we should go to the next wave
                if (subwaveIndex == world.waves[waveIndex].length) {
                    subwavesDone = true;
                }
            }
        }
    }

    function createEnemy (x:Int, y:Float, type:EnemyType) {
        livingEnemies++;
        var enemy = enemies.recycle(Enemy);
        enemy.start(x, y, type);
    }

    function overlapPlayerWithEnemy (enemy:Enemy, player:Player) {
        // TODO: don't kill enemy here, only if they've lost hitpoints
        createExplosion(Utils.getSpriteCenter(enemy));
        enemy.kill();

        if (!player.isHurt) {
            player.damage(10, 'body');
        }
    }

    function overlapProjectileWithEnemy (proj:Projectile, enemy:Enemy) {
        createExplosion(Utils.getSpriteCenter(enemy));
        enemy.kill();
        proj.kill();
    }

    public function shoot (x:Float, y:Float, weapon:WeaponType) {
        var proj = projectiles.recycle(Projectile);
        proj.shoot(x, y, weapon);
    }

    function createExplosion (point:FlxPoint) {
        var exp = explosions.recycle(Explosion);
        exp.explode(point.x, point.y);
    }
}
