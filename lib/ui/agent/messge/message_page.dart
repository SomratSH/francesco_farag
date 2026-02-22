import 'package:flutter/material.dart';
import 'package:francesco_farag/routing/app_route.dart';
import 'package:go_router/go_router.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFE91E63), // Pinkish-magenta
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Messages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Chat with agencies',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          // Message List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children:  [
                             

                   InkWell(
                    onTap: () {
                        context.push(AppRoute.agentChat);
                    },
                     child: MessageTile(
                      initial: 'S',
                      name: 'Sarah Johnson',
                      message: 'Your car is ready for pickup',
                      time: '10:30 AM',
                      unreadCount: 2,
                                       ),
                   ),
                
                InkWell(
                   onTap: () {
                        context.push(AppRoute.agentChat);
                    },
                  child: MessageTile(
                    initial: 'M',
                    name: 'Madrid Centro Branch',
                    message: 'Security deposit refunded',
                    time: 'Yesterday',
                  ),
                ),
                InkWell(
                   onTap: () {
                        context.push(AppRoute.agentChat);
                    },
                  child: MessageTile(
                    initial: 'T',
                    name: 'TinDrive Agency',
                    message: 'Security deposit refunded',
                    time: '11/2/2026',
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
      
     
  }
}

class MessageTile extends StatelessWidget {
  final String initial;
  final String name;
  final String message;
  final String time;
  final int unreadCount;

  const MessageTile({
    super.key,
    required this.initial,
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: const Color(0xFFE3F2FD), // Light blue
          child: Text(
            initial,
            style: const TextStyle(
              color: Color(0xFF2196F3),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          message,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            const SizedBox(height: 4),
            if (unreadCount > 0)
              CircleAvatar(
                radius: 10,
                backgroundColor: const Color(0xFF2196F3),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            else
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}