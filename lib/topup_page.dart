import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  double _currentBalance = 150000.00;
  TextEditingController _amountController = TextEditingController();
  String? _selectedQuickAmount;

  final List<String> _quickAmounts = [
    '50.000',
    '100.000',
    '200.000',
    '500.000',
  ];

  String _formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _handleTopUp() {
    String input = _amountController.text
        .replaceAll('.', '')
        .replaceAll(',', '');
    double? topUpAmount = double.tryParse(input);

    if (topUpAmount == null || topUpAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan jumlah top up yang valid.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Top Up'),
          content: Text(
            'Anda akan melakukan top up sebesar ${_formatCurrency(topUpAmount)}. Lanjutkan?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Simulasi: Top up ${_formatCurrency(topUpAmount)} berhasil!',
                    ),
                  ),
                );
              },
              child: const Text('Lanjut'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up Saldo'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.blue,
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saldo Saat Ini',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          _formatCurrency(_currentBalance),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Masukkan Jumlah Top Up',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                hintText: 'Min. 10.000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedQuickAmount = null;
                });
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Pilih Nominal Cepat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _quickAmounts.map((amount) {
                bool isSelected = _selectedQuickAmount == amount;
                return ChoiceChip(
                  label: Text(
                    _formatCurrency(double.parse(amount.replaceAll('.', ''))),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.blue.withOpacity(0.2),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedQuickAmount = amount;
                        _amountController.text = amount.replaceAll('.', '');
                      } else {
                        _selectedQuickAmount = null;
                        _amountController.clear();
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _handleTopUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Lanjutkan Top Up',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
