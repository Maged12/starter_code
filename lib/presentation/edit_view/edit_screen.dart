import 'package:flutter/material.dart';
import 'package:map_exam/app/enums.dart';
import 'package:map_exam/models/note.dart';

class EditScreen extends StatefulWidget {
  final ScreenType screenType;
  final Note? note;

  static Route route(ScreenType type, {Note? note}) => MaterialPageRoute(
        builder: (_) => EditScreen(
          screenType: type,
          note: note,
        ),
      );

  const EditScreen({required this.screenType, this.note, Key? key})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController(
      text: widget.screenType == ScreenType.add ? "" : widget.note!.title,
    );
    _descriptionController = TextEditingController(
      text: widget.screenType == ScreenType.add ? "" : widget.note!.content,
    );
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String getScreenTitle() {
    switch (widget.screenType) {
      case ScreenType.add:
        return "Add new Note";
      case ScreenType.edit:
        return "Edit Note";
      case ScreenType.view:
        return "View Note";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Text(getScreenTitle()),
        actions: [
          if (widget.screenType != ScreenType.view)
            IconButton(
                icon: const Icon(
                  Icons.check_circle,
                  size: 30,
                ),
                onPressed: () {}),
          IconButton(
              icon: const Icon(
                Icons.cancel_sharp,
                size: 30,
              ),
              onPressed: () {}),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              enabled: widget.screenType != ScreenType.view,
              decoration: const InputDecoration(
                hintText: 'Type the title here',
              ),
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: TextFormField(
                  controller: _descriptionController,
                  enabled: widget.screenType != ScreenType.view,
                  maxLines: null,
                  expands: true,
                  decoration: const InputDecoration(
                    hintText: 'Type the description',
                  ),
                  onChanged: (value) {}),
            ),
          ],
        ),
      ),
    );
  }
}
