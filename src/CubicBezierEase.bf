using System;
namespace BeefTweener
{
	// ported from https://github.com/gre/bezier-easing/blob/master/src/index.js
	public class CubicBezierEase
	{
		const int NEWTON_ITERATIONS = 4;
		const float NEWTON_MIN_SLOPE = 0.001f;
		const float SUBDIVISION_PRECISION = 0.0000001f;
		const int SUBDIVISION_MAX_ITERATIONS = 10;

		const int kSplineTableSize = 11;
		const float kSampleStepSize = 1.0f / (kSplineTableSize - 1.0f);

		float[] sampleValues;

		float mX1, mY1, mX2, mY2;

		[AllowAppend]
		public this(float pX1, float pY1, float pX2, float pY2)
		{
			var table = append float[kSplineTableSize];
			sampleValues = table;

			this.mX1 = pX1;
			this.mY1 = pY1;
			this.mX2 = pX2;
			this.mY2 = pY2;

			for (var i = 0; i < kSplineTableSize; ++i)
			{ // lookup table
				table[i] = calcBezier(i * kSampleStepSize, mX1, mX2);
			}
		}

		public float Invoke(float percent)
		{
			if (mX1 == mY1 && mX2 == mY2)
			{
				return LinearEasing(percent);
			}
			else if (percent == 0 || percent == 1)
			{
				return percent;
			}
			// Finish
			return calcBezier(getTForX(percent), (.)mY1, (.)mY2);
		}

		float A(float aA1, float aA2)
		{
			return 1.0f - 3.0f * aA2 + 3.0f * aA1;
		}

		float B(float aA1, float aA2)
		{
			return 3.0f * aA2 - 6.0f * aA1;
		}

		float C(float aA1)
		{
			return 3.0f * aA1;
		}

		// Returns x(t) given t, x1, and x2, or y(t) given t, y1, and y2.
		private float calcBezier(float aT, float aA1, float aA2)
		{
			return ((A(aA1, aA2) * aT + B(aA1, aA2)) * aT + C(aA1)) * aT;
		}

		// Returns dx/dt given t, x1, and x2, or dy/dt given t, y1, and y2.
		float getSlope(float aT, float aA1, float aA2)
		{
			return 3.0f * A(aA1, aA2) * aT * aT + 2.0f * B(aA1, aA2) * aT + C(aA1);
		}

		float binarySubdivide(float aX, float aA, float aB, float mX1, float mX2)
		{
			float currentX, currentT, i = 0;
			var aB, aA;
			repeat
			{
				currentT = aA + (aB - aA) / 2.0f;
				currentX = calcBezier(currentT, mX1, mX2) - aX;
				if (currentX > 0.0f)
				{
					aB = currentT;
				} else
				{
					aA = currentT;
				}
			} while (Math.Abs(currentX) > SUBDIVISION_PRECISION && ++i < SUBDIVISION_MAX_ITERATIONS);
			return currentT;
		}

		float newtonRaphsonIterate(float aX, float aGuessT, float mX1, float mX2)
		{
			var aGuessT;

			for (var i = 0; i < NEWTON_ITERATIONS; ++i)
			{
				var currentSlope = getSlope(aGuessT, mX1, mX2);
				if (currentSlope == 0.0)
				{
					return aGuessT;
				}
				var currentX = calcBezier(aGuessT, mX1, mX2) - aX;
				aGuessT -= currentX / currentSlope;
			}
			return aGuessT;
		}

		float LinearEasing(float x)
		{
			return x;
		}

		float getTForX(float aX)
		{
			float intervalStart = 0.0f;
			int currentSample = 1;
			float lastSample = kSplineTableSize - 1;

			for (; currentSample != lastSample && sampleValues[currentSample] <= aX; ++currentSample)
			{
				intervalStart += kSampleStepSize;
			}
			--currentSample;

			// Interpolate to provide an initial guess for t
			var dist = (aX - sampleValues[currentSample]) / (sampleValues[currentSample + 1] - sampleValues[currentSample]);
			var guessForT = intervalStart + dist * kSampleStepSize;

			var initialSlope = getSlope(guessForT, mX1, mX2);
			if (initialSlope >= NEWTON_MIN_SLOPE)
			{
				return newtonRaphsonIterate(aX, guessForT, mX1, mX2);
			} else if (initialSlope == 0.0)
			{
				return guessForT;
			} else
			{
				return binarySubdivide(aX, intervalStart, intervalStart + kSampleStepSize, mX1, mX2);
			}
		}
	}
}
