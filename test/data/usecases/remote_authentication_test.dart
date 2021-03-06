import 'package:faker/faker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_clean/domain/usecases/authentication.dart';
import 'package:flutter_clean/domain/helpers/helpers.dart';

import 'package:flutter_clean/data/http/http_client.dart';
import 'package:flutter_clean/data/usecases/usecases.dart';
import 'package:flutter_clean/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication sut;
  HttpClientSpy httpClient;
  String url;
  AuthentincationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthentincationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });
  test('Should call HttpClient with correct values', () async {
    await sut.auth(params);

    verify(
      httpClient.request(url: url, method: 'post', body: {
        'email': params.email,
        'password': params.secret,
      }),
    );
  });

  test('Should throw UnexpectedError if HttpClient return 400', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient return 404', () async {
    when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throw UnexpectedError if HttpClient return 500', () async {
    when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    final future = sut.auth(params);
    expect(future, throwsA(DomainError.unexpected));
  });
  test('Should throw InvalidCredentialsErro if HttpClient return 401', () async {
    when(httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    final future = sut.auth(params);
    expect(future, throwsA(DomainError.invalidCredentials));
  });
}
