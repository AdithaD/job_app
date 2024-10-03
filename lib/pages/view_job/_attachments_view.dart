part of 'view_job_page.dart';

class _AttachmentsView extends StatelessWidget {
  final Job job;
  const _AttachmentsView({
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Attachments",
        showEditButton: false,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var att = job.attachments[index];

                    return ListTile(
                      title: Text(att.name),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 4.0),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                  itemCount: job.attachments.length,
                ),
              ),
              const Divider(),
              LargeElevatedButton(
                onPressed: () {},
                label: 'Add attachments',
              )
            ],
          ),
        ),
      ),
    );
  }
}
