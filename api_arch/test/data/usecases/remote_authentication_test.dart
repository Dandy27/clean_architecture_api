import 'package:api_arch/data/http/http.dart';
import 'package:api_arch/data/usecases/remote_authentication.dart';
import 'package:api_arch/domain/helpers/hlepers.dart';
import 'package:api_arch/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
// import 'package:flutter_test/flutter_test.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });
  test('Should call HtppClient with correct values', () async {
    when(() =>
        httpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            body: any(named: 'body'))).thenAnswer((_) async => {
          'accessToken': faker.guid.guid(),
          'name': faker.person.name(),
        });
    await sut.auth(params);

    verifyNever(() => httpClient.request(url: 'url', method: 'post', body: {
          'email': params.email,
          'password': params.secret,
        }));
  });

  test('Should thorw UnxpectedError if HttpClient returs 400', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.badRequest);
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should thorw UnxpectedError if HttpClient returs 404', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.notFound);
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should thorw UnxpectedError if HttpClient returs 500', () async {
    when(() => httpClient.request(
        url: any(named: 'url'),
        method: any(named: 'method'),
        body: any(named: 'body'))).thenThrow(HttpError.serverError);
    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should return an Account if HttpClient returs 200', () async {
    final accessToken = faker.guid.guid();
    when(() =>
        httpClient.request(
            url: any(named: 'url'),
            method: any(named: 'method'),
            body: any(named: 'body'))).thenAnswer((_) async => {
          'accessToken': accessToken,
          'name': faker.person.name(),
        });

    final params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());

    final account = await sut.auth(params);

    expect(account.token, accessToken);
  });
}
