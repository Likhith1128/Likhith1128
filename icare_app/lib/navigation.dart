import 'package:flutter/material.dart';

void openHome(BuildContext context) {
  Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
}

void openOnTopOfHome(BuildContext context, String route) {
  Navigator.of(context)
      .pushNamedAndRemoveUntil(route, ModalRoute.withName('/home'));
}
