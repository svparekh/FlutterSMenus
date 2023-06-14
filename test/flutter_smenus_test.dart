import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_smenus/flutter_smenus.dart';

void main() {
  test('is closed on init', () {
    final controller = SMenuController();
    expect(controller.state.value, SMenuState.closed);
  });
}
