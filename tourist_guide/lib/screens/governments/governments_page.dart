import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_guide/core/routes/app_router.dart';
import '../base_page.dart';

import 'Landmark.dart';
import 'governorate.dart';

class GovernmentsPage extends StatelessWidget {
  final List<Governorate> governorates = [
    Governorate(
      name: tr('cairo'),
      image:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/Cairo_From_Tower_%28cropped%29.jpg/800px-Cairo_From_Tower_%28cropped%29.jpg',
      landmarks: [
        Landmark(
          name: tr('pyramids'),
          info: tr('pyramids_info'),
          image:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQY_bsVjL8UKWmMtOOHG0F68toberooJnkWzQ&s',
        ),
        Landmark(
          name: tr('cairo_tower'),
          info: tr('cairo_tower_info'),
          image:
              'https://mlrhpz8jmuut.i.optimole.com/cb:Ie5o.50122/w:auto/h:auto/q:mauto/f:best/ig:avif/id:40a2f389fb7b35660dfb2d3e8fe78434/https://www.egypttoursplus.com/Cairo-Tower-seen-from-the-Nile-River.jpg',
        ),
      ],
    ),
    Governorate(
      name: tr('alexandria'),
      image:
          'https://cdn.britannica.com/63/168963-050-383A1F92/reconstruction-Pharos-of-Alexandria-Egypt.jpg',
      landmarks: [
        Landmark(
          name: tr('library_of_alexandria'),
          info: tr('library_of_alexandria_info'),
          image:
              'https://www.egypttoursportal.com/images/2017/11/Alexandria-Library-Egypt-Tours-Portal.jpg',
        ),
        Landmark(
          name: tr('citadel_of_qaitbay'),
          info: tr('citadel_of_qaitbay_info'),
          image:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQV58AwTIC-jTGiUT29fI6vOKvxfheGreIh8Q&s',
        ),
      ],
    ),
    Governorate(
      name: tr('luxor'),
      image:
          'https://www.introducingegypt.com/f/egipto/egipto/guia/luxor-m.jpg',
      landmarks: [
        Landmark(
          name: tr('karnak_temple'),
          info: tr('karnak_temple_info'),
          image:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJxupWexalS1IyXWax-qokMiAvAHRcL1zxXQ&s',
        ),
        Landmark(
          name: tr('valley_of_kings'),
          info: tr('valley_of_kings_info'),
          image:
              'https://jakadatoursegypt.com/wp-content/uploads/2020/12/Untitled40-1.jpg',
        ),
      ],
    ),
  ];

  GovernmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      currentIndex: 1,
      appBar: AppBar(
        title: Text(tr('title')),
      ),
      body: ListView.builder(
        itemCount: governorates.length,
        itemBuilder: (context, index) {
          final governorate = governorates[index];
          return Card(
            margin: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.landmarks,
                  arguments: governorate,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      governorate.image,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      tr(governorate.name),
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
