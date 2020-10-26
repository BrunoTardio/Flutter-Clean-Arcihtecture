import 'package:flutter_clean/domain/entities/account_entity.dart';
import 'package:meta/meta.dart';

import 'package:flutter_clean/data/http/http.dart';
import 'package:flutter_clean/domain/usecases/usecases.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({
    @required this.httpClient,
    @required this.url,
  });

  Future<void> auth(AuthentincationParams params) async {
    await httpClient.request(
      url: url,
      method: 'post',
      body: RemoteAuthenticationParams.fromDomain(params).toJson(),
    );
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthentincationParams params) =>
      RemoteAuthenticationParams(email: params.email, password: params.secret);

  Map toJson() => {
        'email': email,
        'password': password,
      };
}
