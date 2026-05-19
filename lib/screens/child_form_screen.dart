// filepath: pee_ka_boo/lib/screens/child_form_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChildFormScreen extends StatefulWidget {
  final String? childId; // For editing existing child

  const ChildFormScreen({super.key, this.childId});

  @override
  State<ChildFormScreen> createState() => _ChildFormScreenState();
}

class _ChildFormScreenState extends State<ChildFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _currentStep = 0;

  // Controllers
  final _fullNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _dobController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _previousDayCareController = TextEditingController();

  // Parent 1
  final _parent1NameController = TextEditingController();
  final _parent1RelationController = TextEditingController();
  final _parent1MobileController = TextEditingController();
  final _parent1EmailController = TextEditingController();
  final _parent1OccupationController = TextEditingController();

  // Parent 2
  final _parent2NameController = TextEditingController();
  final _parent2RelationController = TextEditingController();
  final _parent2MobileController = TextEditingController();
  final _parent2EmailController = TextEditingController();
  final _parent2OccupationController = TextEditingController();

  // Emergency Contact
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyNumberController = TextEditingController();

  // Health
  final _bloodGroupController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicalConditionsController = TextEditingController();
  final _doctorController = TextEditingController();

  // Attendance
  DateTime? _preferredStartDate;
  final List<String> _selectedDays = [];
  String _timingType = 'Full Day';
  final _customStartController = TextEditingController();
  final _customEndController = TextEditingController();
  final List<String> _selectedMeals = [];

  // Billing
  static const double _fullDayRatePerHour = 1200;
  static const double _partTimeRatePerHour = 80;
  int _registeredHours = 8;
  final _dayCareChargesController = TextEditingController(text: '9600');
  final _mealChargesController = TextEditingController(text: '0');
  final _totalAmountController = TextEditingController(text: '9600');

  // Pickup Persons
  final List<Map<String, TextEditingController>> _pickupPersons = [
    {
      'name': TextEditingController(),
      'relation': TextEditingController(),
      'contact': TextEditingController()
    },
    {
      'name': TextEditingController(),
      'relation': TextEditingController(),
      'contact': TextEditingController()
    },
    {
      'name': TextEditingController(),
      'relation': TextEditingController(),
      'contact': TextEditingController()
    },
    {
      'name': TextEditingController(),
      'relation': TextEditingController(),
      'contact': TextEditingController()
    },
  ];

  // Additional
  final _specialNeedsController = TextEditingController();
  final _habitsController = TextEditingController();
  final _comfortItemsController = TextEditingController();

  String _gender = 'Male';

  @override
  void dispose() {
    _fullNameController.dispose();
    _nicknameController.dispose();
    _dobController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pinCodeController.dispose();
    _previousDayCareController.dispose();
    _parent1NameController.dispose();
    _parent1RelationController.dispose();
    _parent1MobileController.dispose();
    _parent1EmailController.dispose();
    _parent1OccupationController.dispose();
    _parent2NameController.dispose();
    _parent2RelationController.dispose();
    _parent2MobileController.dispose();
    _parent2EmailController.dispose();
    _parent2OccupationController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyNumberController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    _medicalConditionsController.dispose();
    _doctorController.dispose();
    _customStartController.dispose();
    _customEndController.dispose();
    _dayCareChargesController.dispose();
    _mealChargesController.dispose();
    _totalAmountController.dispose();
    _specialNeedsController.dispose();
    _habitsController.dispose();
    _comfortItemsController.dispose();
    for (var person in _pickupPersons) {
      person['name']!.dispose();
      person['relation']!.dispose();
      person['contact']!.dispose();
    }
    super.dispose();
  }

  void _calculateTotal() {
    final dayCare = double.tryParse(_dayCareChargesController.text) ?? 0;
    final meal = double.tryParse(_mealChargesController.text) ?? 0;
    _totalAmountController.text = (dayCare + meal).toString();
  }

  void _calculateRegisteredHours() {
    switch (_timingType) {
      case 'Full Day':
        _registeredHours = 8;
        break;
      case 'Half Day':
        _registeredHours = 4;
        break;
      case 'Custom Hours':
        final   start = int.tryParse(_customStartController.text) ?? 0;
        final end = int.tryParse(_customEndController.text) ?? 0;
        if (end > start) {
          _registeredHours = end - start;
        } else if (end < start) {
          // Handle overnight (e.g., 10 PM to 2 AM)
          _registeredHours = (24 - start) + end;
        } else {
          _registeredHours = 0;
        }
        break;
      default:
        _registeredHours = 8;
    }
    _calculateDayCareCharges();
  }

  void _calculateDayCareCharges() {
    double dayCareCharges;
    final int selectedDaysCount = _selectedDays.isEmpty ? 0 : _selectedDays.length;
    final int workingDays =  selectedDaysCount * 4;

    if (selectedDaysCount == 5) {
      // Full Day rate: ₹1200 × hours
      dayCareCharges = _fullDayRatePerHour * _registeredHours;
    } else {
      // Part-time rate: ₹70 × hours × (days selected × 4 weeks)
      dayCareCharges = _partTimeRatePerHour * _registeredHours * workingDays;
    }
    _dayCareChargesController.text = dayCareCharges.toInt().toString();
    _calculateTotal();
  }

  Future<void> _selectDate(BuildContext context, bool isDob) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isDob) {
          _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
          _ageController.text = (DateTime.now().year - picked.year).toString();
        } else {
          _preferredStartDate = picked;
        }
      });
    }
  }

  Future<void> _saveChild() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final childData = {
        'fullName': _fullNameController.text,
        'nickname': _nicknameController.text,
        'dateOfBirth':
            _dobController.text.isNotEmpty ? _dobController.text : null,
        'age': int.tryParse(_ageController.text),
        'gender': _gender,
        'homeAddress': _addressController.text,
        'city': _cityController.text,
        'pinCode': _pinCodeController.text,
        'previousDayCareHistory': _previousDayCareController.text,
        'parent1Name': _parent1NameController.text,
        'parent1Relationship': _parent1RelationController.text,
        'parent1Mobile': _parent1MobileController.text,
        'parent1Email': _parent1EmailController.text,
        'parent1Occupation': _parent1OccupationController.text,
        'parent2Name': _parent2NameController.text,
        'parent2Relationship': _parent2RelationController.text,
        'parent2Mobile': _parent2MobileController.text,
        'parent2Email': _parent2EmailController.text,
        'parent2Occupation': _parent2OccupationController.text,
        'emergencyContactName': _emergencyNameController.text,
        'emergencyContactRelationship': _emergencyRelationController.text,
        'emergencyContactNumber': _emergencyNumberController.text,
        'bloodGroup': _bloodGroupController.text,
        'allergies': _allergiesController.text,
        'medicalConditions': _medicalConditionsController.text,
        'doctorNameAndContact': _doctorController.text,
        'preferredStartDate': _preferredStartDate?.toIso8601String(),
        'daysOfAttendance': _selectedDays,
        'timingType': _timingType,
        'customHoursStart': int.tryParse(_customStartController.text),
        'customHoursEnd': int.tryParse(_customEndController.text),
        'mealOptions': _selectedMeals,
        'daysPerWeek': _selectedDays.length,
        'registeredHours': _registeredHours,
        'dayCareCharges': double.tryParse(_dayCareChargesController.text) ?? 0,
        'fullDayRatePerHour': _fullDayRatePerHour,
        'partTimeRatePerHour': _partTimeRatePerHour,
        'rateType': _registeredHours >= 8 ? 'Full Day' : 'Part-time',
        'workingDaysPerMonth':
            _selectedDays.isEmpty ? 20 : _selectedDays.length * 4,
        'mealCharges': double.tryParse(_mealChargesController.text) ?? 0,
        'totalAmount': double.tryParse(_totalAmountController.text) ?? 0,
        'authorizedPickupPersons': _pickupPersons
            .where((p) => p['name']!.text.isNotEmpty)
            .map((p) => {
                  'name': p['name']!.text,
                  'relation': p['relation']!.text,
                  'contact': p['contact']!.text,
                })
            .toList(),
        'specialNeeds': _specialNeedsController.text,
        'habits': _habitsController.text,
        'comfortItems': _comfortItemsController.text,
        'isActive': true,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await FirebaseFirestore.instance.collection('children').add(childData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Child registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register New Child'),
        backgroundColor: Colors.pink[400],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 7) {
              setState(() => _currentStep++);
            } else {
              _saveChild();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[400],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(_currentStep == 7 ? 'Save' : 'Continue'),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Child Information
            Step(
              title: const Text('Child Info'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Full Name *'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nicknameController,
                    decoration: const InputDecoration(labelText: 'Nickname'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dobController,
                          decoration:
                              const InputDecoration(labelText: 'Date of Birth'),
                          readOnly: true,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(labelText: 'Age'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _gender,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    items: ['Male', 'Female', 'Other']
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => setState(() => _gender = v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressController,
                    decoration:
                        const InputDecoration(labelText: 'Home Address'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(labelText: 'City'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _pinCodeController,
                          decoration:
                              const InputDecoration(labelText: 'Pin Code'),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _previousDayCareController,
                    decoration: const InputDecoration(
                        labelText: 'Previous Day Care History'),
                  ),
                ],
              ),
            ),
            // Step 2: Parent Information
            Step(
              title: const Text('Parent Info'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Parent 1 (Primary Contact)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent1NameController,
                    decoration: const InputDecoration(labelText: 'Name *'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent1RelationController,
                    decoration:
                        const InputDecoration(labelText: 'Relationship *'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent1MobileController,
                    decoration: const InputDecoration(labelText: 'Mobile *'),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent1EmailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent1OccupationController,
                    decoration: const InputDecoration(labelText: 'Occupation'),
                  ),
                  const SizedBox(height: 24),
                  const Text('Parent 2 (Optional)',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent2NameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent2RelationController,
                    decoration:
                        const InputDecoration(labelText: 'Relationship'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent2MobileController,
                    decoration: const InputDecoration(labelText: 'Mobile'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent2EmailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _parent2OccupationController,
                    decoration: const InputDecoration(labelText: 'Occupation'),
                  ),
                ],
              ),
            ),
            // Step 3: Emergency Contact
            Step(
              title: const Text('Emergency Contact'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    controller: _emergencyNameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emergencyRelationController,
                    decoration: const InputDecoration(
                        labelText: 'Relationship to Child'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emergencyNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Number'),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            // Step 4: Health Information
            Step(
              title: const Text('Health Info'),
              isActive: _currentStep >= 3,
              state: _currentStep > 3 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    controller: _bloodGroupController,
                    decoration: const InputDecoration(labelText: 'Blood Group'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _allergiesController,
                    decoration:
                        const InputDecoration(labelText: 'Allergies (if any)'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _medicalConditionsController,
                    decoration:
                        const InputDecoration(labelText: 'Medical Conditions'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _doctorController,
                    decoration: const InputDecoration(
                        labelText: "Doctor's Name & Contact"),
                  ),
                ],
              ),
            ),
            // Step 5: Attendance & Schedule
            Step(
              title: const Text('Schedule'),
              isActive: _currentStep >= 4,
              state: _currentStep > 4 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Days of Attendance *',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'].map((day) {
                      final isSelected = _selectedDays.contains(day);
                      return FilterChip(
                        label: Text(day),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedDays.add(day);
                            } else {
                              _selectedDays.remove(day);
                            }
                          });
                          _calculateDayCareCharges();
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Timing *',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _timingType,
                    decoration:
                        const InputDecoration(labelText: 'Select Timing'),
                    items: ['Full Day', 'Half Day', 'Custom Hours']
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _timingType = v!);
                      _calculateRegisteredHours();
                    },
                  ),
                  if (_timingType == 'Custom Hours') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _customStartController,
                            decoration: const InputDecoration(
                                labelText: 'Start Hour (0-23)'),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _calculateRegisteredHours(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _customEndController,
                            decoration: const InputDecoration(
                                labelText: 'End Hour (0-23)'),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => _calculateRegisteredHours(),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Text('Meal Options',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['Breakfast', 'Lunch', 'Snacks'].map((meal) {
                      final isSelected = _selectedMeals.contains(meal);
                      return FilterChip(
                        label: Text(meal),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedMeals.add(meal);
                              _updateMealCharges();
                            } else {
                              _selectedMeals.remove(meal);
                              _updateMealCharges();
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            // Step 6: Billing
            Step(
              title: const Text('Billing'),
              isActive: _currentStep >= 5,
              state: _currentStep > 5 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fee Structure (As per T&C)',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('• Full Day (8+ hrs): ₹1,200/hour'),
                        const Text(
                            '• Part-time (<8 hrs): ₹70/hour × days × 4 weeks'),
                        const SizedBox(height: 4),
                        const Text('Examples (5 days/week):',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        const Text('  - 8 hrs: ₹1,200 × 8 = ₹9,600'),
                        const Text('  - 4 hrs: ₹70 × 4 × 20 = ₹5,600'),
                        const Text('  - 2 hrs: ₹70 × 2 × 20 = ₹2,800'),
                        const SizedBox(height: 4),
                        const Text('• Snacks/Breakfast: ₹700/month'),
                        const Text('• Lunch: ₹1000/month'),
                        const Text('• Late fee: ₹100/day after 5th'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Registered Hours Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Registered Hours:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '$_registeredHours hours/day',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _dayCareChargesController,
                          decoration: InputDecoration(
                            labelText: 'Day Care Charges (₹)',
                            prefixText: '₹ ',
                            helperText: _registeredHours >= 8
                                ? '₹${_fullDayRatePerHour.toInt()} × $_registeredHours hrs'
                                : '₹${_partTimeRatePerHour.toInt()} × $_registeredHours hrs × ${_selectedDays.length * 4} days',
                          ),
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _mealChargesController,
                          decoration: const InputDecoration(
                            labelText: 'Meal Charges (₹)',
                            prefixText: '₹ ',
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _calculateTotal(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _totalAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Total Amount (₹)',
                      prefixText: '₹ ',
                    ),
                    readOnly: true,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            // Step 7: Authorized Pick-up
            Step(
              title: const Text('Pick-up Persons'),
              isActive: _currentStep >= 6,
              state: _currentStep > 6 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Authorized Persons to Pick-up Child',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _pickupPersons[index]['name'],
                              decoration: InputDecoration(
                                  labelText: 'Name ${index + 1}'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _pickupPersons[index]['relation'],
                              decoration:
                                  const InputDecoration(labelText: 'Relation'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _pickupPersons[index]['contact'],
                              decoration:
                                  const InputDecoration(labelText: 'Contact'),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Step 8: Additional Info
            Step(
              title: const Text('Additional'),
              isActive: _currentStep >= 7,
              state: StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _specialNeedsController,
                    decoration:
                        const InputDecoration(labelText: 'Any Special Needs'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _habitsController,
                    decoration: const InputDecoration(labelText: 'Habits'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _comfortItemsController,
                    decoration: const InputDecoration(
                        labelText: 'Comfort Items (toy, blanket, etc.)'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'By submitting, you declare that the above information is true to the best of your knowledge.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
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

  void _updateMealCharges() {
    double mealCharges = 0;
    if (_selectedMeals.contains('Breakfast') ||
        _selectedMeals.contains('Snacks')) {
      mealCharges += 700;
    }
    if (_selectedMeals.contains('Lunch')) {
      mealCharges += 1000;
    }
    _mealChargesController.text = mealCharges.toString();
    _calculateTotal();
  }
}
