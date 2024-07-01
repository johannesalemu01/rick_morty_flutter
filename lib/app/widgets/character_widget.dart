import 'package:flutter/material.dart';
import 'package:rick_and_morty/app/model/character.dart';
import 'package:rick_and_morty/app/ui/detail_screen.dart';

class CharacterWidget extends StatelessWidget {
  final Character character;
  const CharacterWidget({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor =
        character.status.toLowerCase() == 'alive' ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(id: character.id),
          ),
        );
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.white,
              Colors.transparent,
              Colors.black,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                character.image,
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              character.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                  ),
                  margin: const EdgeInsets.only(right: 5),
                ),
                Text(character.status),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 16, color: Color.fromARGB(120, 11, 21, 203)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    character.location,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.pets,
                    size: 16, color: Color.fromARGB(195, 74, 103, 166)),
                const SizedBox(width: 4),
                Text(character.species),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
