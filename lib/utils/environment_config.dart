/** 
 * wrapper around variables passed in from `--dart-define=` cli flag.
 * 
 * `--dart-define="USE_EMULATOR=TRUE"` will use local firebase emulators.
 */
class EnvironmentConfig {
  static const useEmulator =
      String.fromEnvironment('FIREBASE_EMULATOR') == 'TRUE';
}
