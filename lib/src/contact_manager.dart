import 'dart:async';
import 'dart:convert';
import 'services/contact_service.dart';
import 'contact_builder.dart';
import 'contact.dart';

class ContactManager {
  static ContactManager _singleton;

  static final ContactServiceInterface contactService = new ContactService();

  factory ContactManager() {
    if (_singleton == null) {
      _singleton = new ContactManager._internal();
    }

    return _singleton;
  }

  Map<int, Map<String, Contact>> _contacts;

  StreamController<Null> _updateContactsStreamController;
  Stream<Null> get updateContactsStream => _updateContactsStreamController.stream;

  Timer _timer;

  ContactManager._internal() {
    _contacts = new Map();
    _updateContactsStreamController = new StreamController.broadcast();

    var duration = new Duration(seconds: 30);
    _timer = new Timer.periodic(duration, (Timer timer) {
      _updateContacts(false);
    });

    _updateContacts(true);
  }

  _updateContacts(bool isFirstSync) async {
    var contactsListFromDb = await contactService.getContacts();
    var hasChanges = false;

    for (var contactFromDb in contactsListFromDb) {
      var contactId = contactFromDb['id'];
      var firstName = contactFromDb['first_name'];
      var lastName = contactFromDb['last_name'];

      var contactBuilder = new ContactBuilder();
      var contactMap = new Map();

      if (_contacts[contactId] != null && _contacts[contactId]['dbPrevContact'] != null) {
        var memoryContact = _contacts[contactId]['currentContact'];
        var dbPrevContact = _contacts[contactId]['dbPrevContact'];

        firstName = _mergeProp(
          dbValue: contactFromDb['first_name'],
          prevDbValue: dbPrevContact.firstName,
          currentValue: memoryContact.firstName
        );

        lastName = _mergeProp(
          dbValue: contactFromDb['last_name'],
          prevDbValue: dbPrevContact.lastName,
          currentValue: memoryContact.lastName
        );

        hasChanges = true;
      }

      contactBuilder
        ..setId(contactId)
        ..setFirstName(firstName)
        ..setLastName(lastName);

      contactMap['currentContact'] = contactBuilder.build();
      contactMap['dbPrevContact'] = null;

      _contacts[contactId] = contactMap;
    }
    
    if (!isFirstSync && hasChanges) {
        var contactList = new List();

        _contacts.forEach((int contactId, Map<String, Contact> contactMap) {
          contactList.add(contactMap['currentContact']);
        });

        contactService.setContacts(JSON.encode(contactList));
    }

    _updateContactsStreamController.add(null);
  }

  _mergeProp({
    dynamic dbValue,
    dynamic prevDbValue,
    dynamic currentValue,
  }) {
    var newPropValue = [dbValue, currentValue]
      .where((value) => value != prevDbValue)
      .join('|');

    return newPropValue.length > 0 ? newPropValue : prevDbValue;
  }

  _generateId() {
    return 156644;
  }

  Contact getContactById(int id) {
    return _contacts[id]['currentContact'];
  }

  ContactBuilder getEditableContact(Contact contact) {
    return new ContactBuilder.fromContact(contact);
  }

  Contact createContact([ContactBuilder contactBuilder]) {
    contactBuilder ??= new ContactBuilder();

    contactBuilder.setId(_generateId());

    return contactBuilder.build();
  }

  Contact saveContact(ContactBuilder contactBuilder) {
    var contact = contactBuilder.build();
    var contactMap = _contacts[contact.id];

    if (contactMap['dbPrevContact'] == null) {
      contactMap['dbPrevContact'] = contactMap['currentContact'];
    }

    contactMap['currentContact'] = contact;

    return contact;
  }
}