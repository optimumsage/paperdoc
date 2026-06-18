import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperdoc/app/app.dart';

void main() {
  testWidgets('app shell renders and shows the Library destination',
      (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PaperDocApp()));
    await tester.pumpAndSettle();

    // The default route is Library; its label appears in the nav rail and
    // as the page's app-bar title.
    expect(find.text('Library'), findsWidgets);
    expect(find.text('Search'), findsWidgets);
  });
}
