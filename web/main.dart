// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert' show JSON;
import 'dart:async' show Timer;

main() async {

  var websocket = new WebSocket('ws://${window.location.host}/ws');

  var table = querySelector('#messages-tbl');
  var tbody = table.querySelector('tbody');

  await for (MessageEvent event in websocket.onMessage) {
    var sms = JSON.decode(event.data);
    var row = window.document.createElement('tr')
      ..classes.add('new')
      ..setInnerHtml(
          '<tr>'
          '  <td>${new DateTime.now().toString()}</td>'
          '  <td>${sms['sender'] ?? '-'}</td>'
          '  <td>${sms['recipient']}</td>'
          '  <td>${sms['body']}</td>'
          '</tr>'
      );

    new Timer(const Duration(seconds: 2), () {
      row.classes.remove('new');
    });

    tbody.insertAdjacentElement('afterBegin', row);

    while (tbody.children.length > 30) {
      tbody.children.removeLast();
    }
  }
}
