import 'package:loco/app_channel.dart';
import 'package:test/test.dart';

class TestEvent {
  final num value;
  TestEvent(this.value);
}

class Test2Event {
  final num value;
  Test2Event(this.value);
}

void main() {
  group('Test Channel', () {
    group('on<T>()', () {
      test('Receives events of only given type', () {
        var count = 0;
        var count2 = 0;
        final events = [TestEvent(1), TestEvent(2)];
        final events2 = [Test2Event(3), Test2Event(4)];

        AppChannel.instance
          ..on<TestEvent>().listen(
            expectAsync1(
              (TestEvent event) {
                assert(event is TestEvent);
                expect(event.value, events[count++].value);
              },
              count: events.length,
            ),
          )
          ..on<Test2Event>().listen(
            expectAsync1(
              (Test2Event event) {
                assert(event is Test2Event);
                expect(event.value, events2[count2++].value);
              },
              count: events2.length,
            ),
          )
          ..dispatch(events[0])
          ..dispatch(events2[0])
          ..dispatch(events2[1])
          ..dispatch(events[1]);
      });
    });
  });
}
