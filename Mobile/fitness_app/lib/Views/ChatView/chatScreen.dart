import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String contactEmail;
  final String currentUserEmail;
  final String contactImageUrl;

  const ChatScreen({
    super.key,
    required this.contactName,
    required this.contactEmail,
    required this.currentUserEmail,
    required this.contactImageUrl,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _markMessagesAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.contactImageUrl),
              radius: 20,
            ),
            SizedBox(width: 10),
            Text(widget.contactName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageStream()),
          _buildMessageInput(),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }

  Widget _buildMessageStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('chats')
          .doc(getChatRoomId(widget.currentUserEmail, widget.contactEmail))
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final messages = snapshot.data!.docs;
          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final messageData =
              messages[index].data() as Map<String, dynamic>;
              final senderEmail = messageData['senderEmail'];
              final messageText = messageData['message'];
              final imageUrl = messageData['imageUrl'];
              final isRead = messageData['isRead'] ?? false;
              final timestamp = messageData['timestamp'] as Timestamp?;
              String timeString = '';
              if (timestamp != null) {
                final DateTime dateTime = timestamp.toDate();
                timeString = DateFormat('HH:mm').format(dateTime);
              }
              return _buildMessageBubble(
                  senderEmail == widget.currentUserEmail,
                  messageText,
                  imageUrl,
                  timeString,
                  isRead);
            },
          );
        }
      },
    );
  }

  Widget _buildMessageBubble(bool isCurrentUser, String messageText,
      String? imageUrl, String timeString, bool isRead) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                width: 200,
                height: 200,
              ),
            if (messageText.isNotEmpty)
              Text(
                messageText,
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                if (!isCurrentUser && !isRead) // Karşı tarafın okunmamış mesajlarını işaretle
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: Colors.blue,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () async {
              final pickedFile =
              await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  _image = File(pickedFile.path);
                });
                _uploadImageAndSendMessage();
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final messageText = _messageController.text.trim();
              if (messageText.isNotEmpty) {
                _sendMessage(messageText);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String message) {
    final chatRoomId = getChatRoomId(widget.currentUserEmail, widget.contactEmail);
    _firestore.collection('chats').doc(chatRoomId).collection('messages').add({
      'senderEmail': widget.currentUserEmail,
      'message': message,
      'imageUrl': null,
      'isRead': false, // Mesaj ilk gönderildiğinde okunmamış olarak işaretlenir.
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _uploadImageAndSendMessage() async {
    if (_image == null) return;
    final chatRoomId = getChatRoomId(widget.currentUserEmail, widget.contactEmail);
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('$chatRoomId/$imageName');
    try {
      await storageRef.putFile(_image!);
      final imageUrl = await storageRef.getDownloadURL();
      _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderEmail': widget.currentUserEmail,
        'message': '',
        'imageUrl': imageUrl,
        'isRead': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      setState(() {
        _image = null;
      });
    }
  }

  String getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "$user1-$user2";
    } else {
      return "$user2-$user1";
    }
  }

  void _markMessagesAsRead() async {
    final chatRoomId = getChatRoomId(widget.currentUserEmail, widget.contactEmail);
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .where('senderEmail', isEqualTo: widget.contactEmail)
        .where('isRead', isEqualTo: false)
        .get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'isRead': true});
    }
  }
}