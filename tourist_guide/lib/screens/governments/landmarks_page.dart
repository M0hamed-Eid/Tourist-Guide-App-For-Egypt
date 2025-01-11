

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'governorate.dart';

class LandmarksPage extends StatelessWidget {
  final Governorate governorate;

  const LandmarksPage({super.key, required this.governorate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(governorate.name),
      ),
      body: ListView.builder(
        itemCount: governorate.landmarks.length,
        itemBuilder: (context, index) {
          final landmark = governorate.landmarks[index];
          return Card(
            margin: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    landmark.image,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    tr(landmark.name),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    tr(landmark.info),
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}