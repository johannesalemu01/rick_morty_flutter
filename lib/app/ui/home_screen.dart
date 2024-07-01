import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty/app/model/character.dart';
import 'package:rick_and_morty/app/utils/query.dart';
import 'package:rick_and_morty/app/widgets/character_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedStatus;
  String? selectedGender;
  String? selectedSpecies;
  String searchText = '';

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(210, 8, 31, 41),
        title: Image.asset(
          "assets/logo.png",
          height: 62,
        ),
        leading: IconButton(
          color: Colors.white,
          iconSize: 25,
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 179, 200, 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DrawerHeader(
              margin: EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                color: Color.fromARGB(188, 8, 31, 41),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        height: 58,
                      ),
                    ],
                  ),
                  // SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Search by name',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 12, 69, 127),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: searchText.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    searchText = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Color.fromARGB(202, 187, 201, 199),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildFilterItem(
              'Status',
              _buildFilterDropdown(
                'Status',
                ['All', 'Alive', 'Dead', 'Unknown'],
                (String? value) {
                  setState(() {
                    selectedStatus = value == 'All' ? null : value!;
                  });
                  Navigator.pop(context); // Close the drawer after selection
                },
              ),
            ),
            _buildFilterItem(
              'Gender',
              _buildFilterDropdown(
                'Gender',
                ['All', 'Male', 'Female', 'unknown'],
                (String? value) {
                  setState(() {
                    selectedGender = value == 'All' ? null : value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            _buildFilterItem(
              'Species',
              _buildFilterDropdown(
                'Species',
                ['All', 'Human', 'Alien', 'Other'],
                (String? value) {
                  setState(() {
                    selectedSpecies = value == 'All' ? null : value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            BottomAppBar(
              color: Color.fromARGB(188, 8, 31, 41),
              padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Developed By: Yohannes Alemu",
                    style: TextStyle(
                        color: Color.fromARGB(255, 163, 187, 183),
                        fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          _launchURL('https://github.com/johannesalemu01');
                        },
                        child: SvgPicture.asset(
                          'assets/github.svg',
                          color: Color.fromARGB(171, 255, 255, 255),
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          _launchURL(
                              'https://www.linkedin.com/in/yohannes-alemu-093725262/');
                        },
                        child: SvgPicture.asset(
                          'assets/linkedin.svg',
                          color: Color.fromARGB(171, 255, 255, 255),
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          _launchURL('https://www.twitter.com/johannes_alemu');
                        },
                        child: SvgPicture.asset(
                          'assets/x-twitter.svg',
                          color: Color.fromARGB(171, 255, 255, 255),
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          _launchURL(
                            'https://www.facebook.com/johannes.alemu.1',
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/facebook.svg',
                          color: Color.fromARGB(171, 255, 255, 255),
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Query(
                  options: QueryOptions(
                    document: getAllCharacters,
                    variables: {"page": 1},
                  ),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.data != null) {
                      List<Character> characters =
                          (result.data!["characters"]["results"] as List)
                              .map((e) => Character.fromMap(e))
                              .toList();

                      // Apply filters
                      characters = characters.where((character) {
                        bool statusFilter = selectedStatus == null ||
                            character.status == selectedStatus;
                        bool genderFilter = selectedGender == null ||
                            character.gender == selectedGender;
                        bool speciesFilter = selectedSpecies == null ||
                            character.species == selectedSpecies;
                        bool nameFilter = searchText.isEmpty ||
                            character.name.toLowerCase().contains(searchText);

                        return statusFilter &&
                            genderFilter &&
                            speciesFilter &&
                            nameFilter;
                      }).toList();

                      return RefreshIndicator(
                        onRefresh: () async {
                          await refetch!();
                        },
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Center(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: characters
                                    .map((e) => CharacterWidget(character: e))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (result.isLoading && result.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return const Center(
                        child: Text("Something went wrong"),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(
      String title, List<String> options, void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          dropdownColor: Color.fromARGB(255, 105, 161, 140),
          value: options.first,
          decoration: InputDecoration(
            labelText: title,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(48.0),
            ),
          ),
          items: options
              .map((option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildFilterItem(String title, Widget dropdown) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          dropdown,
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      // ignore: deprecated_member_use
      await launch(uri.toString());
    } catch (e) {
      throw 'Could not launch $url: $e';
    }
  }
}
