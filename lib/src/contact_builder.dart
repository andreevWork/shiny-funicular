import 'contact.dart';

class ContactBuilder {
  int _id;
  int get Id => _id;

  String _firstName;
  String get FirstName => _firstName;

  String _lastName;
  String get LastName => _lastName;

  ContactBuilder();

  ContactBuilder.fromContact(Contact contact) {
    if (contact == null) {
      throw new ArgumentError("contact is null");
    }

    setId(contact.id);
    setFirstName(contact.firstName);
    setLastName(contact.lastName);
  }

  setId(int value) {
    _id = value;
  }

  setFirstName(String value) {
    _firstName = value;
  }

  setLastName(String value) {
    _lastName = value;
  }

  Contact build() {
    return new Contact(this);
  }
}