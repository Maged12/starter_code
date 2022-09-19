import 'package:flutter/material.dart';
import 'package:map_exam/models/note.dart';
import 'package:map_exam/presentation/notes_provider.dart';
import 'package:provider/provider.dart';

import '../../app/database.dart';

class HomeScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => NotesProvider()),
            StreamProvider<List<Note>>(
              create: (_) => Database().streamReference,
              initialData: const [],
            ),
          ],
          child: const HomeScreen(),
        ),
      );
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade200,
            child:
                Consumer<List<Note>>(builder: (BuildContext context, value, _) {
              return Text(
                '${value.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              );
            }),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Consumer<List<Note>>(
        builder: (BuildContext context, value, _) => ListView.separated(
            itemCount: value.length,
            separatorBuilder: (context, index) => const Divider(
                  color: Colors.blueGrey,
                ),
            itemBuilder: (context, index) {
              return ListTile(
                trailing: SizedBox(
                  width: 110.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.blue,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                title: Text(value[index].title!),
                subtitle: Selector<NotesProvider, bool>(
                  selector: (_, notesProvider) => notesProvider.isShowContent,
                  builder: (_, isShowContent, __) => isShowContent
                      ? Text(value[index].content!)
                      : const SizedBox.shrink(),
                ),
                onTap: () {},
                onLongPress: () {},
              );
            }),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'Show less. Hide notes content',
            tooltip: 'Show less. Hide notes content',
            onPressed: context.read<NotesProvider>().toggleShowContent,
            child: Selector<NotesProvider, bool>(
              selector: (_, notesProvider) => notesProvider.isShowContent,
              builder: (_, isShowContent, __) =>
                  Icon(isShowContent ? Icons.unfold_less : Icons.menu),
            ),
          ),

          /* Notes: for the "Show More" icon use: Icons.menu */

          FloatingActionButton(
            heroTag: 'Add a new note',
            child: const Icon(Icons.add),
            tooltip: 'Add a new note',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
