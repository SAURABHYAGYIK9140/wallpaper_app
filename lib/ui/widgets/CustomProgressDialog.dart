import 'package:flutter/material.dart';

class CustomProgressDialog extends StatefulWidget {
  final String message;

  CustomProgressDialog({required this.message});

  @override
  State<CustomProgressDialog> createState() => _CustomProgressDialogState();
}

class _CustomProgressDialogState extends State<CustomProgressDialog> {
  String _message = '';

  @override
  void initState() {
    super.initState();
    _message = widget.message;
  }

  void updateMessage(String newMessage) {
    setState(() {
      _message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the progress dialog
void showCustomProgressDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: false, // Dialog cannot be dismissed by tapping outside
    builder: (BuildContext context) {
      return CustomProgressDialog(message: message);
    },
  );
}

// Function to hide the progress dialog
void hideCustomProgressDialog(BuildContext context) {
  Navigator.of(context).pop(); // Dismiss the dialog
}

// Function to update the message in the progress dialog
void updateCustomProgressDialogMessage(BuildContext context, String newMessage) {
  final state = context.findAncestorStateOfType<_CustomProgressDialogState>();
  if (state != null) {
    state.updateMessage(newMessage);
  }
}
