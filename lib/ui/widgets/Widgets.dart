import 'dart:io';
import 'package:agenda_contatos/helpers/contacts_helpers.dart';
import 'package:flutter/material.dart';

class UserCardView extends StatelessWidget {
  UserCardView(this.index, this.contacts);

  final int index;
  final List<Contact> contacts;

  String name;
  String email;
  String phone;

  @override
  Widget build(BuildContext context) {

    contacts[index].name.length < 20 ? name = contacts[index].name : name = "${contacts[index].name.substring(0, 20)}..." ;
    contacts[index].email.length < 20 ? email = contacts[index].email : email = "${contacts[index].email.substring(0, 20)}..." ;
    contacts[index].phone.length < 20 ? phone = contacts[index].phone : phone = "${contacts[index].phone.substring(0, 20)}..." ;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: contacts[index].img != null
                        ? FileImage(File(contacts[index].img))
                        : AssetImage("images/contact-outline.png")),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name ?? "",
                    style: TextStyle(
                        fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email ?? "",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    phone ?? "",
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
