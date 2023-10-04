import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ringtone_set/ringtone_set.dart';
import 'package:ringtone_set/src/setter_functions.dart';

void main() {
  const MethodChannel channel = MethodChannel('ringtone_set');

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
    expect(await RingtoneSet.platformVersion, '42');
  });

  group("Url parsing tests", () {
    test("Firebase URL is already encoded", () {
      final url =
          "https://firebasestorage.googleapis.com/v0/b/soundboards-71c05.appspot.com/o/frog%2FFrog%2001.mp3?alt=media&token=874d8563-a3ad-48fe-9e49-25eddb4f2dd1";
      final uri = urlParser(url);
      expect(uri.toString(),
          "https://firebasestorage.googleapis.com/v0/b/soundboards-71c05.appspot.com/o/frog%2FFrog%2001.mp3?alt=media&token=874d8563-a3ad-48fe-9e49-25eddb4f2dd1");
    });

    test("URL has non-latin characters and extra spaces", () {
      final url = "https://google.com/  ифваифва";
      final uri = urlParser(url);
      expect(uri.toString(),
          "https://google.com/%20%20%D0%B8%D1%84%D0%B2%D0%B0%D0%B8%D1%84%D0%B2%D0%B0");
    });

    test("URL is not encoded", () {
      final url = 'https://example.com/api/query?search= dart & is';
      final uri = urlParser(url);
      expect(uri.toString(),
          "https://example.com/api/query?search=%20dart%20&%20is");
    });

    test("URL with arabic symbols", () {
      final url =
          'https://daroukarim.com/Coran/Basset mujawad/an-Nisāʾ النساء.mp3';
      final uri = urlParser(url);
      expect(uri.toString(),
          "https://daroukarim.com/Coran/Basset%20mujawad/an-Nis%C4%81%CA%BE%20%D8%A7%D9%84%D9%86%D8%B3%D8%A7%D8%A1.mp3");
    });
  });
}
