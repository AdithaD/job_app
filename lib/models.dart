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
  final String title;
  final String client;
  final String location;

  final List<String> tags;

  final DateTime? scheduledDate;
  final JobStatus jobStatus;

  final PaymentStatus paymentStatus;
  final double? quotedPrice;

  final List<JobMaterial> materials;

  final List<String> attachments;

  Job(
      {required this.id,
      required this.title,
      required this.client,
      required this.location,
      this.scheduledDate,
      this.jobStatus = JobStatus.unscheduled,
      this.paymentStatus = PaymentStatus.unquoted,
      this.quotedPrice,
      this.tags = const [],
      List<JobMaterial>? materials,
      List<String>? attachments})
      : materials = materials ?? [],
        attachments = attachments ?? [];
}

// generate sample jobs
List<Job> sampleJobs = [
  Job(
    id: 1,
    title: 'A/C INSTALLATIONS',
    client: 'John Doe',
    location: '123 Any Street, Anytown, USA',
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
      'https://picsum.photos/200',
      'https://picsum.photos/201',
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
      'https://picsum.photos/202',
    ],
  ),
];
