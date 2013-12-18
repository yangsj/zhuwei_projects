package com.ryanliu.geom 
{
	/**
	 * @author Ryan Liu | www.ryan-liu.com
	 * @since 2009-3-19 22:41
	 */
	public class SimpleParticle2D 
	{
		public var x:Number
		public var y:Number
		public var vx:Number
		public var vy:Number
		public var mass:Number
		
		public function SimpleParticle2D(particleX:Number = 0, particleY:Number = 0, speedX:Number = 0, speedY:Number = 0, pMass:Number = 1) 
		{
			x = particleX
			y = particleY
			vx = speedX
			vy = speedY
			mass = pMass
		}
		public function update() {
			x += vx
			y += vy
		}
	}
}