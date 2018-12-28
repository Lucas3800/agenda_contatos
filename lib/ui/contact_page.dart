import 'dart:io';

import 'package:agenda_contatos/helpers/contacts_helpers.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  Contact _editedContact;
  bool _userEdited = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null)
      _editedContact = Contact();
    else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }

    _nameController.addListener(_onChangeName);
  }

  void _onChangeName() {
    _userEdited = true;
    setState(() {
      _editedContact.name = _nameController.text;
      if (_nameController.text == "") _editedContact.name = "Novo Contato";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingButton(),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact.img != null
                                ? FileImage(File(_editedContact.img))
                                : AssetImage("images/contact-outline.png")),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Nome"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Name is null";
                      }
                    },
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    onChanged: (value) {
                      _userEdited = true;
                      _editedContact.email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: "Phone"),
                    onChanged: (value) {
                      _userEdited = true;
                      _editedContact.phone = value;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget FloatingButton() {
    return Builder(builder: (BuildContext context) {
      return new FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Contato Salvo!")));
            Navigator.pop(context, _editedContact);
          } else {}
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      );
    });
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Os dados informados serão perdidos"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Sair"),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
