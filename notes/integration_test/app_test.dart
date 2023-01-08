import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:notes/main.dart' as app;

String randomNoteNameGenerator() {
  var rnd = Random();
  int randomLength = rnd.nextInt(15) + 1;
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return String.fromCharCodes(Iterable.generate(
      randomLength, (_) => _chars.codeUnitAt(rnd.nextInt(_chars.length))));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    //Arrange
    var _newNoteButton = find.byType(FloatingActionButton);
    var _noteNameTextField = find.byKey(Key('note-name-field'));
    var _addNoteButton = find.byKey(Key('add-note-button'));
    String testingNoteName = randomNoteNameGenerator();
    testWidgets('added note is placed in list of notes', (tester) async {
      //Arrange

      //Act
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(_newNoteButton);

      await tester.pumpAndSettle();

      await tester.enterText(_noteNameTextField, testingNoteName);

      await tester.pumpAndSettle();

      await tester.tap(_addNoteButton);

      await tester.pumpAndSettle();

      final _resultText = find.text(testingNoteName);
      //Assert
      expect(_resultText, findsOneWidget);
    });
  });
}
