package {
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.net.SharedObject;
	import flash.media.Sound;
	
	public class Main extends MovieClip {
		var gravity:Number = 5;
		var objects:Array = [];
		var spawnInterval:Number = 1350;
		var speed:int = 7;
		var v:int = 0;
		var lives:int = 3;
		var score:int = 0;
		var debug:Boolean = false;
		var phw = 17.725;
		var reverse:Boolean = false;
		var flashing:Boolean = false;
		var flashCount:int = 0;
		var spawnTimer:Timer = new Timer(spawnInterval);
		var mobilemode:Boolean = false;
		var shopback:Boolean = false;
		var begin:Boolean = false;
		var sharedData:SharedObject;
		var highscore:int = 0;
		var explosionSound:Sound = new explosionwav();
		var gamePause:Boolean = false;
		var powerupSound:Sound = new powerupwav();
		public function Main() {
			spawnTimer.addEventListener(TimerEvent.TIMER, new_spike);
			spawnTimer.addEventListener(TimerEvent.TIMER, new_heart);
			spawnTimer.start();
			sharedData = SharedObject.getLocal("highScoreSO");
			highscore = sharedData.data.highScoreSO;
			addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, oKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, oKeyUp);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
									stage.focus = stage;
								});
			arrowleft.addEventListener(MouseEvent.MOUSE_DOWN, goLeft);
			arrowright.addEventListener(MouseEvent.MOUSE_DOWN, goRight);
			arrowleft.addEventListener(MouseEvent.MOUSE_UP, letGo);
			arrowright.addEventListener(MouseEvent.MOUSE_UP, letGo);
			retry.addEventListener(MouseEvent.MOUSE_UP, reset);
			shopbutton.addEventListener(MouseEvent.MOUSE_UP, shopScreen);
			mobile.addEventListener(MouseEvent.MOUSE_UP, mobileMode);
			shopbackbutton.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent) {
											shopback = true;
											}
			);
			startscreen.beginbutton.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent) {
													 begin = true;
													 startscreen.play();
													 stage.focus = stage;
													 });
			pausebutton.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent) {
											trace("test");
											if(gamePause && begin) {
												gamePause = false;
											} else if(!gamePause && begin) {
												gamePause = true;
											}
										});
			player.gotoAndStop(1);
			ink.stop();
			retry.stop();
			shopbutton.stop();
			shop.stop();
			shop.characters.stop();
			retry.selectable = false;
			versiontext.selectable = false;
			authortext.selectable = false;
			textscore.selectable = false;
			stage.quality = StageQuality.LOW;
			if(sharedData.data.highScoreSO == undefined) {
				sharedData.data.highScoreSO = 0;
			}

		}
		function shopScreen(e:MouseEvent):void {
			shop.play();
			shopbackbutton.play();
		}
		function reset(e:MouseEvent):void {
			lives = 3;
			reverse = true;
			spawnInterval = 1350;
			spawnTimer.delay = spawnInterval;
		}
		function mobileMode(e:MouseEvent):void {
			if(mobilemode == false) {
				arrowleft.play();
				arrowright.play();
				mobilemode = true;
			} else {
				mobilemode = false;
			}
		}
		function goRight(e:MouseEvent):void {
			stage.focus = stage;
			if(player.x + phw > stage.stageWidth) {
				player.x = stage.stageWidth - phw;
			}else if(player.x - phw < 0) {
				player.x = 0 + phw;
			}
			v = speed;
			player.scaleX = -1;
			player.play();
		}
		function goLeft(e:MouseEvent):void {
			stage.focus = stage;
			if(player.x + phw > stage.stageWidth) {
				player.x = stage.stageWidth - phw;
			}else if(player.x - phw < 0) {
				player.x = 0 + phw;
			}
			v = -speed;
			player.scaleX = 1;
			player.play();
		}
		function letGo(e:MouseEvent):void {
			v = 0;
			player.gotoAndStop(1);
		}
		function oKeyDown(e:KeyboardEvent):void {
			if(player.x + phw > stage.stageWidth) {
				player.x = stage.stageWidth - phw;
			}else if(player.x - phw < 0) {
				player.x = 0 + phw;
			} else if(!gamePause && lives > 0) {
				switch(e.keyCode) {
					case Keyboard.LEFT:
						v = -speed;
						player.scaleX = 1;
						player.play();
						break;
					case Keyboard.RIGHT:
						v = speed;
						player.scaleX = -1;
						player.play();
						break;
				}
			}
			switch(e.keyCode) {
				case Keyboard.ESCAPE:
					if(gamePause && begin && lives > 0) {
						gamePause = false;
					} else if(!gamePause && begin && lives > 0) {
						gamePause = true;
					}
			}
		}
		function oKeyUp(e:KeyboardEvent):void {
			v = 0;
			player.gotoAndStop(1);
		}
		function new_spike(e:TimerEvent):void {
			if(ink.currentFrame == 1 && debug == false && startscreen.currentFrame == 50 && !gamePause) {
				var NSpike:spikemc = new spikemc();
				var spawnX:Number = player.x;
				var minX:Number = Math.max(0, spawnX - 100);
				var maxX:Number = Math.min(stage.stageWidth, spawnX + 100);
				NSpike.x = Math.random() * (maxX - minX) + minX;
				NSpike.y = -61.5;
				NSpike.stop()
				addChild(NSpike);
				objects.push(NSpike);
			}
		}
		function new_heart(e:TimerEvent):void {
			if(Math.random() * 100 <= 3 && lives < 3 && !gamePause) {
				var NHeart:heartmc = new heartmc();
				var HspawnX:Number = player.x;
				var HminX:Number = Math.max(0, HspawnX - 100);
				var HmaxX:Number = Math.min(stage.stageWidth, HspawnX + 100);
				NHeart.x = Math.random() * (HmaxX - HminX) + HminX;
				addChild(NHeart);
				objects.push(NHeart);
			}
		}
		function update(e:Event):void {
			trace(stage.focus);
			if(!gamePause) {
				var reversePause:int = pausescreen.currentFrame - 1;
				pausescreen.gotoAndStop(reversePause);
				pausescreentext.gotoAndStop(reversePause);
			} else if(gamePause && pausescreen.currentFrame < 25) {
				pausescreen.play();
				pausescreentext.play();
			}
			if(stage.focus == null && begin && lives > 1) {
				gamePause = true;
			}
			if(begin && !gamePause) {
				if(score > sharedData.data.highScoreSO) {
					sharedData.data.highScoreSO = score;
				}
				if(player.x + phw > stage.stageWidth) {
					player.x = stage.stageWidth - phw;
				}else if(player.x - 19.2 < 0) {
					player.x = 0 + 19.2;
				}
				player.x += v;
				textscore.text = String(score);
				if(score % 25 == 0 && score > 0 && !flashing) {
					spawnInterval -= 125;
					spawnTimer.delay = spawnInterval;
					flashing = true;
					powerupSound.play();
				} else if(score % 25 != 0) {
					flashing = false;
					textscore.textColor = 0x000000;
				}
				if(flashing == true) {
					if(flashCount % 2 == 0 && score > 0) {
						textscore.textColor = 0xFFFFFF;
					} else {
						textscore.textColor = 0x000000;
					}
					flashCount++;
				}
				updateLives();
				for(var i:int = objects.length - 1; i >= 0; i--) {
					var obj:MovieClip = objects[i];
					setChildIndex(obj, 0);
					if(obj.currentFrame == 1) {
						obj.y += gravity;
					}
					if(obj.y > stage.stageHeight + 61) {
						if(contains(obj)) {
							removeChild(obj);
							objects.splice(i, 1);
							if(lives > 0) {
								score++;
							}
						}
					}
					if(player.hitTestObject(obj)) {
						if(obj is spikemc) {
							if(obj.currentFrame == 1) {
								lives--;
								explosionSound.play();
							}
							obj.play();
							if(contains(obj) && obj.currentFrame == 21) {
								removeChild(obj);
								objects.splice(i, 1);
							}
						} else if(obj is heartmc) {
							lives++;
							if(contains(obj)) {
								removeChild(obj);
								objects.splice(i, 1);
							}
						}
					}
					if(reverse) {
						if(contains(obj)) {
							removeChild(obj);
							objects.splice(i, 1);
						}
					}
				}
				if(ink.currentFrame == 50) {
					ink.stop();
					retry.stop();
					shopbutton.stop();
				}
				if(ink.currentFrame == 1) {
					reverse = false;
				}
				if(reverse == true) {
					var before:int = ink.currentFrame - 1;
					ink.gotoAndStop(before);
					ink.deathscoretext.text = String(score);
					ink.highscoretext.text = String(sharedData.data.highScoreSO);
					retry.gotoAndStop(before);
					shopbutton.gotoAndStop(before);
					if(ink.currentFrame < 31) {
						score = 0;
					}
				}
				if(mobilemode == false) {
					var before1:int = arrowleft.currentFrame - 1;
					arrowleft.gotoAndStop(before1);
					arrowright.gotoAndStop(before1);
				}
				if(shopback) {
					var before2:int = shop.currentFrame - 1;
					shop.gotoAndStop(before2);
					shopbackbutton.gotoAndStop(before2);
				}
			}
		}
		function updateLives():void {
			if(lives >= 3) {
				lives = 3
				hearts.gotoAndStop(1);
			} else if(lives == 2) {
				hearts.gotoAndStop(2);
			} else if(lives == 1) {
				hearts.gotoAndStop(3);
			} else {
				hearts.gotoAndStop(4);
				ink.play();
				retry.play();
				shopbutton.play();
				ink.deathscoretext.text = String(score);
				ink.highscoretext.text = String(sharedData.data.highScoreSO);
			}
		}
	}
}