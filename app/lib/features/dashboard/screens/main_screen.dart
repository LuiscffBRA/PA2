import 'package:flutter/material.dart';
import 'package:pa2/core/theme/app_theme.dart';
import 'package:pa2/features/auth/services/auth_service.dart';
import 'package:pa2/features/feed/screens/feed_screen.dart';
import 'package:pa2/features/feed/screens/create_post_screen.dart';
import 'package:pa2/features/search/screens/search_screen.dart';
import 'package:pa2/features/chat/screens/inbox_screen.dart';
import 'package:pa2/features/user_profile/screens/user_profile_screen.dart';
import 'package:pa2/features/chat/services/chat_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final _authService = AuthService();

  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _setupTabs();
    _loadChatPrefs();
  }

  Future<void> _loadChatPrefs() async {
    await ChatService.loadLastInboxOpenTime();
    if (mounted) setState(() {});
  }

  void _setupTabs() {
    final isVendor = _authService.currentUser?.isVendor == true;

    if (isVendor) {
      _screens = [
        const FeedScreen(),
        const SearchScreen(),
        const CreatePostScreen(),
        const InboxScreen(),
        const UserProfileScreen(),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Postar'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ];
    } else {
      _screens = [
        const FeedScreen(),
        const SearchScreen(),
        const InboxScreen(),
        const UserProfileScreen(),
      ];
      _navItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('chat_messages')
            .stream(primaryKey: ['id'])
            .eq('receiver_id', _authService.currentUser?.id ?? ''),
        builder: (context, snapshot) {
          int unreadCount = 0;
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            unreadCount = messages.where((m) {
              final createdAt = DateTime.tryParse(m['created_at'].toString()) ?? DateTime.now();
              return createdAt.isAfter(ChatService.lastInboxOpenTime);
            }).length;
          }

          // Atualiza o ícone do Chat baseado no unreadCount
          final navItems = List<BottomNavigationBarItem>.from(_navItems);
          final chatIndex = navItems.indexWhere((item) => item.label == 'Chat');
          if (chatIndex != -1) {
            navItems[chatIndex] = BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(unreadCount > 99 ? '99+' : unreadCount.toString()),
                child: const Icon(Icons.chat_bubble_outline),
              ),
              activeIcon: Badge(
                isLabelVisible: unreadCount > 0,
                label: Text(unreadCount > 99 ? '99+' : unreadCount.toString()),
                child: const Icon(Icons.chat_bubble),
              ),
              label: 'Chat',
            );
          }

          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              if (navItems[index].label == 'Chat') {
                ChatService.saveLastInboxOpenTime(DateTime.now());
              }
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: Colors.grey,
            items: navItems,
          );
        }
      ),
    );
  }
}
