import 'package:api_arch/data/http/http.dart';
import 'package:api_arch/data/usecases/remote_authentication.dart';
import 'package:api_arch/domain/helpers/hlepers.dart';
import 'package:api_arch/domain/usecases/usecases.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAuthentication sut;
  late HttpClientSpy httpClient;
  late String url;
  late AuthenticationParams params;
  Map mockValidData() =>
      {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  When<Future<Map<dynamic, dynamic>>> mockRequest(HttpClientSpy httpClient) =>
      when(() => httpClient.request(
          url: any(named: 'url'),
          method: any(named: 'method'),
          body: any(named: 'body')));

  void mockHttpData(Map data) =>
      mockRequest(httpClient).thenAnswer((_) async => data);

  // void mockHttpError(HttpError error) =>
  //     mockRequest(httpClient).thenThrow((_) async => error);

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
    mockHttpData(mockValidData());
  });
  test('Should call HtppClient with correct values', () async {
    await sut.auth(params);

    verifyNever(() => httpClient.request(url: 'url', method: 'post', body: {
          'email': params.email,
          'password': params.secret,
        }));
  });

  test('Should thorw UnxpectedError if HttpClient returns 400', () async {
    mockRequest(httpClient).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should thorw UnxpectedError if HttpClient returns 404', () async {
    mockRequest(httpClient).thenThrow(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should thorw UnxpectedError if HttpClient returns 500', () async {
    mockRequest(httpClient).thenThrow(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should thorw InvalidCredential if HttpClient returns 401', () async {
    mockRequest(httpClient).thenThrow(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });
  test('Should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.auth(params);

    expect(account.token, validData['accessToken']);
  });

  test('Should throw Unexpected  if HttpClient returns 200 with invalid data ',
      () async {
    mockHttpData({
      'invalid_key': 'invalid_value',
    });

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}
