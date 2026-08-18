import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_profile.dart';
import '../screens/settings_screen.dart';

final userProfileProvider =
    Provider<UserProfile>(
  (ref) {
    return const UserProfile(
      name: 'JosTech',
      email: 'jostech@gmail.com',
      avatarUrl: '' 
          // 'https://i.pravatar.cc/300',
    );
  },
);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final user =
        ref.watch(userProfileProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage(user.avatarUrl),
            ),

            const SizedBox(height: 20),

            Text(
              user.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(user.email),

            const SizedBox(height: 30),

            const ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('My orders'),
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}