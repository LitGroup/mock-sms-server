// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
//
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

library smsmock.common.model;

/// Represents short message.
class Message {
  /// Phone number or name of sender.
  final String sender;

  /// Unmodifiable list of phone numbers of recipients.
  final List<String> recipients;

  /// Text of message.
  final String body;

  Message(this.sender, Iterable<String> recipients, this.body)
      : recipients = new List<String>.unmodifiable(recipients);
}
