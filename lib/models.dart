enum JobStatus {
  unscheduled,
  scheduled,
  inProgress,
  completed,
  cancelled,
}

enum PaymentStatus { unquoted, quoted, invoiced, paid }

class JobMaterial {
  final String name;
  final double price;
  final int quantity;

  JobMaterial(this.name, this.price, this.quantity);
}

class Job {
  final int id;
  String title;
  String? description;
  String client;
  String location;

  List<String> tags;

  DateTime? scheduledDate;
  JobStatus jobStatus;

  PaymentStatus paymentStatus;
  double? quotedPrice;

  List<JobMaterial> materials;

  List<JobAttachment> attachments;

  Job(
      {required this.id,
      required this.title,
      required this.client,
      required this.location,
      this.description,
      this.scheduledDate,
      this.jobStatus = JobStatus.unscheduled,
      this.paymentStatus = PaymentStatus.unquoted,
      this.quotedPrice,
      this.tags = const [],
      List<JobMaterial>? materials,
      List<JobAttachment>? attachments})
      : materials = materials ?? [],
        attachments = attachments ?? [];
}

class JobAttachment {
  final String url;
  final String? name;

  JobAttachment({required this.url, this.name});
}

// generate sample jobs
List<Job> sampleJobs = [
  Job(
    id: 1,
    title: 'A/C INSTALLATIONS',
    client: 'John Doe',
    location: '123 Any Street, Anytown, USA',
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
    scheduledDate: DateTime(2022, 10, 12),
    jobStatus: JobStatus.scheduled,
    paymentStatus: PaymentStatus.quoted,
    quotedPrice: 1000.0,
    tags: ['AC', 'installation'],
    materials: [
      JobMaterial('Air Conditioner', 500.0, 1),
      JobMaterial('Labour', 200.0, 2),
    ],
    attachments: [
      JobAttachment(url: 'https://picsum.photos/199', name: "Sample 1"),
      JobAttachment(url: 'https://picsum.photos/200', name: "Sample 2"),
    ],
  ),
  Job(
    id: 2,
    title: 'PLUMBING',
    client: 'Jane Doe',
    location: '456 Some Street, Othertown, USA',
    scheduledDate: DateTime(2022, 10, 15),
    jobStatus: JobStatus.inProgress,
    paymentStatus: PaymentStatus.unquoted,
    tags: ['Plumbing'],
    materials: [
      JobMaterial('Pipe', 100.0, 10),
      JobMaterial('Labour', 300.0, 1),
    ],
    attachments: [
      JobAttachment(url: 'https://picsum.photos/201', name: "Sample 3"),
    ],
  ),
];
