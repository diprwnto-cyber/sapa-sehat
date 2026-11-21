import 'package:material_ui/material_ui.dart';
import '../../core/services/supabase_service.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({super.key});

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final _future = supabase.from('todos').select();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Todos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          final todos = snapshot.data ?? [];
          if (todos.isEmpty) {
            return const Center(
              child: Text('Tidak ada data todos.'),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(
                  todo['name']?.toString() ??
                      todo['title']?.toString() ??
                      'Item #$index',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
