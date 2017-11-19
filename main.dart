import 'lib/shiny-funicular.dart';

case1() async {
  var contactManager = new ContactManager();

  await contactManager.updateContactsStream.first;

  var firstContact = contactManager.getContactById(1);
  var firstContactBuilder = contactManager.getEditableContact(firstContact);

  firstContactBuilder.setFirstName('Bob');

  contactManager.saveContact(firstContactBuilder);
}

case21() async {
  var contactManager = new ContactManager();

  await contactManager.updateContactsStream.first;

  var firstContact = contactManager.getContactById(1);
  var firstContactBuilder = contactManager.getEditableContact(firstContact);

  firstContactBuilder.setLastName('White');

  contactManager.saveContact(firstContactBuilder);

  // Здесь покажет результат мерджа и того что окажется в файле, через ~30с
  contactManager.updateContactsStream.listen((arg) {
    print(contactManager.getContactById(1));
  });
}

case22() async {
  var contactManager = new ContactManager();

  await contactManager.updateContactsStream.first;

  var firstContact = contactManager.getContactById(1);
  var firstContactBuilder = contactManager.getEditableContact(firstContact);

  firstContactBuilder.setFirstName('Sara');

  contactManager.saveContact(firstContactBuilder);

  // Здесь покажет результат мерджа и того что окажется в файле, через ~30с
  contactManager.updateContactsStream.listen((arg) {
    print(contactManager.getContactById(1));
  });
}

main() async {
//  case1();
//  case21();
//  case22();
}