import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assecontservices/assecontservices.dart';

void main() {
  const MethodChannel channel = MethodChannel('assecontservices');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Assecontservices.platformVersion, '42');
  });
}
