// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
//
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

library smsmock.test.core.phone_number;

import 'package:test/test.dart';

import 'package:smsmock/core.dart' show PhoneNumber;

const phoneStr = '+79991234567';

void main() {
  test('value of phone number object', () {
    final phone = new PhoneNumber(phoneStr);
    expect(phone.value, equals(phoneStr));
  });
}
