import 'package:flutter/material.dart';
import 'package:nuncare_mobile_firebase/components/my_loading.dart';
import 'package:nuncare_mobile_firebase/components/my_user_tile.dart';
import 'package:nuncare_mobile_firebase/screens/message/chat_page_screen.dart';
import 'package:nuncare_mobile_firebase/services/auth_service.dart';
import 'package:nuncare_mobile_firebase/services/chat_service.dart';

class MessagePageScreen extends StatelessWidget {
  MessagePageScreen({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Messagerie',
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: _buildChatList(),
      ),
    );
  }

  Widget _buildChatList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (ctx, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Erreur au chargement des utilisateurs");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingCirle();
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Aucun utilisateur pour l'instant",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
          );
        }

        return ListView(
          children: snapshot.data!
              .map(
                (userData) => _buildUserListItem(userData, ctx),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return MyUserTile(
        text: "${userData["firstName"]} ${userData["lastName"]}",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => ChatPageScreen(
              receiverName: "${userData["firstName"]} ${userData["lastName"]}",
              receiverId: userData['uid'],
              receiverEmail: userData["email"],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
