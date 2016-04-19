// (c) 2016 Roman Shamritskiy <roman@litgroup.ru>
//
// This source file is subject to the MIT license that is bundled
// with this source code in the file LICENSE.

library smsmock.test.core.sender_id;

import 'package:test/test.dart';

import 'package:smsmock/core.dart' show SenderId;

void main() {
  test('value of id', () {
    final senderId = new SenderId('Some sender');
    expect(senderId.value, equals('Some sender'));
  });

  test('unknown sender constructor', () {
    final senderId = new SenderId.unknown();
    expect(senderId.value, equals('Unknown'));
  });
}
