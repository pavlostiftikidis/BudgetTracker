/// Injectable source of "now", so tests can pin the date.
class Clock {
  const new();

  DateTime now() => DateTime.now();
}

class FixedClock extends Clock {
  new(this.fixed);

  DateTime fixed;

  @override
  DateTime now() => fixed;
}
