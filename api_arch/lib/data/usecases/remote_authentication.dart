import 'package:api_arch/domain/helpers/helpers.dart';

import '../../domain/usecase/authentication.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();

    try {
      await httpClient.request(url: url, method: 'post', body: body);
    } on HttpError catch (error) {
      throw error == HttpError.unuathorized
          ? DomainError.invalidCredencial
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.secret,
      );

  Map toJson() => {
        'email': email,
        'password': password,
      };
}