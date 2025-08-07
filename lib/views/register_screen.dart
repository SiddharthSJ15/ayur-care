import 'package:ayur_care/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ayur_care/provider/ayur_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
    loadCustomFont();
    Future.microtask(() {
      final provider = Provider.of<AyurProvider>(context, listen: false);
      provider.fetchBranches();
      provider.fetchTreatments();
    });
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountAmountController =
      TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController balanceAmountController = TextEditingController();

  String? selectedLocation;
  String? selectedBranch;
  String selectedPaymentOption = 'Cash';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  List<Treatment> treatments = [];

  final Map<String, List<String>> keralaBranches = {
    'Thiruvananthapuram': [
      'Neyyattinkara',
      'Varkala',
      'Attingal',
      'Kazhakoottam',
      'Poovar',
    ],
    'Kollam': [
      'Punalur',
      'Paravur',
      'Karunagappally',
      'Kottarakkara',
      'Anchal',
    ],
    'Pathanamthitta': [
      'Adoor',
      'Thiruvalla',
      'Ranni',
      'Mallappally',
      'Kozhencherry',
    ],
    'Alappuzha': [
      'Cherthala',
      'Kayamkulam',
      'Mavelikkara',
      'Haripad',
      'Ambalapuzha',
    ],
    'Kottayam': [
      'Changanassery',
      'Pala',
      'Ettumanoor',
      'Vaikom',
      'Mundakayam',
      'Erattupetta',
      'Kanjirappally',
    ],
    'Idukki': ['Thodupuzha', 'Munnar', 'Kumily', 'Kattappana', 'Painavu'],
    'Ernakulam': [
      'Aluva',
      'Perumbavoor',
      'Angamaly',
      'Kothamangalam',
      'Muvattupuzha',
      'North Paravur',
    ],
    'Thrissur': [
      'Chalakudy',
      'Kodungallur',
      'Irinjalakuda',
      'Kunnamkulam',
      'Guruvayur',
    ],
    'Palakkad': ['Ottappalam', 'Shoranur', 'Chittur', 'Pattambi', 'Mannarkkad'],
    'Malappuram': [
      'Tirur',
      'Perinthalmanna',
      'Ponnani',
      'Nilambur',
      'Kondotty',
    ],
    'Kozhikode': ['Vadakara', 'Koyilandy', 'Feroke', 'Ramanattukara', 'Mukkom'],
    'Wayanad': [
      'Kalpetta',
      'Mananthavady',
      'Sulthan Bathery',
      'Meppadi',
      'Panamaram',
    ],
    'Kannur': [
      'Thalassery',
      'Payyanur',
      'Iritty',
      'Mattannur',
      'Koothuparamba',
    ],
    'Kasaragod': ['Kanhangad', 'Nileshwar', 'Uppala', 'Manjeshwar', 'Bekal'],
  };

  List<String> get availableLocations => keralaBranches.keys.toList();
  List<String> get availableBranches =>
      selectedLocation != null ? (keralaBranches[selectedLocation!] ?? []) : [];

  late final pw.Font robotoFont;
  Future<void> loadCustomFont() async {
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    robotoFont = pw.Font.ttf(fontData);
  }

  Future<void> _generatePDF(
    DateTime treatmentDate,
    TimeOfDay treatmentTime,
  ) async {
    final pdf = pw.Document();

    // Load assets
    final logoData = await rootBundle.load('assets/ayur_care.png');
    final bgLogoData = await rootBundle.load('assets/ayur_care.png');
    final signatureData = await rootBundle.load('assets/signature.png');

    final logo = pw.MemoryImage(logoData.buffer.asUint8List());
    final bgLogo = pw.MemoryImage(bgLogoData.buffer.asUint8List());
    final signature = pw.MemoryImage(signatureData.buffer.asUint8List());

    // Calculate totals
    double totalAmount = double.tryParse(totalAmountController.text) ?? 0;
    double discountAmount = double.tryParse(discountAmountController.text) ?? 0;
    double advanceAmount = double.tryParse(advanceAmountController.text) ?? 0;
    double balanceAmount = double.tryParse(balanceAmountController.text) ?? 0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Background logo (watermark)
              pw.Positioned(
                left: 150,
                top: 200,
                child: pw.Opacity(
                  opacity: 0.1,
                  child: pw.Image(bgLogo, width: 300, height: 300),
                ),
              ),

              // Main content
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header with logo and company info
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Image(logo, width: 80, height: 80),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text(
                              'KUMARAKOM',
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              'Cheepunkal P.O. Kumarakom, kottayam, Kerala - 686563',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'e-mail: unknown@gmail.com',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'Mob: +91 9876543210 | +91 9876543210',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 2),
                            pw.Text(
                              'GST No: 32AABCU9603R1ZW',
                              style: pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 30),

                  // Patient Details Section
                  pw.Text(
                    'Patient Details',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: const PdfColor.fromInt(0xFF4CAF50),
                    ),
                  ),

                  pw.SizedBox(height: 15),

                  // Patient info in two columns
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Left column
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Name', nameController.text),
                            pw.SizedBox(height: 8),
                            _buildDetailRow('Address', addressController.text),
                            pw.SizedBox(height: 8),
                            _buildDetailRow(
                              'WhatsApp Number',
                              '+91 ${whatsappController.text}',
                            ),
                          ],
                        ),
                      ),

                      pw.SizedBox(width: 40),

                      // Right column
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow(
                              'Booked On',
                              '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year} | ${_formatTimeOfDay(TimeOfDay.now())}',
                            ),
                            pw.SizedBox(height: 8),
                            _buildDetailRow(
                              'Treatment Date',
                              '${treatmentDate.day.toString().padLeft(2, '0')}/${treatmentDate.month.toString().padLeft(2, '0')}/${treatmentDate.year}',
                            ),
                            pw.SizedBox(height: 8),
                            _buildDetailRow(
                              'Treatment Time',
                              _formatTimeOfDay(treatmentTime),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 30),

                  // Treatment Table
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(5),
                    ),
                    child: pw.Table(
                      border: pw.TableBorder.all(color: PdfColors.grey300),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(3),
                        1: const pw.FlexColumnWidth(1.5),
                        2: const pw.FlexColumnWidth(1),
                        3: const pw.FlexColumnWidth(1),
                        4: const pw.FlexColumnWidth(1.5),
                      },
                      children: [
                        // Header
                        pw.TableRow(
                          decoration: const pw.BoxDecoration(
                            color: PdfColor.fromInt(0xFFF5F5F5),
                          ),
                          children: [
                            _buildTableHeader('Treatment'),
                            _buildTableHeader('Price'),
                            _buildTableHeader('Male'),
                            _buildTableHeader('Female'),
                            _buildTableHeader('Total'),
                          ],
                        ),

                        // Treatment rows
                        ...treatments.map((treatment) {
                          int totalCount =
                              treatment.maleCount + treatment.femaleCount;
                          double treatmentTotal = 230.0 * totalCount;

                          return pw.TableRow(
                            children: [
                              _buildTableCell(treatment.name),
                              pw.Row(children: [_buildTableCell('₹230')]),
                              _buildTableCell(treatment.maleCount.toString()),
                              _buildTableCell(treatment.femaleCount.toString()),
                              _buildTableCell(
                                '₹${treatmentTotal.toStringAsFixed(0)}',
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Amount Summary
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          _buildAmountRow(
                            'Total Amount',
                            '₹${totalAmount.toStringAsFixed(0)}',
                          ),
                          pw.SizedBox(height: 5),
                          _buildAmountRow(
                            'Discount',
                            '₹${discountAmount.toStringAsFixed(0)}',
                          ),
                          pw.SizedBox(height: 5),
                          _buildAmountRow(
                            'Advance',
                            '₹${advanceAmount.toStringAsFixed(0)}',
                          ),
                          pw.SizedBox(height: 10),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey400),
                              borderRadius: pw.BorderRadius.circular(3),
                            ),
                            child: pw.Text(
                              'Balance: ₹${balanceAmount.toStringAsFixed(0)}',
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  pw.SizedBox(height: 20),

                  // Thank you message and signature
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Thank you for choosing us',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: const PdfColor.fromInt(0xFF4CAF50),
                        ),
                        textAlign: pw.TextAlign.center,
                      ),

                      pw.SizedBox(height: 10),

                      pw.Text(
                        'Your well-being is our commitment, and we\'re honored\nyou\'ve entrusted us with your health journey',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey600,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),

                      pw.SizedBox(height: 30),

                      // Signature
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [pw.Image(signature, width: 100, height: 50)],
                      ),

                      pw.SizedBox(height: 20),

                      // Footer note
                      pw.Text(
                        '"Booking amount is non-refundable, and it\'s important to arrive on the allotted time for your treatment"',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey600,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Show PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Patient_Registration_${nameController.text}',
    );
  }

  // Helper methods for PDF
  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 80,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: const PdfColor.fromInt(0xFF4CAF50),
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildTableCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 11, font: robotoFont, color: PdfColors.grey700),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildAmountRow(String label, String amount) {
    return pw.Container(
      width: 200,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
          ),
          pw.Text(
            amount,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey800,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Register',
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF333333),
            ),
            onPressed: () {},
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE0E0E0)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                'Name',
                'Enter your full name',
                nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              _buildTextField(
                'Whatsapp Number',
                'Enter your Whatsapp number',
                whatsappController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your WhatsApp number';
                  }
                  if (value.length != 10) {
                    return 'Please enter a valid 10-digit number';
                  }
                  return null;
                },
              ),

              _buildTextField(
                'Address',
                'Enter your full address',
                addressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                'Location',
                'Choose your location',
                selectedLocation,
                availableLocations,
                (value) => setState(() {
                  selectedLocation = value;
                  selectedBranch = null;
                }),
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                'Branch',
                'Select the branch',
                selectedBranch,
                availableBranches,
                (value) => setState(() => selectedBranch = value),
              ),
              const SizedBox(height: 20),
              _buildTreatmentsSection(),
              const SizedBox(height: 20),
              _buildTextField(
                'Total Amount',
                '',
                totalAmountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter total amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField('Discount Amount', '', discountAmountController),
              const SizedBox(height: 20),
              _buildPaymentOptions(),
              const SizedBox(height: 20),
              _buildTextField(
                'Advance Amount',
                '',
                advanceAmountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter advance amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Balance Amount',
                '',
                balanceAmountController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter balance amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildDateField(),
              const SizedBox(height: 20),
              _buildTimeField(),
              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    String? Function(String?)? validator, // Add this parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator, // Add this line
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF999999),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String hint,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w100,
                color: Color(0xFF999999),
                fontSize: 12,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF666666),
            ),
            items: items
                .map(
                  (String item) =>
                      DropdownMenuItem<String>(value: item, child: Text(item)),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Treatments',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        if (treatments.isNotEmpty)
          ...treatments.asMap().entries.map((entry) {
            int index = entry.key;
            Treatment treatment = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${index + 1}. ${treatment.name}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF333333),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            treatments.removeAt(index);
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Male',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF4CAF50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              treatment.maleCount.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 32),
                      Row(
                        children: [
                          Text(
                            'Female',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: const Color(0xFF4CAF50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              treatment.femaleCount.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF333333),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => _showEditTreatmentDialog(index, treatment),
                        child: const Icon(
                          Icons.edit,
                          color: Color(0xFF4CAF50),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        GestureDetector(
          onTap: _showAddTreatmentDialog,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+ Add Treatments',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4CAF50),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddTreatmentDialog() {
    String? selectedTreatment;
    int maleCount = 0;
    int femaleCount = 0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Choose Treatment"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<AyurProvider>(
                    builder: (context, provider, _) {
                      return _buildDropdown(
                        'Treatment',
                        'Choose preferred treatment',
                        selectedTreatment,
                        provider.treatments.map((t) => t.name ?? '').toList(),
                        (value) => setState(() => selectedTreatment = value),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: kTreatmentCardColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: const Text("Male"),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(
                              () =>
                                  maleCount = maleCount > 0 ? maleCount - 1 : 0,
                            ),
                            icon: const Icon(
                              Icons.remove_circle,
                              color: kPrimaryColor,
                              size: 40,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(maleCount.toString()),
                          ),
                          IconButton(
                            onPressed: () => setState(() => maleCount++),
                            icon: const Icon(
                              Icons.add_circle,
                              color: kPrimaryColor,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: kTreatmentCardColor,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: const Text("Female"),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(
                              () => femaleCount = femaleCount > 0
                                  ? femaleCount - 1
                                  : 0,
                            ),
                            icon: const Icon(
                              Icons.remove_circle,
                              color: kPrimaryColor,
                              size: 40,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(femaleCount.toString()),
                          ),
                          IconButton(
                            onPressed: () => setState(() => femaleCount++),
                            icon: const Icon(
                              Icons.add_circle,
                              color: kPrimaryColor,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTreatment != null) {
                  setState(() {
                    treatments.add(
                      Treatment(
                        id: treatments.length + 1,
                        name: selectedTreatment!,
                        maleCount: maleCount,
                        femaleCount: femaleCount,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F6238),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: kPrimaryButtonTextColor, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditTreatmentDialog(int index, Treatment treatment) {
    String? selectedTreatment = treatment.name;
    int maleCount = treatment.maleCount;
    int femaleCount = treatment.femaleCount;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Edit Treatment"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<AyurProvider>(
                    builder: (context, provider, _) {
                      return _buildDropdown(
                        'Treatment',
                        'Choose preferred treatment',
                        selectedTreatment,
                        provider.treatments.map((t) => t.name ?? '').toList(),
                        (value) => setState(() => selectedTreatment = value),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Male"),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(
                              () =>
                                  maleCount = maleCount > 0 ? maleCount - 1 : 0,
                            ),
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.green,
                            ),
                          ),
                          Text(maleCount.toString()),
                          IconButton(
                            onPressed: () => setState(() => maleCount++),
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Female"),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => setState(
                              () => femaleCount = femaleCount > 0
                                  ? femaleCount - 1
                                  : 0,
                            ),
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.green,
                            ),
                          ),
                          Text(femaleCount.toString()),
                          IconButton(
                            onPressed: () => setState(() => femaleCount++),
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedTreatment != null) {
                  setState(() {
                    treatments[index] = Treatment(
                      id: treatment.id,
                      name: selectedTreatment!,
                      maleCount: maleCount,
                      femaleCount: femaleCount,
                    );
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F6238),
              ),
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Option',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: ['Cash', 'Card', 'UPI'].map((option) {
            return Expanded(
              child: Row(
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: selectedPaymentOption,
                    onChanged: (value) =>
                        setState(() => selectedPaymentOption = value!),
                    activeColor: const Color(0xFF4CAF50),
                  ),
                  Text(
                    option,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Treatment Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2025, 12, 31),
            );
            if (picked != null) setState(() => selectedDate = picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "Select date",
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedDate != null
                        ? const Color(0xFF333333)
                        : const Color(0xFF999999),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFF999999),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Treatment Time',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: selectedTime ?? TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF0F6238),
                      onPrimary: Colors.white,
                      onSurface: Color(0xFF333333),
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF0F6238),
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                selectedTime = picked;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  selectedTime != null
                      ? selectedTime!.format(context)
                      : "Select treatment time",
                  style: TextStyle(
                    fontSize: 14,
                    color: selectedTime != null
                        ? const Color(0xFF333333)
                        : const Color(0xFF999999),
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: Color(0xFF999999),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (treatments.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please add at least one treatment'),
                ),
              );
              return;
            }
            if (selectedDate == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a treatment date')),
              );
              return;
            }
            if (selectedTime == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a treatment time')),
              );
              return;
            }
            _handleSave(selectedDate!, selectedTime!);
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: kPrimaryButtonTextColor,
          backgroundColor: const Color(0xFF0F6238),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _handleSave(DateTime treatmentDate, TimeOfDay treatmentTime) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Generate and show PDF
      await _generatePDF(treatmentDate, treatmentTime);

      // Hide loading
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration completed successfully!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    } catch (e) {
      // Hide loading
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    whatsappController.dispose();
    addressController.dispose();
    totalAmountController.dispose();
    discountAmountController.dispose();
    advanceAmountController.dispose();
    balanceAmountController.dispose();
    super.dispose();
  }
}

class Treatment {
  final int id;
  String name;
  int maleCount;
  int femaleCount;

  Treatment({
    required this.id,
    required this.name,
    required this.maleCount,
    required this.femaleCount,
  });
}
