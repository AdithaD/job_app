import 'dart:io';

import 'package:intl/intl.dart';
import 'package:job_app/models/business_details.dart';
import 'package:job_app/models/job.dart';
import 'package:job_app/models/payment_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

const tableHeaders = [
  "Description",
  "Quantity",
  "Unit Price",
  "Total",
];

final testBusinessDetails = BusinessDetails(
  name: "Business Name",
  addressLine1: "Address Line 1",
  addressLine2: "Address Line 2",
  addressLine3: "Address Line 3",
  phoneNumber: "Phone Number",
  email: "email@address.com",
  abn: "ABN:1123123",
);

final testPaymentDetails = PaymentDetails(
  bankName: "Bank Name",
  accountName: "Account Name",
  accountNumber: "123456789",
  bsb: "123456",
);

class InvoicePdf {
  final Job job;
  final BusinessDetails? businessDetails;
  final PaymentDetails? paymentDetails;
  final int invoiceNumber;

  InvoicePdf(
      {required this.job,
      required this.businessDetails,
      required this.paymentDetails,
      this.invoiceNumber = 1});

  pw.Widget generateHeader() {
    String date = DateFormat("dd/MM/yyyy").format(DateTime.now());

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Logo
        pw.Container(
          height: 100,
          width: 100,
          color: PdfColors.blue,
        ),
        pw.SizedBox(width: 8),
        if (businessDetails != null) _addBusinessDetails(businessDetails!),
        pw.Spacer(),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              "TAX INVOICE",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text("Invoice #$invoiceNumber"),
            pw.Text(date)
          ],
        ),
      ],
    );
  }

  pw.Widget generateBusinessDetails() {
    final client = job.client;
    if (client == null) {
      return pw.Container();
    } else {
      return pw.Row(children: [
        // Business details
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              "To:",
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(client.name),
            pw.Text("Address Line 1"),
            pw.Text("Address Line 2"),
            pw.Text("Address Line 3"),
          ],
        ),
      ]);
    }
  }

  pw.Widget generateTable(Job job) {
    var tableData = job.materials.map((mat) {
      return [
        mat.name,
        mat.quantity.toString(),
        mat.price.toString(),
        (mat.quantity * mat.price).toStringAsFixed(2)
      ];
    }).toList();

    var table = pw.TableHelper.fromTextArray(
        border: pw.TableBorder.all(),
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          border: pw.TableBorder.all(),
          color: PdfColors.blueGrey500,
        ),
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
        ),
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
        },
        tableWidth: pw.TableWidth.max,
        headers: tableHeaders,
        data: tableData);

    return table;
  }

  pw.Widget generateTotal() {
    var subtotal = job.materials
        .map((mat) => mat.quantity * mat.price)
        .fold(0.0, (a, b) => a + b);

    var gst = subtotal * 0.1;

    var total = subtotal + gst;

    var totalTable = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("Subtotal:"),
          pw.Text("\$${subtotal.toStringAsFixed(2)}"),
        ]),
        pw.SizedBox(height: 4),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text("GST:"),
          pw.Text("\$${gst.toStringAsFixed(2)}"),
        ]),
        pw.Divider(),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text(
            "Total:",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            "\$${total.toStringAsFixed(2)}",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ]),
      ],
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          "Payment Details:",
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 20),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Bank Transfer",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                if (paymentDetails != null) ...[
                  pw.Text("Bank Name: ${paymentDetails!.bankName}"),
                  pw.Text("Account Name: ${paymentDetails!.accountName}"),
                  pw.Text("BSB: ${paymentDetails!.bsb}"),
                  pw.Text("Account Number: ${paymentDetails!.accountNumber}"),
                ],
              ],
            ),
            pw.SizedBox(
              width: 200,
              child: totalTable,
            ),
          ],
        )
      ],
    );
  }

  pw.Widget generateFooter() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
      pw.Text("Thank you for your business!",
          style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic)),
    ]);
  }

  void generateQuote() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(12.0),
            child: pw.Column(mainAxisSize: pw.MainAxisSize.max, children: [
              //Header
              generateHeader(),
              pw.SizedBox(
                height: 20,
              ),
              generateBusinessDetails(),
              pw.SizedBox(
                height: 20,
              ),
              pw.Expanded(
                child: pw.Column(children: [generateTable(job)]),
              ),
              pw.Flexible(
                flex: 1,
                child: generateTotal(),
              ),
              generateFooter()
            ]),
          );
        })); // Page

    // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
    final output = await getTemporaryDirectory();
    print("output: ${output.path}");
    final fileName = "${job.title}_quote.pdf";

    final file = File("${output.path}/$fileName");
    await file.writeAsBytes(await pdf.save());
  }

  pw.Widget _addBusinessDetails(BusinessDetails businessDetails) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(businessDetails.name,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        pw.Text(businessDetails.addressLine1),
        pw.Text(businessDetails.addressLine2),
        pw.Text(businessDetails.addressLine3),
        pw.Text(businessDetails.phoneNumber),
        pw.Text(businessDetails.email),
        pw.Text(businessDetails.abn),
      ],
    );
  }
}
