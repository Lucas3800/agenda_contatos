import 'package:agenda_contatos/helpers/contacts_helpers.dart';
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

    helper.getAllContacts().then((contatos) {
      print("Lista de contatos:\n$contatos");

      setState(() {
        contacts = contatos;
      });
    });
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
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return UserCardView(index, contacts);
        },
        itemCount: contacts.length,
        padding: EdgeInsets.all(10.0),
      ),
    );
  }
}
