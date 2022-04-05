namespace BeefTweener
{
	public interface IEasing
	{
		public float In(float percent); //{ get; set mut; }//(float percent);
		public float Out(float percent); //{ get; set mut; }//(float percent);
		public float InOut(float percent); //{ get; set mut; }//(float percent);
	}
}
