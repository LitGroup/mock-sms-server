// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
//
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

library smsmock.core;

import 'dart:async' show Stream;

import 'package:meta/meta.dart' as meta;

/// Represents message of short message service (SMS).
class Message {

  /// Constructor.
  ///
  /// [text] must not be `null` or empty string, [DomainError] will be thrown
  /// otherwise.
  /// [recipientNumbers] must contain at least one element, [DomainError] will
  /// be thrown otherwise.
  Message(String text, List<PhoneNumber> recipientNumbers,
      {SenderId senderId: const SenderId.unknown()})
      : text = text,
        recipientNumbers = new List.unmodifiable(recipientNumbers),
        senderId = senderId {
    if (text == null || text.isEmpty) {
      throw new DomainError('Text of Message must not be empty');
    }
    if (recipientNumbers.isEmpty) {
      throw new DomainError('List of recipient numbers must not be empty');
    }
  }

  /// Text of message.
  final String text;

  /// Unmodifiable list of recipient numbers.
  final List<PhoneNumber> recipientNumbers;

  /// Identifier of message sender.
  final SenderId senderId;
}

/// Phone number value object.
class PhoneNumber {
  PhoneNumber(this.value);

  final String value;
}

/// Identifier of message sender.
class SenderId {
  SenderId(this.value);

  /// Constant constructor for empty sender ID.
  @meta.literal
  const SenderId.unknown() : value = 'Unknown';

  /// Phone number or any other string (name of company for example).
  final String value;
}

/// Interface for input gateway of Short Message Service.
abstract class SmsInputGateway {
  void sendMessage(Message message);
}

/// Interface for output gateway of Short Message Service.
abstract class SmsOutputGateway {
  Stream<Message> get onMessage;
}

class DomainError extends Error {
  final String message;

  DomainError(this.message) : super();

  @override
  String toString() => 'Doman error: $message';
}
