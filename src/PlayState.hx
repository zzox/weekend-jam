package;

import SoundEffects;
import flixel.FlxSprite;
import display.Banner;
import actors.Player;
import actors.Enemy;
import data.Enemies;
import data.Game;
import data.Structures;
import data.Waves;
import data.Weapons;
import display.Background;
import display.Explosion;
import display.HUD;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import objects.Projectile;
import objects.Powerup;

enum GameState {
    Playing;
    MainMenu;
    GameOver;
}

class PlayState extends FlxState {
    static inline final ENEMY_POOL_SIZE = 100;
    static inline final PROJ_POOL_SIZE = 1000;
    static inline final EXPLOSION_POOL_SIZE = 1000;
    public static inline final PLAYER_START_X = 77;
    static inline final PLAYER_START_Y = 200;
    static inline final PLAYER_RESPAWN_Y = 300;
    static inline final TRANSITION_TIME = 3.0;
    static inline final WAVE_DISPLAY_TIME = 1.5;
    static inline final POWERUP_MIDDLE = 6;

    public var gameState:GameState;
    var gameData:Game;

    var background:Background;
    public var player:Null<Player>;
    var enemies:FlxTypedGroup<Enemy>;
    var projectiles:FlxTypedGroup<Projectile>;
    var enemyProjectiles:FlxTypedGroup<Projectile>;
    var explosions:FlxTypedGroup<Explosion>;
    public var powerups:FlxTypedGroup<Powerup>;

    public var worldIndex:Int;
    var waveIndex:Int;
    var subwaveIndex:Int;
    var gameTime:Float;
    public var points:Int;

    public var livingEnemies:Int;
    var subwavesDone:Bool;

    var ambientSound:FlxSound;
    var waveSound:FlxSound;
    var loopTime:Float;
    var fadingOut:Bool;

    var hud:HUD;
    var banner:Banner;
    var logo:FlxSprite;

    var soundEffects:Null<SoundEffects>;

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

        background = new Background(this);
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

        enemyProjectiles = new FlxTypedGroup<Projectile>(PROJ_POOL_SIZE);
        var proj = new Projectile();
        for (_ in 0...PROJ_POOL_SIZE) {
            proj.kill();
            enemyProjectiles.add(proj);
        }
        add(enemyProjectiles);

        // powerups are under explosions, they last longer
        powerups = new FlxTypedGroup<Powerup>();
        add(powerups);

        explosions = new FlxTypedGroup<Explosion>(EXPLOSION_POOL_SIZE);
        for (_ in 0...EXPLOSION_POOL_SIZE) {
            var explo = new Explosion();
            explo.kill();
            explosions.add(explo);
        }
        add(explosions);

        hud = new HUD(this);
        hud.visible = false;
        add(hud);

        banner = new Banner();
        add(banner);

        gameState = MainMenu;
        ambientSound = FlxG.sound.play(AssetPaths.amb1__wav, 1.0, true);

        gameData = new Game(this);

        worldIndex = 0;
        points = 0;

        loopTime = 0;
        fadingOut = false;

        logo = new FlxSprite(46, 88, AssetPaths.clear_logo__png);
        add(logo);
    }

    override public function update(elapsed:Float) {
        soundEffects = new SoundEffects();
        super.update(elapsed);

        var anyKey:Bool = false;
        if (FlxG.keys.anyJustPressed([SPACE, TAB, Z, X])) {
            anyKey = true;
        }

        if (gameState == Playing) {
            FlxG.overlap(enemies, player, overlapPlayerWithEnemy);
            FlxG.overlap(projectiles, enemies, overlapProjectileWithEnemy);
            FlxG.overlap(enemyProjectiles, player, overlapEnemyProjectileWithPlayer);

            loopTime += elapsed;

            handleEnemySpawn(elapsed);

            handlePoints();
        } else if (gameState == MainMenu) {
            if (anyKey) {
                startLevel();
            }
        } else if (gameState == GameOver) {
            if (anyKey) {
                FlxG.switchState(new PlayState());
            }
        }

        soundEffects.playAll();
        soundEffects = null;
    }

    function startLevel () {
        waveIndex = 0;
        subwaveIndex = 0;
        gameTime = -TRANSITION_TIME;

        livingEnemies = 0;
        subwavesDone = false;

        gameState = Playing;

        tweenPlayerToCenter();

        FlxTween.tween(ambientSound, { volume: 0.0 }, TRANSITION_TIME);
        new FlxTimer().start(TRANSITION_TIME, (_:FlxTimer) -> {
            // allows `PlayWaveSound` to play the next song
            fadingOut = false;

            playWaveSound();
            banner.display('W A V E  1', WAVE_DISPLAY_TIME);
        });
        hud.visible = true;
        logo.visible = false;
    }

    function playWaveSound () {
        loopTime = 0;
        if (waveSound != null) {
            waveSound.stop();
        }

        if (Waves.data[worldIndex].songs[waveIndex] != null && !fadingOut) {
            waveSound = FlxG.sound.play(Waves.data[worldIndex].songs[waveIndex], 1, true);
            waveSound.onComplete = playWaveSound;
        }
    }

    function winLevel () {
        banner.display('L E V E L  C O M P L E T E', TRANSITION_TIME);

        // signifies to not play the next song yet.
        fadingOut = true;
        FlxTween.tween(waveSound, { volume: 0.0 }, TRANSITION_TIME / 2, { onComplete: (_:FlxTween) -> {
            waveSound.stop();
        } });
        worldIndex++;

        if (Waves.data[worldIndex] != null) {
            startLevel();
        } else {
            trace('Game won!');
        }
    }

    public function gameOver () {
        player = null;
        waveSound.stop();
        FlxTween.tween(waveSound, { volume: 0.0 }, TRANSITION_TIME);
        banner.display('G A M E  O V E R');

        new FlxTimer().start(TRANSITION_TIME / 2, (_:FlxTimer) -> {
            // show score
            // TODO: check high score?
            hud.visible = false;
        });

        new FlxTimer().start(TRANSITION_TIME, (_:FlxTimer) -> {
            gameState = GameOver;
            // TODO: game over music? or silence?
        });
    }

    function handleEnemySpawn (elapsed:Float) {
        gameTime += elapsed;

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
                    winLevel();
                } else {
                    var displayIndex = waveIndex + 1;
                    banner.display('W A V E  $displayIndex', WAVE_DISPLAY_TIME);
                }
            }
        } else {
            var subwaveItem = world.waves[waveIndex][subwaveIndex];
            if (gameTime > Waves.convertBeatsToSeconds(subwaveItem.beats - 1, world.bpm)) {
                var enemyShape:Array<Int> = Structures.getStructure(subwaveItem.shape, subwaveItem.quantity);

                for (xPos in enemyShape) {
                    var yVel = Enemies.data[subwaveItem.type].yVel;
                    createEnemy(xPos, -(Waves.convertBeatsToSeconds(1, world.bpm) * yVel) + HUD.HEIGHT, subwaveItem.type);
                }

                subwaveIndex++;

                // check to see enemyCount if we should go to the next subWave
                if (subwaveIndex == world.waves[waveIndex].length) {
                    subwavesDone = true;
                }
            }
        }
    }

    function handlePoints () {
        if (points < 0) {
            points = 0;
        }
    }

    function createEnemy (x:Int, y:Float, type:EnemyType) {
        livingEnemies++;
        var enemy = enemies.recycle(Enemy);
        enemy.start(x, y, type);
    }

    function overlapPlayerWithEnemy (enemy:Enemy, player:Player) {
        createExplosion(Utils.getSpriteCenter(enemy), enemy.explosionType);
        enemy.kill();
        livingEnemies--;

        // when overlapping an enemy, there are no iFrames
        player.damage(enemy.collisionDamage, BodyDamage);
    }

    function overlapProjectileWithEnemy (proj:Projectile, enemy:Enemy) {
        enemy.damage(proj.damage);
        proj.kill();
    }

    function overlapEnemyProjectileWithPlayer (proj:Projectile, player:Player) {
        // hurt iFrames
        if (!player.isHurt) {
            player.damage(proj.damage, ShieldDamage);
        }
        proj.kill();
    }

    public function destroyEnemy (enemy:Enemy) {
        var position = Utils.getSpriteCenter(enemy);
        createExplosion(position, enemy.explosionType);
        points += enemy.points;
        livingEnemies--;

        var results = gameData.checkPoints(points);
        if (results != null) {
            var displayPowerup = new Powerup(position.x - POWERUP_MIDDLE, position.y - POWERUP_MIDDLE, results);
            powerups.add(displayPowerup);
            displayPowerup.select();

            doPowerup(results);
        }

        if (enemy.type == SmallBlueSquid) {
            // if there's another powerup, show the new one above it
            var yPos = position.y - POWERUP_MIDDLE;
            if (results != null) {
                yPos = yPos + 16;
            }

            var displayPowerup = new Powerup(position.x - POWERUP_MIDDLE, yPos, Shield);
            powerups.add(displayPowerup);
            displayPowerup.select();

            doPowerup(Shield);
        }
    }

    public function shoot (x:Float, y:Float, weapon:WeaponType) {
        var bullet = Weapons.data[weapon];
        soundEffects.add(bullet.animName, 0.5);

        var proj = projectiles.recycle(Projectile);
        proj.shoot(x, y, bullet);

        if (bullet.style == PlayerTwoShots) {
            var proj = projectiles.recycle(Projectile);
            proj.shoot(x, y, bullet, { flipXVel: true });        
        }
    }

    public function enemyShoot (x:Float, y:Float, weapon:WeaponType) {
        var bullet = Weapons.data[weapon];
        soundEffects.add(bullet.animName, 0.5);

        var proj = enemyProjectiles.recycle(Projectile);
        proj.shoot(x, y, bullet);

        if (bullet.style == PlayerTwoShots) {
            var proj = enemyProjectiles.recycle(Projectile);
            proj.shoot(x, y, bullet, { flipXVel: true });
        }
    }

    public function createExplosion (point:FlxPoint, type:String) {
        soundEffects.add(type, 1.0);

        explosions.recycle(Explosion)
            .explode(point.x, point.y, type);
    }

    function tweenPlayerToCenter () {
        background.scrollTween(20);

        // TODO: transition sound
        FlxG.sound.play(AssetPaths.hyperspeed__wav, 0.5);

        player.inControl = false;
        FlxTween.tween(player, { x: PLAYER_START_X }, TRANSITION_TIME, { ease: FlxEase.cubeOut });
        FlxTween.tween(player, { y: PLAYER_START_Y }, TRANSITION_TIME, { ease: FlxEase.cubeInOut, onComplete:
            (_:FlxTween) -> {
                player.inControl = true;
            }
        });
    }

    function doPowerup(type:PowerupTypes) {
        var weaponType;
        switch (type) {
            case Double:
                for (wep in player.weapons) {
                    wep.reloadTime = wep.reloadTime / 2;
                }
                return;
            case Clear:
                return;
            case Shield:
                player.shieldPoints += 10;
                if (player.shieldPoints > 100) {
                    player.shieldPoints = 100;
                }
                return;
            case Repair:
                player.hitPoints += 25;
                if (player.hitPoints > 100) {
                    player.hitPoints = 100;
                }
                return;
            case ForwardTrips:
                weaponType = PlayerForwardTrips;
            case MidTrips:
                weaponType = PlayerMidTrips;
            case SideTrips:
                weaponType = PlayerSideTrips;
            case Backshoot:
                weaponType = PlayerBackshoot;
        }

        player.weapons.push({ type: weaponType, shootTime: 0, reloadTime: 1 });
    }
}
