import 'package:loco/loco.dart';
import 'package:test/test.dart';

class TestEvent {
  final num value;
  TestEvent(this.value);
}

class Test2Event {
  final num value;
  Test2Event(this.value);
}

class MyStateBase {}

class MyBaseStateLoaded extends MyStateBase {}

class MyLogicComponent extends Logic<MyStateBase> {
  final channel = Channel();
  num number;
  onInit() async {
    onEvent<TestEvent>(_setNumber);
  }

  _setNumber(TestEvent event) {
    number = event.value;
  }
}

void main() {
  group('BaseLogic', () {
    final myLogicComponent = MyLogicComponent();
    test('onInit returns a Future', () {
      expect(myLogicComponent.onInit(), TypeMatcher<Future<void>>());
    });
    test('has a onEvent method', () {
      myLogicComponent.onEvent(null);
    });
    group('onEvent2()', () {
      test('type must be specified', () {
        expect(
          () => myLogicComponent.onEvent((event) => {}),
          throwsArgumentError,
        );
      });
      // Makes more sense to test it as a whole.
      /*
      test('registers event for this logic component', () {
        myLogicComponent.channel.dispatch(TestEvent(9));

        // err yeah how to check this.
        assert(myLogicComponent.number == 9);
      });
       */
    });
  });
}
