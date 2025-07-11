import 'package:flutter/material.dart';

class QuickSupportButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isCall;

  const QuickSupportButton({Key? key, this.onPressed, this.isCall = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color(0xFF1976D2),
      onPressed: onPressed,
      child: Icon(isCall ? Icons.phone : Icons.chat, color: Colors.white),
      tooltip: isCall ? 'Gọi hỗ trợ' : 'Chat hỗ trợ',
    );
  }
} 