import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loco/loco.dart';
import 'package:loco_flutter/loco_flutter.dart';

class MyViewProps extends ViewProps {
  final String name;
  MyViewProps({
    Key key,
    this.name,
  }) : super(key: key);
}

class MyView extends View<MyViewProps> {
  MyView(MyViewProps props) : super(props);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Text('My Text'),
    );
  }
}

typedef MyViewFactory(MyViewProps props);

class ViewsContainer with Views {}

void main() {
  testWidgets('Views', (WidgetTester tester) async {
    final viewsContainer = ViewsContainer();

    viewsContainer.views
        .registerView<MyView>((MyViewProps props) => MyView(props));

    final myKey = Key('my-key');
    final myView = viewsContainer.views.getViewWithProps<MyView, MyViewProps>(
      MyViewProps(
        key: myKey,
        name: 'Test1',
      ),
    );

    expect(myView, isA<MyView>());
    expect(myView.key, equals(myKey));
    expect(myView.channel, isA<Channel>());

    await tester.pumpWidget(myView);

    expect(find.text('My Text'), findsOneWidget);
  });
}
