import 'dart:math';

/// 배틀넷·스팀 유저코드 형태. 헷갈리는 글자(0/O, 1/I/L)는 제외한다.
const eggHashcodeAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

const eggHashcodeLength = 6;

String generateEggHashcode([Random? random]) {
  final r = random ?? Random.secure();
  return List.generate(
    eggHashcodeLength,
    (_) => eggHashcodeAlphabet[r.nextInt(eggHashcodeAlphabet.length)],
  ).join();
}
