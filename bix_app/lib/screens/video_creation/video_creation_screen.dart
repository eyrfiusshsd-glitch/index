import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../../constants/app_colors.dart';

class VideoCreationScreen extends StatefulWidget {
  const VideoCreationScreen({super.key});

  @override
  State<VideoCreationScreen> createState() => _VideoCreationScreenState();
}

class _VideoCreationScreenState extends State<VideoCreationScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isRecording = false;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  double _currentZoom = 1.0;
  
  final List<String> _filters = [
    'عادي',
    'جميل',
    'كلاسيكي',
    'دافئ',
    'بارد',
    'أبيض وأسود',
  ];
  
  String _selectedFilter = 'عادي';
  
  final List<String> _effects = [
    'بدون تأثير',
    'تأثير الوجه',
    'تأثير الخلفية',
    'تأثير الألوان',
  ];
  
  String _selectedEffect = 'بدون تأثير';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![_isFrontCamera ? 1 : 0],
          ResolutionPreset.high,
          enableAudio: true,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_cameraController != null && _cameraController!.value.isInitialized)
            Positioned.fill(
              child: CameraPreview(_cameraController!),
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),

          // Top controls
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),

                  // Top center controls
                  Row(
                    children: [
                      // Flash
                      GestureDetector(
                        onTap: _toggleFlash,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFlashOn ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Timer
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.timer,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),

                  // Settings
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Left side tools
          Positioned(
            left: 16,
            top: 120,
            child: Column(
              children: [
                // Text tool
                _buildToolButton(
                  Icons.text_fields,
                  'Aa',
                  () {},
                ),
                
                const SizedBox(height: 20),
                
                // Infinity tool
                _buildToolButton(
                  Icons.all_inclusive,
                  '',
                  () {},
                ),
                
                const SizedBox(height: 20),
                
                // Layout tool
                _buildToolButton(
                  Icons.view_module,
                  '',
                  () {},
                ),
                
                const SizedBox(height: 20),
                
                // More tools
                _buildToolButton(
                  Icons.keyboard_arrow_down,
                  '',
                  () {},
                ),
              ],
            ),
          ),

          // Right side effects
          Positioned(
            right: 16,
            top: 120,
            child: Column(
              children: [
                // Effects
                GestureDetector(
                  onTap: _showEffectsPanel,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.auto_fix_high,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Filters
                GestureDetector(
                  onTap: _showFiltersPanel,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.filter_vintage,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Beauty
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.face_retouching_natural,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gallery
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  // Record button
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isRecording ? AppColors.primary : Colors.white,
                          shape: _isRecording ? BoxShape.rectangle : BoxShape.circle,
                          borderRadius: _isRecording ? BorderRadius.circular(8) : null,
                        ),
                      ),
                    ),
                  ),

                  // Flip camera
                  GestureDetector(
                    onTap: _flipCamera,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.flip_camera_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Recording indicator
          if (_isRecording)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'تسجيل',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom options
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBottomOption('نشر', false),
                  const SizedBox(width: 20),
                  _buildBottomOption('قصة', false),
                  const SizedBox(width: 20),
                  _buildBottomOption('مراسلة', false),
                  const SizedBox(width: 20),
                  _buildBottomOption('بث مباشر', false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(25),
        ),
        child: text.isNotEmpty
            ? Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
      ),
    );
  }

  Widget _buildBottomOption(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    
    if (_isRecording) {
      // Start recording
      _cameraController?.startVideoRecording();
    } else {
      // Stop recording
      _cameraController?.stopVideoRecording().then((file) {
        // Handle recorded video
        print('Video recorded: ${file.path}');
      });
    }
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _cameraController?.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  void _flipCamera() async {
    if (_cameras != null && _cameras!.length > 1) {
      setState(() {
        _isFrontCamera = !_isFrontCamera;
      });
      
      await _cameraController?.dispose();
      _cameraController = CameraController(
        _cameras![_isFrontCamera ? 1 : 0],
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  void _showFiltersPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'الفلاتر',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        filter,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEffectsPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'التأثيرات',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _effects.length,
                itemBuilder: (context, index) {
                  final effect = _effects[index];
                  final isSelected = effect == _selectedEffect;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEffect = effect;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        effect,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}