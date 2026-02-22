

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerChat extends StatelessWidget {
  const CustomerChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading:  InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black87)),
        title: const Text('Messages', style: TextStyle(color: Colors.black87)),
      ),
      body: Column(
        children: [
          // User Info Header
          const UserHeaderTile(),
          
          // Chat List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: const [
                ChatBubble(
                  message: "Hi, I would like to confirm my booking for the Tesla Model 3.",
                  time: "04:30 PM",
                  isMe: true,
                ),
                ChatBubble(
                  message: "Hello John! Your booking has been confirmed. Please make sure to bring your driving license on the pickup day.",
                  time: "04:45 PM",
                  isMe: false,
                ),
                ChatBubble(
                  message: "Perfect! What time should I arrive?",
                  time: "05:00 PM",
                  isMe: true,
                ),
                ChatBubble(
                  message: "You can arrive anytime between 9 AM and 6 PM. We recommend coming in the morning to avoid rush hours.",
                  time: "05:15 PM",
                  isMe: false,
                ),
              ],
            ),
          ),
          
          // Input Field
          const MessageInputField(),
        ],
      ),
    );
  }
}

class UserHeaderTile extends StatelessWidget {
  const UserHeaderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFF1E88E5), // Blue avatar
            child: Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Sarah Johnson', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('EuroCar Rentals', style: TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;

  const ChatBubble({
    super.key, 
    required this.message, 
    required this.time, 
    required this.isMe
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 8, 
              bottom: 4, 
              left: isMe ? 60 : 0, 
              right: isMe ? 0 : 60
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFD81B60) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isMe ? [] : [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  const MessageInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.attach_file, color: Colors.grey),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFFD81B60), // Magenta send button
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}