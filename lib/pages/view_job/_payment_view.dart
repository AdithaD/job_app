part of 'view_job_page.dart';

class _PaymentView extends ConsumerWidget {
  final Job job;

  const _PaymentView({required this.job});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref
        .watch(userDetailsPod)
        .mapOrNull(data: (data) => User.fromRecord(data.value));

    return Flexible(
      child: _ViewJobContainer(
        onEdit: () => showDialog(
          context: context,
          builder: (context) => _PaymentEditDialog(job: job),
        ),
        title: "Payment",
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16.0,
            children: [
              ViewField(
                fieldName: "Status",
                child: PaymentStatusBadge(status: job.paymentStatus),
              ),
              if (job.quotedPrice != null)
                ViewField(
                  fieldName: "Quoted amount",
                  child: Text("\$${job.quotedPrice!.toStringAsFixed(2)}"),
                ),
              ViewField(
                fieldName: "Received amount",
                child: Text("\$${job.receivedAmount.toStringAsFixed(2)}"),
              ),
              ViewField(
                fieldName: "Discount",
                child: Text("${(job.discount * 100).toStringAsFixed(0)}%"),
              ),
              Spacer(),
              if (user != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => InvoicePdf(
                        job: job,
                        businessDetails: user.business,
                        paymentDetails: user.payment,
                        invoiceNumber: job.jobId,
                      ).generate(),
                      child: const Text("Generate Quote"),
                    ),
                    ElevatedButton(
                      onPressed: () => InvoicePdf(
                        job: job,
                        businessDetails: user.business,
                        paymentDetails: user.payment,
                        invoiceNumber: job.jobId,
                        isInvoice: true,
                      ).generate(),
                      child: const Text("Generate Invoice"),
                    ),
                  ],
                ),
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

  late TextEditingController receivedAmountController = TextEditingController(
    text: widget.job.receivedAmount.toString(),
  );
  late TextEditingController discountController = TextEditingController(
    text: widget.job.discount.toString(),
  );

  @override
  void initState() {
    super.initState();
    _newStatus = widget.job.paymentStatus;

    receivedAmountController.text = widget.job.receivedAmount.toString();
    quotedPriceController.text = widget.job.quotedPrice?.toString() ?? "";
    discountController.text = (widget.job.discount * 100).toString();
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
    newJob.discount = double.parse(discountController.text) / 100;

    await requestErrorHandler(
      context,
      () async {
        var jobs = await ref.read(jobsPod.future);
        await jobs.update(widget.job.id!, body: newJob.toJson());
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      errorMessage: "Error saving payment details",
      successMessage: "Payment details saved",
    );

    ref.invalidate(jobByIdPod(widget.job.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          height: 600,
          width: 700,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 16.0,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Payment Details",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 16.0),
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
                            paymentStatusStringMap[PaymentStatus
                                    .values[index]] ??
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
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: quotedPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[\d\.]+$')),
                  ],
                  validator: (value) =>
                      validateDouble(value, "Quoted amount", min: 0),
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: 'Quoted amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: receivedAmountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[\d\.]+$')),
                  ],
                  validator: (value) =>
                      validateDouble(value, "Received amount", min: 0),
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: "Received Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[\d\.]+$')),
                  ],
                  validator: (value) =>
                      validateDouble(value, "Discount", min: 0, max: 100),
                  maxLines: 1,
                  decoration: const InputDecoration(
                    labelText: "Discount (%)",
                    border: OutlineInputBorder(),
                  ),
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
      ),
    );
  }
}
