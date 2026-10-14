import 'package:baroallgi/features/auth/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserModel json round trip keeps account fields', () {
    final createdAt = DateTime.utc(2026, 3, 4, 5, 6, 7);
    final model = UserModel(
      uid: 'uid-1',
      email: 'user@example.com',
      displayName: '바로알기',
      photoUrl: 'https://example.com/photo.jpg',
      emailVerified: true,
      createdAt: createdAt,
    );

    final restored = UserModel.fromJson(model.toJson());

    expect(restored.uid, model.uid);
    expect(restored.email, model.email);
    expect(restored.displayName, model.displayName);
    expect(restored.photoUrl, model.photoUrl);
    expect(restored.emailVerified, true);
    expect(restored.createdAt, createdAt);
    expect(restored.lastLoginAt, isNull);
  });
}
