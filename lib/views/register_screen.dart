import 'package:ayur_care/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  List<String> dummyTreatmentOptions = [
    'Physiotherapy',
    'Acupuncture',
    'Chiropractic',
    'Massage Therapy',
  ];

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
              _buildTextField('Name', 'Enter your full name', nameController),
              const SizedBox(height: 20),
              _buildTextField(
                'Whatsapp Number',
                'Enter your Whatsapp number',
                whatsappController,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Address',
                'Enter your full address',
                addressController,
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                'Location',
                'Choose your location',
                selectedLocation,
                ['Kochi', 'Trivandrum', 'Calicut'],
                (value) => setState(() => selectedLocation = value),
              ),
              const SizedBox(height: 20),
              _buildDropdown(
                'Branch',
                'Select the branch',
                selectedBranch,
                ['Main Branch', 'North Branch', 'South Branch'],
                (value) => setState(() => selectedBranch = value),
              ),
              const SizedBox(height: 20),
              _buildTreatmentsSection(),
              const SizedBox(height: 20),
              _buildTextField('Total Amount', '', totalAmountController),
              const SizedBox(height: 20),
              _buildTextField('Discount Amount', '', discountAmountController),
              const SizedBox(height: 20),
              _buildPaymentOptions(),
              const SizedBox(height: 20),
              _buildTextField('Advance Amount', '', advanceAmountController),
              const SizedBox(height: 20),
              _buildTextField('Balance Amount', '', balanceAmountController),
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
    TextEditingController controller,
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
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
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
                  _buildDropdown(
                    'Treatment',
                    'Choose preferred treatment',
                    selectedTreatment,
                    dummyTreatmentOptions,
                    (value) => setState(() => selectedTreatment = value),
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
                  _buildDropdown(
                    'Treatment',
                    'Choose preferred treatment',
                    selectedTreatment,
                    dummyTreatmentOptions,
                    (value) => setState(() => selectedTreatment = value),
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
                      primary: Color(0xFF0F6238), // Your app's primary color
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
            _handleSave();
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

  void _handleSave() {
    print('Name: ${nameController.text}');
    print('WhatsApp: ${whatsappController.text}');
    print('Treatments: ${treatments.length}');
    if (selectedTime != null) {
      print('Treatment Time: $selectedTime');
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
