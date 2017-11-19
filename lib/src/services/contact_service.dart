import 'dart:io';
import 'dart:async';
import 'dart:convert';

abstract class ContactServiceInterface {
  Future<List<Map<String, dynamic>>> getContacts();
  Future<File> setContacts(String content);
}

class ContactService implements ContactServiceInterface {
  Future<List<Map<String, dynamic>>> getContacts() {
    return new File("lib/src/services/data/users.json")
        .readAsString()
        .then(JSON.decode);
  }

  Future<File> setContacts(String contactsString) {
    return new File("lib/src/services/data/users.json")
        .writeAsString(contactsString);
  }
}
