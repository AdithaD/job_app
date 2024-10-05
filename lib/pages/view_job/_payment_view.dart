part of 'view_job_page.dart';

class _PaymentView extends StatelessWidget {
  final Job job;

  const _PaymentView({
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _ViewJobContainer(
        onEdit: () => showDialog(
            context: context,
            builder: (context) => _PaymentEditDialog(
                  job: job,
                )),
        title: "Payment",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ViewField(
                fieldName: "Status",
                child: PaymentStatusBadge(status: job.paymentStatus),
              ),
              const SizedBox(
                height: 16,
              ),
              if (job.quotedPrice != null)
                ViewField(
                    fieldName: "Amount",
                    child: Text("\$${job.quotedPrice!.toStringAsFixed(2)}")),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Generate Quote")),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("Generate Invoice"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentEditDialog extends ConsumerStatefulWidget {
  final Job job;

  const _PaymentEditDialog({required this.job});

  @override
  ConsumerState<_PaymentEditDialog> createState() => _PaymentEditDialogState();
}

class _PaymentEditDialogState extends ConsumerState<_PaymentEditDialog> {
  late PaymentStatus _newStatus;

  final formKey = GlobalKey<FormState>();

  var quotedPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newStatus = widget.job.paymentStatus;

    quotedPriceController.text = widget.job.quotedPrice?.toString() ?? "";
  }

  void _save(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var newJob = widget.job;
    newJob.paymentStatus = _newStatus;
    newJob.quotedPrice =
        double.tryParse(quotedPriceController.text) ?? widget.job.quotedPrice;

    var jobs = await ref.read(jobsPod.future);

    if (context.mounted) {
      await requestErrorHandler(
        context,
        () => jobs.update(widget.job.id!, body: newJob.toJson()),
      );

      ref.invalidate(jobByIdPod(widget.job.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 400,
        width: 400,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Payment Details",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Status",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 2),
                  DropdownButtonFormField(
                    value: _newStatus,
                    isExpanded: true,
                    padding: const EdgeInsets.all(2.0),
                    validator: (value) =>
                        value == null ? "Select a payment status" : null,
                    items: PaymentStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(
                                paymentStatusStringMap[status] ??
                                    status.toString(),
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        )
                        .toList(),
                    onChanged: (status) => setState(() {
                      _newStatus = status ?? widget.job.paymentStatus;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Quote Amount",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: quotedPriceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) =>
                          validateInt(value, "Amount", min: 0),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              ElevatedButton(
                onPressed: () {
                  _save(context);
                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
