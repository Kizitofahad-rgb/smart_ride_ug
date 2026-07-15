import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/routes_repository.dart';
import 'data/stop.dart';

/// Step 1 of "Find My Bus": passenger types where they're going, picks a
/// stop, and we hand them off to [RouteSelectionScreen] with that stop.
class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  State<DestinationSearchScreen> createState() =>
      _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  final RoutesRepository _repository = RoutesRepository();
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        title: const Text('Where are you headed?'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search a bus stop or destination…',
                hintStyle: const TextStyle(color: Color(0xFF64748B)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Stop>>(
              stream: _repository.watchAllStops(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Could not load stops: ${snapshot.error}',
                      style: const TextStyle(color: Color(0xFFF59E0B)),
                    ),
                  );
                }

                final allStops = snapshot.data ?? const <Stop>[];
                if (allStops.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No stops have been added yet. Ask an operator to '
                            'set up routes and stops first.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF94A3B8)),
                      ),
                    ),
                  );
                }

                final filtered = _query.isEmpty
                    ? allStops
                    : allStops
                    .where((s) => s.name
                    .toLowerCase()
                    .contains(_query.toLowerCase()))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'No stops match your search.',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(
                    color: Color(0xFF1E293B),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final stop = filtered[index];
                    return ListTile(
                      leading: const Icon(Icons.location_on,
                          color: Color(0xFF60A5FA)),
                      title: Text(
                        stop.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: const Icon(Icons.chevron_right,
                          color: Color(0xFF64748B)),
                      onTap: () => context.push(
                        '/route-selection',
                        extra: stop,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}