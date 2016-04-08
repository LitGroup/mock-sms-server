// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
//
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

library smsmock.test.lib.common.message;

import 'package:test/test.dart';

import 'package:smsmock/common/model.dart';

void main() {
  test('Message getters', () {
    const sender = 'SENDER';
    const recipients = const ['+79991111111', '+79992222222'];
    const body = 'Hello!';

    final message = new Message(sender, recipients, body);

    expect(message.sender, equals(sender));
    expect(message.recipients, equals(recipients));
    expect(message.body, equals(body));
  });
}
