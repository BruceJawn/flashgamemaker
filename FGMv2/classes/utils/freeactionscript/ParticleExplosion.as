/**
 * Dynamic Particle Explosions
 *
 * Version: 	1.0
 * Author: 	Philip Radvan
 * URL: 		http://www.freeactionscript.com
 */
package utils.freeactionscript
{
	//import bitmap class
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	
	
	public class ParticleExplosion extends Sprite{
		//Settings
		var particleMaxSpeed:Number = 5;
		var particleFadeSpeed:Number = 5;
		var particleTotal:Number = 25;
		var particleRange:Number = 100;
		var internal_holder:MovieClip;
		public function ParticleExplosion($targetX:Number, $targetY:Number){
			_initVar();
			_createExplosion($targetX, $targetY);
		}
		//------ Init Var ------------------------------------
		private function _initVar($targetX:Number, $targetY:Number):void{
			internal_holder = new MovieClip;
		}
		/**
		 * createExplosion(target X position, target Y position)
		 */
		private function _createExplosion($targetX:Number, $targetY:Number):void{
		var particle_mc;
		var myBmp:Bitmap;
		//run for loop based on particleTotal
		for (var i:Number = 0; i<particleTotal; i++) {
			//create the "main_holder" movieclip that will hold our bitmap
			particle_mc = new MovieClip;
			myBmp = new ParticleFire;
			particle_mc.addChild(myBmp);
			
			//set "internal_holder" x and y position based on bitmap size
			myBmp.x = -myBmp.width/2;
			myBmp.y = -myBmp.height/2;	
			
			//set position & rotation, alpha
			particle_mc.x = targetX
			particle_mc.y = targetY
			particle_mc.rotation = Math.random()*360;
			particle_mc.alpha = Math.random()*50+50;
			
			//set particle boundry            
			particle_mc.boundyLeft = targetX - particleRange;
			particle_mc.boundyTop = targetY - particleRange;
			particle_mc.boundyRight = targetX + particleRange;
			particle_mc.boundyBottom = targetY + particleRange;
			
			//set speed/direction of fragment
			particle_mc.speedX = Math.random(particleMaxSpeed)-Math.random(particleMaxSpeed);
			particle_mc.speedY = Math.random(particleMaxSpeed)-Math.random(particleMaxSpeed);		
			particle_mc.speedX *= particleMaxSpeed
			particle_mc.speedY *= particleMaxSpeed
			
			//set fade out speed
			particle_mc.fadeSpeed = Math.random(particleFadeSpeed)*particleFadeSpeed;
			
			//just a visual particle counter
			numberOfParticles++;
			
			//make fragment move using onEnterFrame
			particle_mc.onEnterFrame = function():Void 
			{
				//update alpha, x, y
				this._alpha -= this.fadeSpeed;
				this._x += this.speedX;
				this._y += this.speedY;
				//if fragment is invisible or out of bounds, remove it
				if (this._alpha <= 0 ||	this._x < this.boundyLeft || this._x > this.boundyRight || this._y < this.boundyTop || this._y > this.boundyBottom) 
				{
					this.removeMovieClip();
					//
					numberOfParticles--;
				}
			}
		}
	}
}