/// Injectable time source so services can be tested with deterministic
/// timestamps. Production uses [SystemClock]; tests pass a fake.
abstract interface class Clock {
  int nowMs();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  int nowMs() => DateTime.now().millisecondsSinceEpoch;
}
