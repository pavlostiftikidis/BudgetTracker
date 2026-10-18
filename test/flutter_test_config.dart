import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

/// Applies to every test file: a tap that lands on a different widget than
/// intended (e.g. something hidden under the floating nav) fails the test.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  WidgetController.hitTestWarningShouldBeFatal = true;
  await testMain();
}
