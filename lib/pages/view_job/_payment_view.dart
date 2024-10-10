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
                  fieldName: "Quoted amount",
                  child: Text("\$${job.quotedPrice!.toStringAsFixed(2)}"),
                ),
              const SizedBox(
                height: 16,
              ),
              ViewField(
                fieldName: "Received amount",
                child: Text(
                  "\$${job.receivedAmount.toStringAsFixed(2)}",
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => InvoicePdf(
                            job: job,
                            businessDetails: testBusinessDetails,
                            paymentDetails: testPaymentDetails,
                          ).generateQuote(),
                      child: const Text("Generate Quote")),
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

  late Set<PaymentStatus> _selectedPaymentStatus;

  late TextEditingController receivedAmountController =
      TextEditingController(text: widget.job.receivedAmount.toString());

  @override
  void initState() {
    super.initState();
    _newStatus = widget.job.paymentStatus;

    receivedAmountController.text = widget.job.receivedAmount.toString();
    quotedPriceController.text = widget.job.quotedPrice?.toString() ?? "";
    _selectedPaymentStatus = LinkedHashSet.from([widget.job.paymentStatus]);
  }

  void _save(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var newJob = widget.job;

    newJob.paymentStatus = _newStatus;
    newJob.quotedPrice =
        double.tryParse(quotedPriceController.text) ?? widget.job.quotedPrice;
    newJob.receivedAmount = double.parse(receivedAmountController.text);

    await requestErrorHandler(
      context,
      () async {
        var jobs = await ref.read(jobsPod.future);
        await jobs.update(
          widget.job.id!,
          body: newJob.toJson(),
        );
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );

    ref.invalidate(jobByIdPod(widget.job.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 450,
        width: 550,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Payment Status",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton(
                      expandedInsets: EdgeInsets.all(2.0),
                      segments: List.generate(
                        PaymentStatus.values.length,
                        (index) => ButtonSegment<PaymentStatus>(
                          value: PaymentStatus.values[index],
                          label: Text(
                            paymentStatusStringMap[
                                    PaymentStatus.values[index]] ??
                                PaymentStatus.values[index].toString(),
                          ),
                        ),
                      ),
                      selected: _selectedPaymentStatus,
                      onSelectionChanged: (value) {
                        setState(() {
                          _newStatus = value.first;
                          _selectedPaymentStatus = value;
                        });
                      }),
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^[\d\.]+$'))
                      ],
                      validator: (value) =>
                          validateDouble(value, "Quoted amount", min: 0),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Received Amount",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      controller: receivedAmountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^[\d\.]+$'))
                      ],
                      validator: (value) =>
                          validateDouble(value, "Received amount", min: 0),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Divider(),
              LargeElevatedButton(
                onPressed: () => _save(context),
                label: "Save",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
