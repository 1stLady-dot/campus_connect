import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/event.dart';
import 'add_event_screen.dart';
import 'comment_screen.dart';

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    // Keeps your real-time listener active
    Provider.of<EventViewModel>(context, listen: false).listenToEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.grey[50], // Soft background for professional feel
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue[900]),
        title: Text(
          "Campus Safety Feed",
          style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
        ),
      ),
      body: eventVm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventVm.errorMessage != null
              ? Center(child: Text(eventVm.errorMessage!, style: TextStyle(color: Colors.red)))
              : eventVm.events.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: eventVm.events.length,
                      itemBuilder: (context, index) {
                        final event = eventVm.events[index];
                        return _buildSafetyCard(context, event, eventVm, userId);
                      },
                    ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue[900],
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEventScreen()),
        ),
        icon: const Icon(Icons.add_moderator, color: Colors.white),
        label: const Text("NEW REPORT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // --- REFINED SAFETY CARD ---
  Widget _buildSafetyCard(BuildContext context, Event event, EventViewModel eventVm, String userId) {
    bool isLiked = event.likes.contains(userId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red[50],
              child: Icon(Icons.security, color: Colors.red[800], size: 20),
            ),
            title: Text(
              event.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: Text(_formatDate(event.date), style: TextStyle(fontSize: 12)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              event.description,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
          ),
          
          // --- GPS VERIFICATION BADGE ---
          if (event.latitude != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.gps_fixed, size: 12, color: Colors.green[700]),
                    const SizedBox(width: 4),
                    Text("LOCATION VERIFIED", style: TextStyle(color: Colors.green[700], fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          
          const SizedBox(height: 12),
          const Divider(height: 1),
          
          // --- INTERACTION BAR (Likes & Comments) ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                // LIKE BUTTON
                TextButton.icon(
                  onPressed: () => eventVm.toggleLike(event.id, userId),
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey[600],
                    size: 20,
                  ),
                  label: Text("${event.likes.length}", style: TextStyle(color: Colors.grey[800])),
                ),
                const SizedBox(width: 10),
                // COMMENT BUTTON
                TextButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CommentScreen(event: event)
                  )),
                  icon: Icon(Icons.chat_bubble_outline, color: Colors.blue[800], size: 19),
                  label: Text("Comments", style: TextStyle(color: Colors.blue[800])),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.share_outlined, color: Colors.grey[600], size: 20),
                  onPressed: () {}, // Optional share feature
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shield_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No active safety reports.", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
          Text("The campus is currently secure.", style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}