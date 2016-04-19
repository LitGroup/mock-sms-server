// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
//
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

library smsmock.test.core.message;

import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

import 'package:smsmock/core.dart' show Message, PhoneNumber, SenderId, DomainError;

@proxy
class MockPhoneNumber extends Mock implements PhoneNumber {}

@proxy
class MockSenderId extends Mock implements SenderId {}

final phoneNumberA = new MockPhoneNumber();
final phoneNumberB = new MockPhoneNumber();
final senderId = new MockSenderId();
const messageText = 'Hola, amigo!';

void main() {
  test('required fields', () {
    final message = new Message(messageText, [phoneNumberA, phoneNumberB]);
    expect(message.text, equals(messageText));
    expect(message.recipientNumbers, equals([phoneNumberA, phoneNumberB]));
  });

  test('text of message must not be empty', () {
    expect(() => new Message(null, [phoneNumberA]),
        throwsA(const isInstanceOf<DomainError>()));
    expect(() => new Message('', [phoneNumberA]),
        throwsA(const isInstanceOf<DomainError>()));
  });

  test('recipientsNumber must not be empty', () {
    expect(() => new Message(messageText, null),
        throwsA(const isInstanceOf<Error>()));
    expect(() => new Message(messageText, []),
        throwsA(const isInstanceOf<DomainError>()));
  });

  test('recipientsNumber must be immutable', () {
    final recipients = [phoneNumberA];
    final message = new Message(messageText, recipients);
    expect(message.recipientNumbers, equals([phoneNumberA]));

    recipients.add(phoneNumberB);
    expect(message.recipientNumbers, equals([phoneNumberA]),
        reason: 'Instance of Message must contain a copy of phone numbers list.');
    expect(() => message.recipientNumbers.add(phoneNumberB), throwsUnsupportedError,
      reason: 'List of recipient numbers must be immutable.');
  });

  test('senderId', () {
    final message = new Message(messageText, [phoneNumberA], senderId: senderId);
    expect(message.senderId, same(senderId));
  });

  test('by default senderId must be "Unknown"', () {
    final message = new Message(messageText, [phoneNumberA]);
    expect(message.senderId, const  isInstanceOf<SenderId>());
    expect(message.senderId.value, equals(const SenderId.unknown().value));
  });
}
