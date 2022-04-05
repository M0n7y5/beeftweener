using System;
namespace BeefTweener
{
	/// Tween class that makes tweening super easy!
	public class Tweener<T> where T :
		operator T + T,
		operator T - T,
		operator T * float
	{
		private T _start;
		private T _end;
		private double _elapsed;
		private double _duration;
		private EaseFunc _easeFunc;
		private LerpFunc<T> _lerpFunc;

		public delegate void() OnEnd;

		public T Value { get; private set; }

		/// Bool designating if the Tweener is running or not
		public bool Running { get; private set; }

		/// @param start Value to start at
		/// @param end Target Value
		/// @param percent Progress along ease function where 0-1 is 0%-100%
		/// @param easeFunc Function to use when Easing
		/// @param lerpFunc Function to use when Interpolating
		[AllowAppend]
		public this(T start, T end, double duration,
			EaseFunc easeFunc, LerpFunc<T> lerpFunc = null)
		{
			_elapsed = 0;
			_start = start;
			_end = end;
			_duration = duration;

			// If there's no ease function specified, use Linear
			if (easeFunc == null)
				_easeFunc = new (percent) => Ease.Linear(percent);
			else
				_easeFunc = easeFunc;

			// If there's no lerp function specified, use Generic Default
			if (lerpFunc == null)
				_lerpFunc = new (start, end, percent) => LerpFuncDefault(start, end, percent);
			else
				_lerpFunc = lerpFunc;

			Value = _start;
			Running = true;
		}

		/// @param start Value to start at
		/// @param end Target Value
		/// @param percent Progress along ease function where 0-1 is 0%-100%
		/// @param easeFunc Function to use when Easing
		/// @param lerpFunc Function to use when Interpolating
		[AllowAppend]
		public this(T start, T end, float duration, EaseFunc easeFunc = null, LerpFunc<T> lerpFunc = null)
			: this(start, end, (double)duration, easeFunc, lerpFunc)
		{
		}

		/// @param start Value to start at
		/// @param end Target Value
		/// @param percent Progress along ease function where 0-1 is 0%-100%
		/// @param easeFunc Function to use when Easing
		/// @param lerpFunc Function to use when Interpolating
		[AllowAppend]
		public this(T start, T end, TimeSpan duration, EaseFunc easeFunc = null, LerpFunc<T> lerpFunc = null)
			: this(start, end, duration.TotalSeconds, easeFunc, lerpFunc)
		{
		}

		public ~this()
		{
			if (_easeFunc != null) delete _easeFunc;
			if (_lerpFunc != null) delete _lerpFunc;
		}

		[Inline]
		public void SetStart(T start)
		{
			_start = start;
		}

		[Inline]
		public void SetEnd(T end)
		{
			_end = end;
		}

		/// Update the Tweener
		/// @param deltaTime Elapsed time between frame (in seconds)
		public void Update(double deltaTime)
		{
			// Don't update if not running
			if (!Running) return;

			_elapsed += deltaTime;

			// Stop the Tween if it's finished
			if (_elapsed >= _duration)
			{
				_elapsed = _duration;
				Value = Calculate(_start, _end, 1, _easeFunc, _lerpFunc); // Set it to end point

				Stop();
				Ended();

				return;
			}

			// Calculate new value based on current Lerp percent
			Value = Calculate(_start, _end, (float)(_elapsed / _duration), _easeFunc, _lerpFunc);
		}

		/// Update the Tweener
		/// @param deltaTime Elapsed time between frame (in seconds)
		[Inline]
		public void Update(float deltaTime)
		{
			Update((double)deltaTime);
		}

		/// If there's no lerp function specified, use Generic Math to calculate start + ((end - start) * percent)
		[Inline]
		private static T LerpFuncDefault(T start, T end, float percent)
		{
			let sub = end - start;
			let mult = sub * percent;
			return start + mult;
		}

		/// @param start Value to start at
		/// @param end Target Value
		/// @param percent Progress along ease function where 0-1 is 0%-100%
		/// @param easeFunc Function to use when Easing
		/// @param lerpFunc Function to use when Interpolating
		[Inline]
		private static T Calculate(T start, T end, float percent, EaseFunc easeFunc, LerpFunc<T> lerpFunc)
		{
			// Scale the percent based on the ease
			float scaledPercent = easeFunc(percent);

			// Pass in scaled percent to interpolation
			return lerpFunc(start, end, scaledPercent);
		}

		[Inline]
		private void Ended()
		{
			if (OnEnd != null)
			{
				OnEnd();
			}
		}

		/// Start the Tweener
		[Inline]
		public void Start()
		{
			Running = true;
		}

		/// Stop the Tweener
		[Inline]
		public void Stop()
		{
			Running = false;
		}

		/// Reset the Tweener (moves back to beginning)
		[Inline]
		public void Reset()
		{
			_elapsed = 0;
			Value = _start;
		}

		/// Reset the tweener to go from End to Start instead (and resets to beginning)
		[Inline]
		public void Reverse()
		{
			_elapsed = 0;

			T tmp = _end;
			_end = _start;
			_start = tmp;
		}

	}
}
