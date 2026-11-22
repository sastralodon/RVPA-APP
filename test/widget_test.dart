import 'package:flutter_test/flutter_test.dart';
import 'package:rvpa/main.dart';

void main() {
  testWidgets('MyApp menampilkan halaman utama dengan bottom navigation',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Beranda'), findsWidgets);
    expect(find.text('Koleksi'), findsWidgets);
  });
}
