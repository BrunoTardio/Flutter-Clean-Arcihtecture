import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth({
    AuthentincationParams params,
  });
}

class AuthentincationParams {
  final String email;
  final String secret;

  AuthentincationParams({
    @required this.email,
    @required this.secret,
  });

}
