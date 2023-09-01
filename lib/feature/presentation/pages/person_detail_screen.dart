import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rick_app/common/app_colors.dart';
import 'package:rick_app/feature/domain/entities/person_entity.dart';
import 'package:rick_app/feature/presentation/widget/person_cache_image_widget.dart';

class PersonDetailPage extends StatelessWidget {
  final PersonEntity person;
  const PersonDetailPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Character'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
            ),
            Text(
              person.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              child: PersonCacheImage(
                height: 260,
                width: 260,
                imageUrl: person.image,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                    color: person.status == 'Alive' ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  person.status,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 1,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            ...buildText('Gender:', person.gender),
            ...buildText(
                'Number of episodes:', person.episode.length.toString()),
            ...buildText('Species:', person.species),
            ...buildText('Last know location:', person.location.name),
            ...buildText('Origin:', person.origin.name),
            ...buildText('Was created:', person.created.toString()),
          ],
        ),
      ),
    );
  }

  List<Widget> buildText(String text, String value) {
    return [
      Text(
        text,
        style: TextStyle(
          color: AppColors.greyColor,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      SizedBox(
        height: 12,
      ),
    ];
  }
}
