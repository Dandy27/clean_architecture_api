import 'package:api_arch/data/http/http.dart';
import 'package:api_arch/data/usecases/remote_authentication.dart';
import 'package:api_arch/domain/helpers/helpers.dart';
import 'package:api_arch/domain/usecase/authentication.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication sut;
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
  });

  test('Should call httpClient with correct values', () async {
    final params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
    await sut.auth(params);
    verify(httpClient.request(url: url, method: 'post', body: {
      'email': params.email,
      'password': params.secret,
    }));
  });

  test('Should throw Unexpected if HttpClient return 400', () async {
    when(() => httpClient.request(
        url: 'url',
        method: 'method',
        body: 'body' as dynamic)).thenThrow(HttpError.badRequest);
  });
}
