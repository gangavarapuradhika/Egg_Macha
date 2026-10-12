import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets.dart';

class AddressPage extends StatefulWidget {
  final bool selectForCheckout;

  const AddressPage({
    super.key,
    this.selectForCheckout = false,
  });

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool _isSaving = false;

  Future<void> _addAddress([DeliveryAddress? existing]) async {
    if (_isSaving || !mounted) return;

    final formKey = GlobalKey<FormState>();

    final controllers = <TextEditingController>[
      TextEditingController(text: existing?.fullName ?? ''),
      TextEditingController(text: existing?.phone ?? ''),
      TextEditingController(text: existing?.house ?? ''),
      TextEditingController(text: existing?.street ?? ''),
      TextEditingController(text: existing?.city ?? ''),
      TextEditingController(text: existing?.state ?? ''),
      TextEditingController(text: existing?.pinCode ?? ''),
      TextEditingController(text: existing?.landmark ?? ''),
    ];

    final labels = <String>[
      'Full name',
      'Mobile number',
      'House / Flat number',
      'Street / Area',
      'City',
      'State',
      'PIN code',
      'Landmark (optional)',
    ];

    List<String>? values;

    try {
      values = await showDialog<List<String>>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              existing == null
                  ? 'Add delivery address'
                  : 'Edit delivery address',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            content: SizedBox(
              width: 420,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      labels.length,
                      (index) {
                        final isPhone = index == 1;
                        final isPinCode = index == 6;
                        final isOptional = index == 7;

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: TextFormField(
                            controller: controllers[index],
                            keyboardType: isPhone || isPinCode
                                ? TextInputType.number
                                : TextInputType.text,
                            textCapitalization: isPhone || isPinCode
                                ? TextCapitalization.none
                                : TextCapitalization.words,
                            maxLength: isPhone
                                ? 10
                                : isPinCode
                                    ? 6
                                    : null,
                            decoration: InputDecoration(
                              labelText: labels[index],
                              counterText: '',
                              prefixIcon: Icon(
                                isPhone
                                    ? Icons.phone_outlined
                                    : isPinCode
                                        ? Icons.markunread_mailbox_outlined
                                        : index == 0
                                            ? Icons.person_outline
                                            : Icons.location_on_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              final text = value?.trim() ?? '';

                              if (isOptional) {
                                return null;
                              }

                              if (text.isEmpty) {
                                return 'Please enter '
                                    '${labels[index].toLowerCase()}';
                              }

                              if (isPhone &&
                                  !RegExp(r'^[0-9]{10}$').hasMatch(text)) {
                                return 'Enter a valid 10-digit '
                                    'mobile number';
                              }

                              if (isPinCode &&
                                  !RegExp(r'^[0-9]{6}$').hasMatch(text)) {
                                return 'Enter a valid 6-digit PIN code';
                              }

                              return null;
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final form = formKey.currentState;

                  if (form == null || !form.validate()) {
                    return;
                  }

                  final addressValues = controllers
                      .map((controller) => controller.text.trim())
                      .toList();

                  Navigator.of(dialogContext).pop(addressValues);
                },
                child: Text(
                  existing == null ? 'Save address' : 'Update address',
                ),
              ),
            ],
          );
        },
      );
    } finally {
      //Allow the dailog's closing animation to finish
      // bofore disposing of its text controllers
      await Future<void>.delayed(
        const Duration(milliseconds: 400),
      );
      for (final controller in controllers) {
        controller.dispose();
      }
    }

    if (!mounted || values == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedAddress = DeliveryAddress(
        label: existing?.label ?? 'Home',
        fullName: values[0],
        phone: values[1],
        house: values[2],
        street: values[3],
        city: values[4],
        state: values[5],
        pinCode: values[6],
        landmark: values[7],
      );

      if (existing == null) {
        addressStore.save(updatedAddress);
      } else {
        addressStore.update(existing, updatedAddress);
      }

      if (!mounted) return;

      if (widget.selectForCheckout) {
        Navigator.of(context).pop(addressStore.selected);
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Delivery address saved successfully!',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Address save error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save the address. Please try again.',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _selectAddress(DeliveryAddress address) {
    addressStore.choose(address);

    if (widget.selectForCheckout) {
      Navigator.of(context).pop(address);
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectForCheckout
              ? 'Choose delivery address'
              : 'Saved addresses',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Go back',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: addressStore,
        builder: (context, _) {
          final addresses = addressStore.addresses;

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const Text(
                'YOUR DELIVERY ADDRESSES',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Save your delivery details and select an address at checkout.',
                style: TextStyle(
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              if (addresses.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 48,
                        color: AppColors.orange,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No delivery address yet',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Add your address so your Egg Macha order can be delivered to you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.muted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ...addresses.map((address) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.cream,
                      child: Icon(
                        Icons.home_outlined,
                        color: AppColors.orange,
                      ),
                    ),
                    title: Text(
                      '${address.label} · ${address.fullName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '${address.formatted}\n${address.phone}',
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: widget.selectForCheckout
                        ? const Icon(Icons.chevron_right)
                        : IconButton(
                            tooltip: 'Edit address',
                            icon: const Icon(Icons.edit_outlined),
                            onPressed:
                                _isSaving ? null : () => _addAddress(address),
                          ),
                    onTap: () => _selectAddress(address),
                  ),
                );
              }),
              const SizedBox(height: 12),
              PrimaryButton(
                label: _isSaving ? 'SAVING ADDRESS...' : 'ADD NEW ADDRESS',
                icon: Icons.add_location_alt_outlined,
                onTap: () {
                  if (!_isSaving) {
                    _addAddress();
                  }
                },
              ),
              const SizedBox(height: 12),
              if (widget.selectForCheckout && addresses.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Tap an address to select it for your order.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.muted,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
