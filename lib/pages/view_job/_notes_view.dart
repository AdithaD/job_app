part of 'view_job_page.dart';

class _NotesView extends ConsumerWidget {
  final Job job;
  const _NotesView({
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var sortedNotes = job.notes.toList();
    sortedNotes.sort((a, b) => b.updated!.compareTo(a.updated!));

    ref.watch(notesPod);

    return Flexible(
      child: _ViewJobContainer(
        title: "Notes",
        showEditButton: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: job.notes.length,
                      itemBuilder: (context, index) {
                        var note = sortedNotes[index];

                        return ViewJobListCard(
                          onEdit: () => _editNote(context, note),
                          onDelete: () => _deleteNote(context, ref, note),
                          updated: note.updated!,
                          child: Text(note.text),
                        );
                      })),
              const Divider(),
              LargeElevatedButton(
                  onPressed: () => _editNote(context, Note(text: "")),
                  label: "Add note"),
            ],
          ),
        ),
      ),
    );
  }

  void _editNote(BuildContext context, Note note) async {
    await showDialog(
        context: context,
        builder: (context) => _EditNoteDialog(note: note, jobId: job.id!));
  }

  void _deleteNote(BuildContext context, WidgetRef ref, Note note) async {
    await requestErrorHandler(
      context,
      () async {
        var jobsCollection = await ref.read(jobsPod.future);

        await jobsCollection.update(job.id!, body: {"notes-": note.id});

        var notesCollection = await ref.read(notesPod.future);

        await notesCollection.delete(note.id!);

        ref.invalidate(jobByIdPod(job.id!));
      },
      errorMessage: "Error deleting note",
      successMessage: "Note deleted.",
    );
  }
}

class _EditNoteDialog extends ConsumerWidget {
  final Note note;
  final String jobId;

  const _EditNoteDialog({required this.note, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = TextEditingController(text: note.text);
    return Dialog(
      child: SizedBox(
        width: 400,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Edit note", style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Note',
                    hintText: 'Enter your note',
                  ),
                  minLines: 10,
                  maxLines: 12,
                  controller: controller,
                  autofocus: true,
                ),
              ),
              const Divider(),
              LargeElevatedButton(
                  onPressed: () => _save(context, controller, ref),
                  label: "Save"),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, TextEditingController controller,
      WidgetRef ref) async {
    await requestErrorHandler(
      context,
      () async {
        var notesCollection = await ref.read(notesPod.future);
        var jobsCollection = await ref.read(jobsPod.future);

        var newNote = note;
        newNote.text = controller.text;

        if (newNote.id == null) {
          newNote.owner = await ref.read(userId.future) as String;
          var json = newNote.toJson();

          var newNoteRm = await notesCollection.create(body: json);
          await jobsCollection.update(jobId, body: {"notes+": newNoteRm.id});

          ref.invalidate(notesPod);
          ref.invalidate(jobByIdPod);
        } else {
          await notesCollection.update(note.id!, body: newNote.toJson());
          ref.invalidate(notesPod);
        }
      },
      errorMessage: "Error saving note",
      successMessage: "Note saved.",
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
