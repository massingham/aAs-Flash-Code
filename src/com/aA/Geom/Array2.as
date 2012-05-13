package com.aA.Geom
{
	/**
	 * ...
	 * @author Anthony Massingham
	 */
	public class Array2
	{
		public static function removeItems(a:Array, v:Array):Array{
			for(var i:int=0; i<v.length; i++){
				remove(a, v[i]);
			}
			return a;
		}
		
		public static function remove(a:Array, v:*):Array{
		for (var i:int = 0; i<a.length; i++) {
			if (a[i] == v) {
				a.splice(i, 1);
				i--;
			}
		}
		return a;
	}
	}

}