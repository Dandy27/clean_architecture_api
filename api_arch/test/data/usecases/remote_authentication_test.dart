import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class RemoteAuthentication {
  Future<void> auth() async {}
}

void main() {
  test('Should call HttpClient with correct URL', () async {
    final sut = RemoteAuthentication(httpClient : httpClient);

    await sut.auth();

    verify(httpClient.request(url: url));
  });
}
