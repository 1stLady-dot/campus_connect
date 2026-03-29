import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../models/event.dart';
import '../viewmodels/event_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _image;
  Position? _currentLocation;
  bool _isLoadingLocation = false;

  // --- LOGIC: DATE PICKER ---
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // --- LOGIC: CAMERA (Week 9 API) ---
  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  // --- LOGIC: GPS (Week 9 API) ---
  Future<void> _getLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() => _currentLocation = position);
      }
    } catch (e) {
      debugPrint("Location Error: $e");
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventVm = Provider.of<EventViewModel>(context, listen: false);
    final userId = Provider.of<AuthViewModel>(context, listen: false).user?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue[900]),
        title: Text("Report Incident", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TITLE & DESCRIPTION ---
            _buildSectionLabel("Incident Details"),
            const SizedBox(height: 10),
            _buildTextField(_titleController, "Incident Title (e.g. Theft, Fire)", Icons.title),
            const SizedBox(height: 15),
            _buildTextField(_descriptionController, "Describe what happened...", Icons.description, maxLines: 3),
            
            const SizedBox(height: 25),

            // --- DATE SELECTOR ---
            _buildSectionLabel("Date of Incident"),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.calendar_today, color: Colors.blue[800]),
              title: Text(_formatDate(_selectedDate)),
              trailing: TextButton(onPressed: _pickDate, child: const Text("Change")),
            ),

            const SizedBox(height: 25),

            // --- IMAGE PREVIEW & CAMERA ---
            _buildSectionLabel("Evidence Photo"),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _takePhoto,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _image == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.blue[800]),
                          const SizedBox(height: 10),
                          Text("Tap to open camera", style: TextStyle(color: Colors.grey[600])),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      ),
              ),
            ),

            const SizedBox(height: 25),

            // --- LOCATION TAGGING (Week 9 Proof) ---
            _buildSectionLabel("Location Data"),
            const SizedBox(height: 10),
            _isLoadingLocation 
              ? const Center(child: CircularProgressIndicator())
              : _currentLocation == null 
                ? ElevatedButton.icon(
                    onPressed: _getLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text("Capture GPS Location"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue[900],
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 0,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 10),
                        Text("Location Tagged: ${_currentLocation!.latitude.toStringAsFixed(4)}, ${_currentLocation!.longitude.toStringAsFixed(4)}"),
                      ],
                    ),
                  ),

            const SizedBox(height: 40),

            // --- SAVE BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (_titleController.text.isEmpty || _image == null || _currentLocation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please provide a title, photo, and location."))
                    );
                    return;
                  }

                  final newEvent = Event(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    description: _descriptionController.text,
                    date: _selectedDate,
                    imageUrl: _image?.path ?? '',
                    latitude: _currentLocation?.latitude,
                    longitude: _currentLocation?.longitude,
                    createdBy: userId,
                  );

                  await eventVm.addEvent(newEvent);
                  if (mounted) Navigator.pop(context);
                },
                child: const Text("SUBMIT REPORT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---
  Widget _buildSectionLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[700]));
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blue[800]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}