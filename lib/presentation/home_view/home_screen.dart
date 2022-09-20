import 'package:flutter/material.dart';
import 'package:map_exam/app/enums.dart';
import 'package:map_exam/models/note.dart';
import 'package:map_exam/presentation/edit_view/edit_screen.dart';
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
            final note = value[index];
            return ListTile(
              trailing: Selector<NotesProvider, int>(
                selector: (_, notesProvider) => notesProvider.editOrDeleteIndex,
                builder: (_, editOrDeleteIndex, __) => editOrDeleteIndex ==
                        index
                    ? SizedBox(
                        width: 110.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => Navigator.of(context).push(
                                EditScreen.route(ScreenType.edit, note: note),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.blue,
                              ),
                              onPressed: () =>
                                  Database().deleteNote("Document ${note.id}"),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              title: Text(note.title!),
              subtitle: Selector<NotesProvider, bool>(
                selector: (_, notesProvider) => notesProvider.isShowContent,
                builder: (_, isShowContent, __) => isShowContent
                    ? Text(note.content!)
                    : const SizedBox.shrink(),
              ),
              onTap: () => Navigator.of(context).push(
                EditScreen.route(ScreenType.view, note: note),
              ),
              onLongPress: () =>
                  context.read<NotesProvider>().changeIndex(index),
            );
          },
        ),
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
            onPressed: () => Navigator.of(context).push(
              EditScreen.route(ScreenType.add,
                  id: context.read<List<Note>>().length + 1),
            ),
          ),
        ],
      ),
    );
  }
}
