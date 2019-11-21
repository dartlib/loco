import 'package:loco/loco.dart';
import 'package:test/test.dart';

class TestEvent {
  final num value;
  TestEvent(this.value);
}

class TestState {
  final num total;
  TestState({
    this.total,
  });
}

class TestExtension extends Extension<TestState> {
  final name = 'TestExtension';

  Future<void> onInit() async {
    onEvent<TestEvent>(_onTestEvent);
    initState<TestState>(
      TestState(total: 0),
    );
  }

  _onTestEvent(TestEvent event) {
    final currentState = getState<TestState>();

    setState<TestState>(
      TestState(
        total: currentState.total + event.value,
      ),
    );
  }
}

void main() {
  group('Api', () {
    test('register extension', () {
      final api = Api.instance;

      final extension = TestExtension();

      api.registerExtension(extension);

      assert(api.hasExtension<TestExtension>());
    });

    test('register same extension twice fails', () {
      final api = Api.instance;

      expect(
        () => api.registerExtension(TestExtension()),
        throwsA(
          TypeMatcher<ArgumentError>(),
        ),
      );
    });

    test('Can register any instance', () {
      final api = Api.instance;

      api.register(DateTime.now());
    });

    test('Can register only once', () {
      final api = Api.instance;

      expect(
        () => api.register(DateTime.now()),
        throwsA(
          TypeMatcher<ArgumentError>(),
        ),
      );
    });

    test('Event triggers state change', () async {
      final api = Api.instance;

      await api.initialize();

      final testExtension = api.getExtension<TestExtension>();

      final stateStream =
          testExtension.channel.output.getStateStream<TestState>();

      var count = 1;
      stateStream.listen(
        expectAsync1(
          (TestState state) {
            if (count == 1) {
              assert(state.total == 0);
              count++;
            } else {
              assert(state.total == 3);
            }
          },
          count: 2,
        ),
      );

      testExtension.dispatch(TestEvent(3));
    });
  });
}
