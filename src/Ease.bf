using BeefTweener.Easings;
namespace BeefTweener
{
	public static class Ease
	{
		/// Sine ease set
		public static readonly IEasing Sine = new Sine() ~ delete _;

		/// Cubic ease set
		public static readonly IEasing Cubic = new Cubic() ~ delete _;

		/// Quintic ease set
		public static readonly IEasing Quint = new Quint() ~ delete _;

		/// Circlic ease set
		public static readonly IEasing Circle = new Circle() ~ delete _;

		/// "Elastic" ease set
		public static readonly IEasing Elastic = new Elastic() ~ delete _;

		/// Quadratic ease set
		public static readonly IEasing Quad = new Quad() ~ delete _;

		/// Quartic ease set
		public static readonly IEasing Quart = new Quart() ~ delete _;

		/// Exponential ease set
		public static readonly IEasing Expo = new Expo() ~ delete _;

		/// "Back" ease set
		public static readonly IEasing Back = new Back() ~ delete _;

		/// "Bounce" ease set
		public static readonly IEasing Bounce = new Bounce() ~ delete _;

		/// Linear ease equation
		public static float Linear(float percent)
		{
			return percent;
		}
	}
}
