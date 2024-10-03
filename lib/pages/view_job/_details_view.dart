part of 'view_job_page.dart';

class _DetailsView extends StatelessWidget {
  const _DetailsView({
    required this.job,
  });

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        title: "Details",
        onEdit: () => showDialog(
            context: context,
            builder: (context) => _DetailsEditDialog(
                  job: job,
                )),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ViewField(
                fieldName: "Tags",
                child: Row(
                  children: job.tags
                      .map(
                        (tag) => Badge(
                          backgroundColor: Colors.blue,
                          label: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              tag.name,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      )
                      .expand((b) => [b, const SizedBox(width: 8)])
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ViewField(
                        fieldName: "Location", child: Text(job.location)),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                  child: ViewField(
                      fieldName: "Description",
                      child: Text(job.description ?? ""))),
            ],
          ),
        ),
      ),
    );
  }
}
