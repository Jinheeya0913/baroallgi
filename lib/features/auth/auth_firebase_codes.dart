/// Firebase Auth `FirebaseAuthException.code` 값.
abstract final class AuthFirebaseCodes {
  static const userNotFound = 'user-not-found';
  static const wrongPassword = 'wrong-password';
  static const invalidCredential = 'invalid-credential';
  static const emailAlreadyInUse = 'email-already-in-use';
  static const invalidEmail = 'invalid-email';
  static const weakPassword = 'weak-password';
  static const operationNotAllowed = 'operation-not-allowed';

  static const credentialMismatchCodes = {
    userNotFound,
    wrongPassword,
    invalidCredential,
  };
}
