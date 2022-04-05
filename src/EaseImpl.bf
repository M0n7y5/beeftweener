using System;
namespace BeefTweener.Easings
{
	//Values taken from https://easings.net

	class BaseEasing : IEasing
	{
		CubicBezierEase inEase;
		CubicBezierEase outEase;
		CubicBezierEase inOutEase;

		typealias BezierInput = (float p1X, float p1Y, float p2X, float p2Y);

		[AllowAppend]
		public this(BezierInput _in, BezierInput _out, BezierInput _inOut)
		{
			var tmpIn = append CubicBezierEase(_in.p1X, _in.p1Y, _in.p2X, _in.p2Y);
			var tmpOut = append CubicBezierEase(_out.p1X, _out.p1Y, _out.p2X, _out.p2Y);
			var tmpInOut = append CubicBezierEase(_inOut.p1X, _inOut.p1Y, _inOut.p2X, _inOut.p2Y);

			inEase = tmpIn;
			outEase = tmpOut;
			inOutEase = tmpInOut;
		}

		[Inline]
		public float In(float percent) => inEase(percent);

		[Inline]
		public float Out(float percent) => outEase(percent);

		[Inline]
		public float InOut(float percent) => inOutEase(percent);
	}

	/// Implementation of Sine Ease
	class Sine : BaseEasing
	{
		[AllowAppend]
		public this()
			: base(
			(0.12f, 0f, 0.39f, 0f),
			(0.61f, 1f, 0.88f, 1f),
			(0.37f, 0f, 0f, 1f))
		{
		}
	}

	/// Implementation of Cubic Ease
	class Cubic : BaseEasing
	{
		[AllowAppend]
		public this()
			: base(
			(0.32f, 0f, 0.67f, 0f),
			(0.33f, 1f, 0.68f, 1f),
			(0.65f, 0f, 0.35f, 1f))
		{
		}
	}

	/// Implementation of Quint Ease
	class Quint : BaseEasing
	{
		[AllowAppend]
		public this()
			: base(
			(0.64f, 0f, 0.78f, 0f),
			(0.22f, 1f, 0.36f, 1f),
			(0.83f, 0f, 0.17f, 1f))
		{
		}
	}

	/// Implementation of Circle Ease
	class Circle : BaseEasing
	{
		[AllowAppend]
		public this()
			: base(
			(0.55f, 0f, 1f, 0.45f),
			(0f, 0.55f, 0.45f, 1f),
			(0.85f, 0f, 0.15f, 1f))
		{
		}
	}

	/// Implementation of "Elastic" Ease
	class Elastic : IEasing
	{
		[Inline]
		public float Out(float percent)
		{
			const let c4 = (2 * Math.PI_f) / 3;

			return percent === 0f
				? 0f
				: percent === 1
				? 1f
				: -Math.Pow(2f, 10f * percent - 10f) * Math.Sin((percent * 10f - 10.75f) * c4);
		}

		[Inline]
		public float In(float percent)
		{
			const let c4 = (2 * Math.PI_f) / 3;

			return percent === 0f
				? 0f
				: percent === 1
				? 1f
				: -Math.Pow(2f, -10f * percent) * Math.Sin((percent * 10f - 0.75f) * c4) + 1f;
		}

		[Inline]
		public float InOut(float percent)
		{
			const let c5 = (2f * Math.PI_f) / 4.5f;

			return percent === 0f
				? 0f
				: percent === 1f
				? 1f
				: percent < 0.5f
				? -(Math.Pow(2f, 20f * percent - 10f) * Math.Sin((20f * percent - 11.125f) * c5)) / 2f
				: (Math.Pow(2f, -20f * percent + 10f) * Math.Sin((20f * percent - 11.125f) * c5)) / 2f + 1f;
		}
	}


	/// Implementation of Quadratic Ease
	class Quad : BaseEasing
	{
		[AllowAppend]
		public this()
			: base(
			(0.11f, 0f, 0.5f, 0f),
			(0.5f, 1f, 0.89f, 1f),
			(0.45f, 0f, 0.55f, 1f))
		{
		}
	}

	/// Implementation of Quartic Ease
	class Quart : BaseEasing
	{
		[AllowAppend]
		public this()
			: base(
			(0.5f, 0f, 0.75f, 0f),
			(0.25f, 1f, 0.5f, 1f),
			(0.76f, 0f, 0.24f, 1f))
		{
		}
	}

	/// Implementation of Exponential Ease
	class Expo : BaseEasing
	{
		[AllowAppend]
		public this()
			: base(
			(0.7f, 0f, 0.84f, 0f),
			(0.16f, 1f, 0.3f, 1f),
			(0.87f, 0f, 0.13f, 1f))
		{
		}
	}

	/// Implementation of "Back" Ease
	class Back : BaseEasing
	{
		[AllowAppend]
		public this()
			: base(
			(0.36f, 0f, 0.66f, -0.56f),
			(0.34f, 1.56f, 0.64f, 1f),
			(0.68f, -0.6f, 0.32f, 1.6f))
		{
		}
	}

	/// Implementation of "Bounce" Ease
	class Bounce : IEasing
	{
		[Inline]
		public float Out(float percent)
		{
			var percent;
			const let n1 = 7.5625f;
			const let d1 = 2.75f;

			if (percent < 1f / d1)
			{
				return n1 * percent * percent;
			} else if (percent < 2f / d1)
			{
				return n1 * (percent -= 1.5f / d1) * percent + 0.75f;
			} else if (percent < 2.5f / d1)
			{
				return n1 * (percent -= 2.25f / d1) * percent + 0.9375f;
			} else
			{
				return n1 * (percent -= 2.625f / d1) * percent + 0.984375f;
			}
		}

		[Inline]
		public float In(float percent)
		{
			return 1 - Out(1 - percent);
		}

		[Inline]
		public float InOut(float percent)
		{
			return percent < 0.5f
				? (1f - Out(1f - 2f * percent)) / 2f
				: (1f + Out(2f * percent - 1f)) / 2f;
		}
	}
}
