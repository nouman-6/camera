import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraProvider extends ChangeNotifier {
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isFlashOn = false;
  bool _isInitialized = false;

  List<CameraDescription> get cameras => _cameras;
  int get selectedCameraIndex => _selectedCameraIndex;
  CameraController? get controller => _controller;
  Future<void>? get initializeControllerFuture => _initializeControllerFuture;
  bool get isFlashOn => _isFlashOn;
  bool get isInitialized => _isInitialized;

  Future<void> initCameras() async {
    if (_isInitialized) return;
    _cameras = await availableCameras();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> initController() async {
    if (_cameras.isEmpty) {
      throw Exception('No cameras available');
    }
    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;
    notifyListeners();
  }

  Future<void> toggleFlash() async {
    if (_controller == null) return;
    _isFlashOn = !_isFlashOn;
    await _controller!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    notifyListeners();
  }

  void switchCamera() {
    if (_cameras.length < 2 || _controller == null) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _controller!.dispose();
    _controller = null;
    notifyListeners();
  }

  Future<XFile?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    try {
      return await _controller!.takePicture();
    } catch (e) {
      debugPrint('Error taking picture: $e');
      return null;
    }
  }
}
