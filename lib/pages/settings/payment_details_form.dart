import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_app/api.dart';
import 'package:job_app/models/payment_details.dart';
import 'package:job_app/models/user.dart';

class PaymentDetailsForm extends ConsumerStatefulWidget {
  final PaymentDetails? payment;

  const PaymentDetailsForm({
    super.key,
    this.payment,
  });

  @override
  ConsumerState<PaymentDetailsForm> createState() => _PaymentDetailsFormState();
}

class _PaymentDetailsFormState extends ConsumerState<PaymentDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _bankNameController;
  late final TextEditingController _accountNumberController;
  late final TextEditingController _accountNameController;
  late final TextEditingController _bsbController;

  @override
  void initState() {
    super.initState();

    _bankNameController = TextEditingController(
      text: widget.payment?.bankName ?? "",
    );
    _accountNumberController = TextEditingController(
      text: widget.payment?.accountNumber ?? "",
    );
    _accountNameController = TextEditingController(
      text: widget.payment?.accountName ?? "",
    );
    _bsbController = TextEditingController(
      text: widget.payment?.bsb ?? "",
    );
  }

  @override
  void dispose() {
    super.dispose();

    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountNameController.dispose();
    _bsbController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Payment",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Bank Name',
                            ),
                            controller: _bankNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Bank Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'BSB',
                            ),
                            controller: _bsbController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'BSB is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Account Number',
                            ),
                            controller: _accountNumberController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Account Number is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Account Name',
                            ),
                            controller: _accountNameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Account Name is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _savePaymentDetails(context),
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePaymentDetails(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final payment = PaymentDetails(
        bankName: _bankNameController.text,
        bsb: _bsbController.text,
        accountNumber: _accountNumberController.text,
        accountName: _accountNameController.text,
      );

      await requestErrorHandler(
        context,
        () async {
          var userCollection =
              (await ref.read(pocketBasePod.future)).collection('users');

          var uId = await ref.read(userId.future);

          var newUser = User.fromRecord(await userCollection.getOne(uId));

          newUser.payment = PaymentDetails(
            bankName: payment.bankName,
            bsb: payment.bsb,
            accountNumber: payment.accountNumber,
            accountName: payment.accountName,
          );

          await userCollection.update(uId, body: newUser.toJson());

          ref.invalidate(userDetailsPod);
        },
        errorMessage: "Error saving payment details",
        successMessage: "Details saved.",
      );
    }
  }
}
