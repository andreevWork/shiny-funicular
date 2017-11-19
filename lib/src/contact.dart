import 'contact_builder.dart';

class Contact {
  int id;
  String firstName;
  String lastName;

  Contact(ContactBuilder builder) {
    this.id = builder.Id;
    this.firstName = builder.FirstName;
    this.lastName = builder.LastName;
  }

  toString() {
    return "Contact: id: $id; firstName: $firstName; lastName: $lastName";
  }

  Map toJson() {
    Map map = new Map();
    map["id"] = id;
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    return map;
  }
}