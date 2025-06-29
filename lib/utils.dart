// Файл сгенерирован нейросетью :)

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

Future<void> resizeImage(
  String inputPath,
  String outputPath,
  int targetSize,
) async {
  // Читаем изображение
  final image = img.decodeImage(await File(inputPath).readAsBytes());

  if (image == null) {
    debugPrint('Не удалось загрузить изображение');
    return;
  }

  // Проверяем, что целевой размер соответствует стандартным размерам icns
  const validIcnsSizes = [16, 32, 64, 128, 256, 512, 1024];
  if (!validIcnsSizes.contains(targetSize)) {
    debugPrint('Целевой размер должен быть одним из: $validIcnsSizes');
    return;
  }

  // Вычисляем пропорции и определяем новые размеры
  int maxDimension = image.width > image.height ? image.width : image.height;

  // Создаем новое квадратное изображение с прозрачным фоном
  final squareImage = img.Image(
    width: maxDimension,
    height: maxDimension,
    format: img.Format.uint8,
    numChannels: 4, // RGBA для поддержки прозрачности
  );

  // Заполняем фон прозрачным цветом (альфа = 0)
  img.fill(squareImage, color: img.ColorRgba8(0, 0, 0, 0));

  // Вычисляем позицию для центрирования исходного изображения
  int offsetX = (maxDimension - image.width) ~/ 2;
  int offsetY = (maxDimension - image.height) ~/ 2;

  // Копируем исходное изображение в центр квадратного холста
  img.compositeImage(squareImage, image, dstX: offsetX, dstY: offsetY);

  // Изменяем размер до целевого
  final resizedImage = img.copyResize(
    squareImage,
    width: targetSize,
    height: targetSize,
    interpolation: img.Interpolation.cubic, // Высокое качество для иконок
  );

  // Сохраняем изображение в формате PNG
  await File(outputPath).writeAsBytes(img.encodePng(resizedImage));
  debugPrint('Изображение успешно сохранено: $outputPath');
}

Offset centerEmojiOffset({
  required TextPainter textPainter,
  required Size canvasSize,
}) {
  final textSize = textPainter.size;

  // Попытка получить метрики строки
  final metrics = textPainter.computeLineMetrics();
  if (metrics.isNotEmpty) {
    final line = metrics.first;
    final ascent = line.ascent;
    final descent = line.descent;
    final lineHeight = ascent + descent;

    return Offset(
      (canvasSize.width - textSize.width) / 2,
      (canvasSize.height - lineHeight) / 2 + (lineHeight - textSize.height) / 2,
    );
  }

  // Фолбэк, если нет метрик
  return Offset(
    (canvasSize.width - textSize.width) / 2,
    (canvasSize.height - textSize.height) / 2,
  );
}

Future<Uint8List> addEmojiToImage(String emoji, Uint8List imageBytes) async {
  // Загружаем исходное изображение
  final image = img.decodeImage(imageBytes)!;

  // Создаем Recorder для рендеринга эмодзи
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);

  // Размер холста
  const canvasSize = Size(512, 512);

  // Рисуем эмодзи
  final textPainter = TextPainter(
    text: TextSpan(
      text: emoji, // Ваш эмодзи
      style: TextStyle(
        fontSize: 250,
        fontFamily: 'Apple Color Emoji', // Используется для macOS/iOS
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();

  // Получаем размер текста
  final textSize = textPainter.size;

  // Вычисляем координаты для центрирования
  final offset = Offset(
    (canvasSize.width - textSize.width) / 2 - 45,
    (canvasSize.height - textSize.height) / 2 - 30,
  );

  // Рисуем эмодзи по центру
  textPainter.paint(canvas, offset);

  // Конвертируем Canvas в изображение
  final uiImage = await recorder.endRecording().toImage(
    image.width,
    image.height,
  );
  final byteData = await uiImage.toByteData(format: ImageByteFormat.png);
  final emojiImage = img.decodeImage(byteData!.buffer.asUint8List())!;

  // Накладываем эмодзи на исходное изображение
  img.compositeImage(image, emojiImage, dstX: 50, dstY: 50);

  return img.encodePng(image);
}
