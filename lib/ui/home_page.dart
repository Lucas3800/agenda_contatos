import 'package:agenda_contatos/helpers/contacts_helpers.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:agenda_contatos/ui/widgets/Widgets.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            child: UserCardView(index, contacts),
            onTap: () {
              _showOptions(context, index);
            },
          );
        },
        itemCount: contacts.length,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  void _showContactPage({Contact contact}) async {
    final newContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    if (newContact != null) {
      if (contact != null) {
        await helper.updateContact(newContact);
      } else {
        await helper.saveContact(newContact);
      }

      _getAllContacts();
    }
  }

  _getAllContacts() {
    helper.getAllContacts().then((contatos) {
      print("Lista de contatos:");
      for (var c in contatos) {
        print(c);
      }
      setState(() {
        contacts = contatos;
      });
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Ligar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showContactPage(contact: contacts[index]);
                          },
                          child: Text(
                            "Editar",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Deseja excluir o contato?"),
                                    content: Text(
                                        "O seguinte contato \"${contacts[index].name}\" deixará de fazer parte da sua lista de contatos"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          setState(() {
                                            helper.deleteContact(
                                                contacts[index].id);
                                            contacts.removeAt(index);
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text("Excluir"),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancelar"),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Excluir",
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          )),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}
