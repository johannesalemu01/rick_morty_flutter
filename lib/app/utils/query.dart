import 'package:graphql_flutter/graphql_flutter.dart';

final getAllCharacters = gql(r"""
  query GetCharacters($page: Int) {
    characters(page: $page) {
      info {
        next
      }
      results {
        id
        status
        species
        gender
        image
        type
        name
        location {
          name
        }
      }
    }
  }
""");
