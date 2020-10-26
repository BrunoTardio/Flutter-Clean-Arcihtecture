import 'package:meta/meta.dart';

import 'package:flutter_clean/data/http/http.dart';

import '../../domain/usecases/usecases.dart';

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
      body: params.toJson(),
    );
  }
}
