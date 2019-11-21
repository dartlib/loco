import 'package:flutter/material.dart';
import 'package:loco_example/keys.dart';
import 'package:loco_flutter/loco_flutter.dart';

class HomeView extends View {
  final name = 'home-screen';

  HomeView()
      : super(
          ViewProps(key: LocoExampleKeys.homeScreen),
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: slot('app-bar-title') ?? Text(''),
        actions: multiSlot('home-view-actions', context) ?? [],
      ),
      body: slot('body'),
      floatingActionButton: slot('home-view-add-todo-button'),
      bottomNavigationBar: slot('home-view-bottom-navigation-bar'),
    );
  }
}
