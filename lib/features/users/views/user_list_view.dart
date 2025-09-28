import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hipster/features/users/view_model/user_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserListPage extends ConsumerStatefulWidget {
  const UserListPage({super.key});

  @override
  ConsumerState<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends ConsumerState<UserListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((v) {
      ref.read(userListVmProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userListVmProvider);
    final vm = ref.read(userListVmProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: RefreshIndicator(
        onRefresh: () => vm.load(refresh: true),
        child: Builder(
          builder: (_) {
            if (state.loading && state.users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null && state.users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Failed to load. Showing cache if any.'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => vm.load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.users.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final u = state.users[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: u.avatar ?? "",
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,

                        placeholder: (_, __) => const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (_, __, ___) => const Icon(Icons.person),
                      ),
                    ),
                  ),
                  title: Text(u.firstName ?? ""),
                  subtitle: Text(u.email ?? ""),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => vm.load(),
        child: const Icon(Icons.sync),
      ),
    );
  }
}
