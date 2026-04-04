import 'package:chess_position_binder/core/chess_recognizer.dart';
import 'package:chess_position_binder/core/isolated_board_from_image.dart';
import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:simple_chess_board/simple_chess_board.dart';

class PhotoOcrProcessPage extends StatefulWidget {
  final ChessRecognizer chessRecognizer;
  const PhotoOcrProcessPage({super.key, required this.chessRecognizer});

  @override
  State<PhotoOcrProcessPage> createState() => _PhotoOcrProcessPageState();
}

class _PhotoOcrProcessPageState extends State<PhotoOcrProcessPage> {
  bool _isProcessing = false;
  bool _isDisposed = false;
  bool _isSuccess = false;
  String? _resultFen;
  final ImagePicker _imagePicker = ImagePicker();
  Future<String?>? _fenFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (_isDisposed) return;
    try {
      developer.log(
        'Camera support available (using image_picker)',
        name: 'ChessboardOCR',
      );
    } catch (e) {
      developer.log('Camera initialization note: $e', name: 'ChessboardOCR');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      final imageBytes = await image.readAsBytes();
      await _processImage(imageBytes);
    } catch (e) {
      developer.log('Error picking image: $e', name: 'ChessboardOCR');
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  Future<void> _processImage(Uint8List imageData) async {
    if (_isDisposed) return;

    setState(() => _isProcessing = true);

    try {
      developer.log(
        'Processing image (${imageData.length} bytes)',
        name: 'ChessboardOCR',
      );

      // Extract isolated board
      final isolatedBoard = await extractChessboard(imageData);

      if (isolatedBoard == null || isolatedBoard.isEmpty) {
        throw Exception('Failed to extract chessboard from image');
      }

      // Generate FEN
      final img.Image? isolatedBoardImage = img.decodeImage(isolatedBoard);
      if (isolatedBoardImage == null) {
        throw Exception('Failed to decode isolated chessboard image');
      }
      final fen = await widget.chessRecognizer.predictFen(isolatedBoardImage);

      if (mounted && !_isDisposed) {
        _fenFuture = Future.value(fen);
        _resultFen = fen;
        _isSuccess = true;
        _isProcessing = false;
      }
    } catch (e) {
      developer.log('Error processing image: $e', name: 'ChessboardOCR');
      if (mounted && !_isDisposed) {
        setState(() {
          _resultFen = null;
          _isProcessing = false;
          _isSuccess = false;
        });
        _showErrorSnackBar('Failed to process image: $e');
      }
    }
  }

  Future<void> _takePhotoAndConvert() async {
    if (_isProcessing) return;

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) return;

    setState(() => _isProcessing = true);

    try {
      developer.log('Processing captured photo...', name: 'ChessboardOCR');
      final imageBytes = await image.readAsBytes();
      await _processImage(imageBytes);
    } catch (e) {
      developer.log('Error taking photo: $e', name: 'ChessboardOCR');
      if (mounted && !_isDisposed) {
        setState(() {
          _resultFen = null;
          _isSuccess = false;
          _isProcessing = false;
        });
        _showErrorSnackBar('Failed to take photo: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted || _isDisposed) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t.pages.photo_ocr.title), elevation: 0),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_fenFuture != null) {
      return _buildResultView();
    } else {
      return _buildCameraView();
    }
  }

  Widget _buildCameraView() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black87,
            child: const Center(
              child: Text(
                'Tap "Take Photo" to capture board image',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.camera),
                  label: const Text('Take Photo'),
                  onPressed: _isProcessing ? null : _takePhotoAndConvert,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text('Pick Image'),
                  onPressed: _isProcessing ? null : _pickImageFromGallery,
                ),
              ),
            ],
          ),
        ),
        if (_isProcessing) ...[
          const SizedBox(height: 10),
          const CircularProgressIndicator(),
          const SizedBox(height: 10),
          const Text('Processing image...'),
          const SizedBox(height: 10),
        ] else
          const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultView() {
    return FutureBuilder<String?>(
      future: _fenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _buildErrorView(snapshot.error);
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No result'));
        }

        final result = snapshot.data!;
        return _buildSuccessView(result, context);
      },
    );
  }

  Widget _buildErrorView(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _resetView,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _resetView() {
    if (mounted && !_isDisposed) {
      setState(() {
        _resultFen = null;
        _isSuccess = false;
        _fenFuture = null;
        _isProcessing = false;
      });
    }
  }

  void _validatePosition() {
    if (!_isSuccess || _resultFen == null) return;
    Navigator.of(context).pop(_resultFen);
  }

  Widget _buildSuccessView(String resultFen, BuildContext context) {
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: isPortrait ? 500 : 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SimpleChessBoard(
                fen: resultFen,
                whitePlayerType: PlayerType.computer,
                blackPlayerType: PlayerType.computer,
                cellHighlights: {},
                chessBoardColors: ChessBoardColors(),
                onMove: ({required move}) => (),
                onPromote: () => Future.value(PieceType.queen),
                onPromotionCommited:
                    ({required moveDone, required pieceType}) => (),
                onTap: ({required cellCoordinate}) => (),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _validatePosition,
              child: Text(t.misc.buttons.validate),
            ),
          ],
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<Uint8List?> heavyIsolationComputation(Uint8List imageData) async {
  try {
    developer.log(
      'Starting image processing in isolate',
      name: 'ChessboardOCR',
    );
    developer.log(
      'Image data size: ${imageData.length} bytes',
      name: 'ChessboardOCR',
    );

    final result = await extractChessboard(imageData);

    developer.log(
      'Image processing completed successfully',
      name: 'ChessboardOCR',
    );
    return result;
  } catch (e, stackTrace) {
    developer.log('Error in image processing: $e', name: 'ChessboardOCR');
    developer.log('Stack trace: $stackTrace', name: 'ChessboardOCR');
    rethrow; // Re-throw to let the UI handle it
  }
}
