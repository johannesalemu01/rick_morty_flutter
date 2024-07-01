import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({required this.id, Key? key}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HttpLink httpLink = HttpLink(
      'https://rickandmortyapi.com/graphql',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Character Details'),
          backgroundColor: Color.fromARGB(247, 130, 146, 146),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                Color.fromARGB(174, 0, 0, 0),
                Colors.transparent,
                Colors.white54,
                Colors.transparent,
              ],
            ),
          ),
          child: Query(
            options: QueryOptions(
              document: gql(r"""
                query GetCharacter($id: ID!) {
                  character(id: $id) {
                    id
                    name
                    status
                    species
                    type
                    gender
                    origin {
                      name
                    }
                    location {
                      name
                    }
                    image
                    episode {
                      id
                      name
                    }
                  }
                }
              """),
              variables: {
                'id': id,
              },
            ),
            builder: (QueryResult result, {fetchMore, refetch}) {
              if (result.hasException) {
                return Center(
                  child: Text(
                    result.exception.toString(),
                    style: const TextStyle(color: Colors.black87),
                  ),
                );
              }

              if (result.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var character = result.data!['character'];
              var episodes = character['episode'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          character['image'],
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 40,
                      thickness: 0.4,
                      indent: 10,
                      endIndent: 10,
                      color: Color.fromARGB(117, 6, 67, 43),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      character['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(189, 0, 0, 0),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 2,
                      indent: 3,
                      endIndent: 300,
                      color: Color.fromARGB(255, 123, 190, 164),
                    ),
                    const Divider(
                      height: 10,
                      thickness: 3,
                      indent: 3,
                      endIndent: 250,
                      color: Color.fromARGB(255, 123, 190, 164),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: ${character['status']}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text(
                      'Species: ${character['species']}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text(
                      'Type: ${character['type']}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text(
                      'Gender: ${character['gender']}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text(
                      'Origin: ${character['origin']['name']}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    Text(
                      'Location: ${character['location']['name']}',
                      style: TextStyle(color: Colors.black87),
                    ),
                    const Divider(
                      height: 40,
                      thickness: 0.4,
                      indent: 10,
                      endIndent: 10,
                      color: Color.fromARGB(117, 6, 67, 43),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Episodes:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: episodes
                          .map<Widget>(
                              (episode) => _buildEpisodeBox(context, episode))
                          .toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodeBox(BuildContext context, dynamic episode) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => EpisodeDetailScreen(episodeId: episode['id']),
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(200, 0, 0, 0),
              Colors.teal.shade200,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              episode['name'],
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              'Episode ID: ${episode['id']}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EpisodeDetailScreen extends StatelessWidget {
  final String episodeId;

  const EpisodeDetailScreen({Key? key, required this.episodeId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      'https://rickandmortyapi.com/graphql',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: Scaffold(
        backgroundColor: Color.fromARGB(193, 66, 69, 70),
        appBar: AppBar(
          title: const Text('Episode Detail'),
          backgroundColor: const Color.fromARGB(192, 149, 180, 189),
        ),
        body: Query(
          options: QueryOptions(
            document: gql(r"""
              query GetEpisode($episodeId: ID!) {
                episode(id: $episodeId) {
                  id
                  name
                  air_date
                  episode
                  characters {
                    id
                    name
                    image
                  }
                }
              }
            """),
            variables: {
              'episodeId': episodeId,
            },
          ),
          builder: (QueryResult result, {fetchMore, refetch}) {
            if (result.hasException) {
              return Center(
                child: Text(
                  result.exception.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            if (result.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var episode = result.data!['episode'];

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Air Date: ${episode['air_date']}',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Episode Code: ${episode['episode']}',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Characters:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: (episode['characters'] as List<dynamic>)
                        .map<Widget>(
                            (character) => _buildCharacterCard(character))
                        .toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCharacterCard(dynamic character) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                character['image'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character['name'],
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Character ID: ${character['id']}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
