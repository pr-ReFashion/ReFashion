import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'GOOGLE_MAP_KEY', obfuscate: true)
  static final String googleMapKey = _Env.googleMapKey;

  @EnviedField(varName: 'PUBLISHABLE_KEY', obfuscate: true)
  static final String publishableKey = _Env.publishableKey;

  @EnviedField(varName: 'SECRET_KEY', obfuscate: true)
  static final String secretKey = _Env.secretKey;
}
