import 'package:fitness_app/Views/Components/BottomNavigationBarComponent.dart';
import 'package:fitness_app/services/UserAuthService.dart';
import 'package:flutter/material.dart';

class MemberInformation extends StatefulWidget {
  const MemberInformation({super.key});

  @override
  State<MemberInformation> createState() => _MemberInformationState();
}

class _MemberInformationState extends State<MemberInformation> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await MailService.loadData();
    setState(() {}); // Veriler yüklendikten sonra arayüzü güncelle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Membership Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange, Colors.red],
            ),
          ),
        ),
      ),
      body: MailService.username != null
          ? ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display the profile picture or a default image
                      MailService.profilePictureURL != null
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(MailService.profilePictureURL!),
                              radius: 50,
                            )
                          : const CircleAvatar(
                              backgroundImage:
                                  AssetImage('lib/assets/images/Sky_Blue.png'),
                              radius: 50,
                            ),
                      const SizedBox(height: 20),
                      // Information Cards
                      _buildInfoCard('Username', MailService.username!),
                      _buildInfoCard('Name', MailService.name!),
                      _buildInfoCard('Surname', MailService.surname!),
                      _buildInfoCard('E-mail', MailService.email!),
                      // ...
                    ],
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: ListTile(
        leading: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
