import 'package:api_arch/data/http/http.dart';
import 'package:api_arch/data/usecases/remote_authentication.dart';
import 'package:api_arch/domain/helpers/domain_error.dart';
import 'package:api_arch/domain/usecase/authentication.dart';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// import 'package:mockito/mockito.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late HttpClientSpy httpClient;
  late String url;
  late RemoteAuthentication sut;
  late AuthenticationParams params;
  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      secret: faker.internet.password(),
    );
  });

  test('Should call httpClient with correct values', () async {
    await sut.auth(params);
    verifyNever(() => httpClient.request(
        url: 'url',
        method: 'post',
        body: {'email': params.email, 'password': params.secret}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.badRequest);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.notFound);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.serverError);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredencialsError if HttpClient returns 401',
      () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.unuathorized);
    final future = sut.auth(params);
    expect(future, throwsA(DomainError.invalidCredencial));
  });
}
